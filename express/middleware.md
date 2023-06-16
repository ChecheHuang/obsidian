## tokenMiddleware
``` typescript!=
import { Request, Response, NextFunction } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";

declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}

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

const tokenMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const token = getTokenFromHeader(req);
  try {
    const decoded = await verifyToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json(error);
  }
};

export default tokenMiddleware;

```


## responseFormatter

``` typescript
import { Request, Response, NextFunction } from "express";

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

  res.success = (message: string, data: any, status: number = 200): void => {
    res.status(status).json({
      status: "success",
      message,
      data,
    });
  };

  res.error = (message: string, data: any, status: number = 500): void => {
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

```

``` typescript!=
import { Request, Response, NextFunction } from "express";
import "dotenv/config";
const port = process.env.PORT || 3000;
const logMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const start = new Date();
  const year = start.getFullYear();
  const month = String(start.getMonth() + 1).padStart(2, "0");
  const day = String(start.getDate()).padStart(2, "0");
  const hours = String(start.getHours()).padStart(2, "0");
  const minutes = String(start.getMinutes()).padStart(2, "0");
  const seconds = String(start.getSeconds()).padStart(2, "0");
  console.log(
    `${year}-${month}-${day} ${hours}:${minutes}:${seconds}     ${req.method} http://localhost:${port}${req.url} `
  );
  res.on("finish", () => {
    const end = new Date();
    const duration = end.getTime() - start.getTime(); 
    console.log(`計時${duration}毫秒`);
  });
  next();
};

export default logMiddleware;

```
