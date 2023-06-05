## env.ts
``` typescript!=
import dotenv from "dotenv";
export default function loadEnv() {
  if (process.env.NODE_ENV === "development") {
    dotenv.config({ path: "./.env.development" });
  }
  if (process.env.NODE_ENV === "production") {
    dotenv.config({ path: "./.env.production" });
  }
}
```
## db.ts
```typescript!=
import mysql, { PoolConnection } from "mysql2/promise";
const pool: any = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  waitForConnections: true,
  connectionLimit: 10,
  maxIdle: 10,
  idleTimeout: 60000,
  queueLimit: 0,
});
const promisePool = pool.promise();

const withTransaction = async (
  callback: (connection: PoolConnection) => Promise<void>
): Promise<void> => {
  let conn: PoolConnection | undefined = undefined;
  try {
    conn = await promisePool.getConnection();
    if (!conn) throw "not found conn";
    await conn.beginTransaction();
    await callback(conn);
    await conn.commit();
  } catch (err) {
    if (conn) await conn.rollback();
    throw err;
  } finally {
    if (conn) conn.release();
  }
};

export default { promisePool, withTransaction };

```



