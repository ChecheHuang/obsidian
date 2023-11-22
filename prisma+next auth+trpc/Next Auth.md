app/api/auth/[...nextauth]/options.ts
``` typescript
import prismadb from '@/lib/prismadb'
import { PrismaAdapter } from '@next-auth/prisma-adapter'
import bcrypt from 'bcrypt'
import { AuthOptions } from 'next-auth'
import { getServerSession } from 'next-auth'
import CredentialsProvider from 'next-auth/providers/credentials'

export const authOptions: AuthOptions = {
  adapter: PrismaAdapter(prismadb),
  providers: [
    CredentialsProvider({
      name: 'credentials',
      credentials: {
        email: { label: 'email', type: 'text' },
        password: { label: 'password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          throw new Error('Invalid credentials')
        }
        const user = await prismadb.user.findFirst({
          where: {
            email: credentials.email,
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
          email: user.email,
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
```

app/api/auth/[...nextauth]/route.ts
``` typescript
import { authOptions } from './options'
import NextAuth from 'next-auth'

const handler = NextAuth(authOptions)

export { handler as GET, handler as POST }

```


middleware.ts
``` typescript
import { withAuth } from 'next-auth/middleware'

export default withAuth({
  pages: {
    signIn: '/login',
  },
})

export const config = {
  matcher: ['/matcher/:path*'],
}
```

