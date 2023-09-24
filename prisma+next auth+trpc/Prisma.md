prisma/schema.prisma
```
generator client {
  provider = "prisma-client-js"
}

// datasource db {
//   provider = "mysql"
//   url      = env("DATABASE_URL")
// }

datasource db {
  provider = "sqlite"
  url      = "file:./dev.db"
}

model User {
  id         Int      @id @default(autoincrement())
  email      String   @unique
  password   String
  created_at DateTime @default(now())
  updated_at DateTime @updatedAt
}
```

lib/prismadb.ts
``` typescript
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}
const prismadb =
  globalForPrisma.prisma ??
  new PrismaClient({
    log:
      process.env.NODE_ENV === 'development'
        ? ['query', 'error', 'warn']
        : ['error'],
  })
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prismadb

export default prismadb
```

prisma/seed.ts