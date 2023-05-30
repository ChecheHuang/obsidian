``` typescript!=
import loadEnv from "./utils/env";
loadEnv();
import createError from "http-errors";
import express, { Request, Response, NextFunction } from "express";
import responseMiddleware from "./middleware/responseFormatter";
import path from "path";
import bodyParser from "body-parser";

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "/public")));

app.use(responseMiddleware);

const logMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");
  const seconds = String(now.getSeconds()).padStart(2, "0");
  console.log(
    `${year}-${month}-${day} ${hours}:${minutes}:${seconds}     ${req.method} http://localhost:${port}${req.url}`
  );
  next();
};
app.use(logMiddleware);

app.get("/*", function (req, res) {
  res.sendFile(path.join(__dirname, "public", "index.html"));
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
const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

```