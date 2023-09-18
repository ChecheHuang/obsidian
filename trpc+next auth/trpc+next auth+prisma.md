## Nextjs App Router 配置

### 配置next auth 和trpc api路由

app/api/auth/[...nextauth]/route.ts
``` typescript
import prismadb from '@/lib/prismadb'
import prisma from '@/lib/prismadb'
import { PrismaAdapter } from '@next-auth/prisma-adapter'
import bcrypt from 'bcrypt'
import NextAuth from 'next-auth'
import { AuthOptions } from 'next-auth'
import { getServerSession } from 'next-auth'
import CredentialsProvider from 'next-auth/providers/credentials'
import { redirect } from 'next/navigation'

export const authOptions: AuthOptions = {
  adapter: PrismaAdapter(prisma),
  providers: [
    CredentialsProvider({
      name: 'credentials',
      credentials: {
        name: { label: 'name', type: 'text' },
        password: { label: 'password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.name || !credentials?.password) {
          throw new Error('Invalid credentials')
        }
        const user = await prismadb.admin.findFirst({
          where: {
            name: credentials.name,
          },
        })
        if (!user || !user?.password) {
          throw new Error('Invalid credentials')
        }

        const isCorrectPassword = await bcrypt.compare(
          credentials.password,
          user.password,
        )

        if (!isCorrectPassword) {
          throw new Error('Invalid credentials')
        }
        return {
          id: user.id.toString(),
          name: user.name,
          password: user.password,
        }
      },
    }),
  ],
  debug: process.env.NODE_ENV === 'development',
  session: {
    strategy: 'jwt',
  },
  secret: process.env.NEXTAUTH_SECRET,
}

export const getUserAuth = async () => {
  const session = await getServerSession(authOptions)
  return { session }
}

export const checkAuth = async () => {
  const { session } = await getUserAuth()
  if (!session) redirect('/api/auth/signin')
}

const handler = NextAuth(authOptions)

export { handler as GET, handler as POST }

```


app/api/trpc/[trpc]/route.ts
``` typescript
import { getUserAuth } from '@/app/api/auth/[...nextauth]/auth'
import { appRouter } from '@/server'
import { fetchRequestHandler } from '@trpc/server/adapters/fetch'
import { FetchCreateContextFnOptions } from '@trpc/server/adapters/fetch'

export async function createContext(opts?: FetchCreateContextFnOptions) {
  const { session } = await getUserAuth()

  return {
    session: session,
    headers: opts && Object.fromEntries(opts.req.headers),
  }
}

export type Context = Awaited<ReturnType<typeof createContext>>

const handler = (req: Request) =>
  fetchRequestHandler({
    endpoint: '/api/trpc',
    req,
    router: appRouter,
    createContext,
  })

export { handler as GET, handler as POST }
```

### 配置provider 和 client trpc和 server trpc
/components/providers/queryProvider.tsx
``` typescript
'use client'

import trpc from '@/lib/_trpc/trpcClient'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { httpBatchLink } from '@trpc/client'
import { SessionProvider } from 'next-auth/react'
import { useState } from 'react'
import SuperJSON from 'superjson'

export const QueryProvider = ({ children }: { children: React.ReactNode }) => {
  const [queryClient] = useState(() => new QueryClient())
  const [trpcClient] = useState(() =>
    trpc.createClient({
      transformer: SuperJSON,
      links: [
        httpBatchLink({
          url: getUrl(),
        }),
      ],
    }),
  )
  return (
    <trpc.Provider client={trpcClient} queryClient={queryClient}>
      <QueryClientProvider client={queryClient}>
        <SessionProvider>{children}</SessionProvider>
      </QueryClientProvider>
    </trpc.Provider>
  )
}
function getUrl() {
  if (typeof window !== 'undefined') return ''
  if (process.env.VERCEL_URL)
    return `https://${process.env.VERCEL_URL}/api/trpc`
  return 'http://localhost:3000/api/trpc'
}
```

/lib/_trpc/trpcClient.ts
``` typescript
import { type AppRouter } from '@/server'
import { createTRPCReact } from '@trpc/react-query'

const trpcClient = createTRPCReact<AppRouter>({})

export default trpcClient
```
/lib/_trpc/trpcServer.ts
``` typescript
import { getUserAuth } from '@/app/api/auth/[...nextauth]/route'
import { appRouter } from '@/server'
import { loggerLink } from '@trpc/client'
import { experimental_nextCacheLink as nextCacheLink } from '@trpc/next/app-dir/links/nextCache'
import { experimental_createTRPCNextAppDirServer as createTRPCNextAppDirServer } from '@trpc/next/app-dir/server'
import { cookies } from 'next/headers'
import SuperJSON from 'superjson'

const trpcServer = createTRPCNextAppDirServer<typeof appRouter>({
  config() {
    return {
      transformer: SuperJSON,
      links: [
        loggerLink({
          enabled: (op) => true,
        }),
        nextCacheLink({
          revalidate: 1,
          router: appRouter,
          async createContext() {
            const { session } = await getUserAuth()
            return {
              session,
              headers: {
                cookie: cookies().toString(),
                'x-trpc-source': 'rsc-invoke',
              },
            }
          },
        }),
      ],
    }
  },
})
export default trpcServer
```
### 設置router
/server/trpc.ts
``` typescript
import type { Context } from '@/app/api/trpc/[trpc]/route'
import { initTRPC, TRPCError } from '@trpc/server'
import superjson from 'superjson'
import { ZodError } from 'zod'

const t = initTRPC.context<Context>().create({
  transformer: superjson,
  errorFormatter({ shape, error }) {
    return {
      ...shape,
      data: {
        ...shape.data,
        zodError:
          error.cause instanceof ZodError ? error.cause.flatten() : null,
      },
    }
  },
})

export const router = t.router
export const publicProcedure = t.procedure

const enforceUserIsAuthed = t.middleware(({ ctx, next }) => {
  if (!ctx.session?.user) {
    throw new TRPCError({ code: 'UNAUTHORIZED' })
  }
  return next({
    ctx: {
      session: { ...ctx.session, user: ctx.session.user },
    },
  })
})
export const protectedProcedure = t.procedure.use(enforceUserIsAuthed)

```

server/index.ts
``` typescript
import { router, publicProcedure, protectedProcedure } from './trpc'
import { z } from 'zod'

const todos = ['first', 'second', 'third']

export const appRouter = router({
  get: publicProcedure.query(() => {
    return todos
  }),
  addTodo: protectedProcedure
    .input(z.object({ todo: z.string() }))
    .mutation((req) => {
      console.log(req.input.todo)
      todos.push(req.input.todo)
      return req.input.todo
    }),
})

export type AppRouter = typeof appRouter

```


