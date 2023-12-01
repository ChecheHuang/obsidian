
app/api/trpc/[trpc]/context.ts
``` typescript!
import { getUserAuth } from '@/app/api/auth/[...nextAuth]/options'
import { FetchCreateContextFnOptions } from '@trpc/server/adapters/fetch'

export async function createContext(opts?: FetchCreateContextFnOptions) {
  const { session } = await getUserAuth()

  return {
    session: session,
    headers: opts && Object.fromEntries(opts.req.headers),
  }
}

export type Context = Awaited<ReturnType<typeof createContext>>
```

server/trpc.ts
``` typescript
import type { Context } from '@/app/api/trpc/[trpc]/context'
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
import { router, publicProcedure } from './trpc'
import { z } from 'zod'

const todos = ['first', 'second', 'third']

export const appRouter = router({
  get: publicProcedure.query(() => {
    return todos
  }),
  addTodo: publicProcedure
    .input(z.object({ todo: z.string() }))
    .mutation((req) => {
      console.log(req.input.todo)
      todos.push(req.input.todo)
      return req.input.todo
    }),
})

export type AppRouter = typeof appRouter

```

app/api/trpc/[trpc]/route.ts
``` typescript
import { createContext } from './context'
import { appRouter } from '@/server'
import { fetchRequestHandler } from '@trpc/server/adapters/fetch'

const handler = (req: Request) =>
  fetchRequestHandler({
    endpoint: '/api/trpc',
    req,
    router: appRouter,
    createContext,
  })

export { handler as GET, handler as POST }

```


lib/trpc/trpcClient.ts
``` typescript
import { type AppRouter } from '@/server'
import { createTRPCReact } from '@trpc/react-query'

const trpcClient = createTRPCReact<AppRouter>({})
export default trpcClient

```
lib/trpc/trpcServer.ts
``` typescript
import { getUserAuth } from '@/app/api/auth/[...nextAuth]/options'
import { appRouter } from '@/server'
import { cookies } from 'next/headers'

const { session } = await getUserAuth()

const trpcServer = appRouter.createCaller({
  session,
  headers: {
    cookie: cookies().toString(),
    'x-trpc-source': 'rsc-invoke',
  },
})

export default trpcServer

```
components/providers/queryProvider.tsx
``` typescript
'use client'

import trpcClient from '@/lib/trpc/trpcClient'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { httpBatchLink } from '@trpc/client'
import { SessionProvider } from 'next-auth/react'
import React, { useState } from 'react'
import superjson from 'superjson'

const defaultQueryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnMount: false,
      refetchOnWindowFocus: false,
    },
  },
})
const createClient = trpcClient.createClient({
  transformer: superjson,
  links: [
    httpBatchLink({
      url: getUrl(),
    }),
  ],
})

export default function QueryProvider({
  children,
}: {
  children: React.ReactNode
}) {
  const [queryClient] = useState(defaultQueryClient)
  const [client] = useState(createClient)
  return (
    <trpcClient.Provider client={client} queryClient={queryClient}>
      <QueryClientProvider client={queryClient}>
        <SessionProvider>{children}</SessionProvider>
      </QueryClientProvider>
    </trpcClient.Provider>
  )
}
function getBaseUrl() {
  if (typeof window !== 'undefined') return ''
  if (process.env.VERCEL_URL) return `https://${process.env.VERCEL_URL}`
  return 'http://localhost:3000'
}

export function getUrl() {
  return getBaseUrl() + '/api/trpc'
}
```