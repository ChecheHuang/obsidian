## init
```bash
npm init -y 

pnpm add -D @types/cors @types/express @types/http-errors @types/module-alias @types/node @typescript-eslint/eslint-plugin @typescript-eslint/parser cross-env eslint eslint-config-prettier eslint-plugin-prettier prettier ts-node-dev tsconfig-paths typescript @types/jsonwebtoken

pnpm add  @types/body-parser body-parser cors dotenv express http-errors module-alias jsonwebtoken

npm pkg set scripts.start="npm run build && cross-env NODE_ENV=production node -r tsconfig-paths/register ./dist/server.js"

npm pkg set scripts.dev="cross-env NODE_ENV=development ts-node-dev -r ./tsconfig-paths-bootstrap.js src/server.ts"

npm pkg set scripts.build="npx tsc "

```


```bash
echo 'PORT=9000' > .env;
echo 'PORT=9000' > .env.production;

echo '{
  "compilerOptions": {
    "types": ["express"],
    "target": "es5",
    "module": "commonjs",
    "lib": ["es6"],
    "allowJs": true,
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "noImplicitAny": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}' > tsconfig.json;

echo 'const tsConfigPaths = require("tsconfig-paths");

const baseUrl = "./"; 
const { paths } = require("./tsconfig.json").compilerOptions;

tsConfigPaths.register({
  baseUrl,
  paths,
});' > tsconfig-paths-bootstrap.js;


echo '{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint", "prettier"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier/@typescript-eslint",
    "plugin:prettier/recommended"
  ],
  "env": {
    "commonjs": true,
    "es6": true,
    "node": true
  },
  "parserOptions": {
    "ecmaVersion": 2020
  },
  "rules": {
    "prettier/prettier": "error"
  }
}' > .eslintrc;

echo '{
    "singleQuote": true,
    "trailingComma": "es5",
    "printWidth": 130,
    "semi": false,
    "endOfLine": "auto"
}' > .prettierrc;

echo 'dist
node_modules' > .eslintignore;
```


```bash
mkdir -p public 
mkdir -p src 
mkdir -p src/middleware
mkdir -p src/routes
mkdir -p src/types
mkdir -p src/utils

echo 'import { Request, Response, NextFunction } from "express";
import "dotenv/config";
const port = process.env.PORT || 9000;
const url = process.env.BASE_URL || `http://localhost:${port}`;
const logMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const start = new Date();
  const year = start.getFullYear();
  const month = String(start.getMonth() + 1).padStart(2, "0");
  const day = String(start.getDate()).padStart(2, "0");
  const hours = String(start.getHours()).padStart(2, "0");
  const minutes = String(start.getMinutes()).padStart(2, "0");
  const seconds = String(start.getSeconds()).padStart(2, "0");
  const reqUrl = req.originalUrl || req.url;
  const method = req.method;

  res.on("finish", () => {
    const end = new Date();
    const duration = end.getTime() - start.getTime();
    console.log(
      `${year}-${month}-${day} ${hours}:${minutes}:${seconds} ${method} ${url}${reqUrl} 計時${duration}毫秒`
    );
  });
  next();
};

export default logMiddleware;
' > src/middleware/logMiddleware.ts;

echo 'import { Request, Response, NextFunction } from "express";

declare global {
  namespace Express {
    interface Response {
      response: ResponseBuilder;
      success: (message?: string, data?: unknown, status?: number) => void;
      error: (message?: string, data?: unknown, status?: number) => void;
      data: (data: unknown) => ResponseBuilder;
      message: (message: string) => ResponseBuilder;
    }
  }
}
class ResponseBuilder {
  private statusCode: number;
  private body: any;
  private res: Response;

  constructor(res: Response) {
    this.statusCode = 200;
    this.body = {
      status: "success",
    };
    this.res = res;
  }

  public status(statusCode: number): ResponseBuilder {
    this.statusCode = statusCode;
    return this;
  }

  public data(data: any): ResponseBuilder {
    this.body.data = data;
    return this;
  }

  public message(message: string): ResponseBuilder {
    this.body.message = message;
    return this;
  }

  public send(): Response {
    return this.res.status(this.statusCode).json(this.body);
  }
}
export default function (
  req: Request,
  res: Response,
  next: NextFunction
): void {
  const response = new ResponseBuilder(res);

  res.success = (message?: string, data?: any, status: number = 200): void => {
    res.status(status).json({
      status: "success",
      message,
      data,
    });
  };

  res.error = (message?: string, data?: any, status: number = 500): void => {
    res.status(status).json({
      status: "error",
      message,
      data,
    });
  };

  res.data = (data: any): ResponseBuilder => {
    response.data(data);
    return response;
  };

  res.message = (message: string): ResponseBuilder => {
    response.message(message);
    return response;
  };
  res.response = response;
  next();
}
' > src/middleware/responseFormatter.ts;

echo 'import { Request } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
declare global {
  namespace Express {
    interface Request {
      user?: TokenType;
    }
  }
}
type TokenType = {
  user_id: number;
  name: string;
  time: string;
};
const getTokenFromHeader = (req: Request): string => {
  try {
    const token = req.headers["authorization"]?.split(" ")[1] || "";
    return token;
  } catch (error) {
    return "";
  }
};

const verifyToken = (token: string): Promise<JwtPayload> => {
  return new Promise((resolve, reject) => {
    jwt.verify(token, process.env.TOKEN_SECRET || "", (err, decoded) => {
      if (err) {
        reject({
          status: "error",
          message: "Token 驗證失敗。請重新登入。",
        });
      } else {
        resolve(decoded as JwtPayload);
      }
    });
  });
};

const tokenMiddleware: ExpressControllerType = async (req, res, next) => {
  const token = getTokenFromHeader(req);
  try {
    const decoded = await verifyToken(token);
    req.user = decoded as TokenType;
    next();
  } catch (error) {
    res.status(401).json(error);
  }
};

export default tokenMiddleware;
' > src/middleware/tokenMiddleware.ts;

echo 'import express from "express";
const router = express.Router();

router.get("", (req, res) => {
  setTimeout(() => {
    res.send("Hello World");
  }, 4000);
});

export default router;
' > src/routes/index.ts;

echo 'import { Request, Response, NextFunction } from "express";

declare global {
  type ExpressControllerType = (
    req: Request,
    res: Response,
    next: NextFunction
  ) => Promise<void | Response<any, Record<string, any>>>;
}
' > src/types/type.d.ts;

echo 'import dotenv from "dotenv";
import moduleAlias from "module-alias";
export default function loadEnv() {
  if (process.env.NODE_ENV === "development") {
    dotenv.config({ path: "./.env.development" });
  }
  if (process.env.NODE_ENV === "production") {
    moduleAlias.addAliases({
      "@": "dist",
    });
    dotenv.config({ path: "./.env.production" });
  }
}
' > src/utils/env.ts;

echo 'import loadEnv from "./utils/env";
loadEnv();
import "dotenv/config";
import createError from "http-errors";
import express, { Request, Response, NextFunction } from "express";
import cors from "cors";
import bodyParser from "body-parser";
import path from "path";

import responseFormatter from "@/middleware/responseFormatter";
import logMiddleware from "@/middleware/logMiddleware";
import apiRouter from "@/routes";

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
const publicPath = path.join(path.resolve(__dirname, ".."), "/public");
app.use(express.static(publicPath));

app.use(responseFormatter);
app.use(logMiddleware);
app.use("/api", apiRouter);

app.get("/*", function (req, res) {
  res.sendFile(path.join(publicPath, "index.html"));
});

app.use((req: Request, res: Response, next: NextFunction) =>
  next(createError(404, "Endpoint not found"))
);

app.use((err: unknown, req: Request, res: Response, next: NextFunction) => {
  console.error(err);
  let errorMessage = "An unknown error occurred: ";
  let statusCode = 500;
  if (err instanceof createError.HttpError) {
    statusCode = err.status;
    errorMessage = err.message;
  }
  res.status(statusCode).json({ error: errorMessage });
});
const port = process.env.PORT || 8080;

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});
' > src/server.ts;
```

