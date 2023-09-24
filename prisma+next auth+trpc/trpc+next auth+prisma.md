
``` bash
pnpm add next-auth @next-auth/prisma-adapter @prisma/client bcrypt
pnpm add @trpc/client @trpc/react-query @trpc/server @tanstack/react-query superjson
pnpm add -D prisma tsx @types/bcrypt
npm pkg set scripts.clean="rm -rf .next"
npm pkg set scripts.seed="tsx prisma/seed.ts"
npm pkg set scripts.db:studio="prisma studio"
npm pkg set scripts.db:push="prisma db push"
npm pkg set scripts.db:generate="prisma generate"
npm pkg set scripts.postinstall="npm run db:generate"
```

## [Prisma](Prisma.md)

## [Next Auth](Next%20Auth.md)

## [[TRPC]]
