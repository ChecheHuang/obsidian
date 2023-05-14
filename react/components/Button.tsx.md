``` tsx!=
import React, { useState, useCallback } from "react";
import { http, MethodType } from "@/utils/request";

interface MyButtonProps<T> {
  request?: Request;
  onClick?: (result: T, error?: Error) => void;
  style?: React.CSSProperties;
  classNamePrefix?: string;
  className?: string;
  disabled?: boolean;
  loading?: string | JSX.Element;
  children?: string | JSX.Element;
}

export interface Request {
  url: string;
  method?: MethodType;
  data?: object;
}

const MyButton = <T extends object>({
  request,
  onClick,
  style = {},
  className = "",
  disabled = false,
  loading = "loading",
  classNamePrefix = "MyButton",
  children = "MyButton",
}: MyButtonProps<T>) => {
  const { url, method = "get", data } = request || {};
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const handleClick = useCallback(async () => {
    setIsLoading(true);
    try {
      if (url) {
        const result = await http[method as MethodType](url, data as object);
        if (onClick) {
          onClick(result as unknown as T);
        }
      }
      setIsLoading(false);
    } catch (err) {
      setIsLoading(false);
      onClick?.(undefined as unknown as T, err as Error);
      throw err;
    }
  }, [url, method, data, onClick]);

  return (
    <button
      style={style}
      className={`${classNamePrefix} ${className}`}
      disabled={disabled || isLoading}
      onClick={handleClick}
    >
      {isLoading ? loading : children}
    </button>
  );
};
const MemoButton = React.memo(MyButton) as <T extends object>(
  props: MyButtonProps<T>
) => JSX.Element;

export default MemoButton;
```

使用為
```tsx!=
import React from "react";
import MyButton, { Request } from "@/components/Button";

const Parent: React.FC = () => {
  const request: Request = {
    url: "/test",
    method: "post",
  };

  const handleClick = (result: object, error?: Error): void => {
    if (error) {
      console.error(error);
    } else {
      console.log("result", result);
    }
  };

  return <MyButton request={request} onClick={handleClick} />;
};

export default Parent;

```
依賴為utils/request.ts
```typescript!=
import axios, {
  AxiosInstance,
  AxiosError,
  AxiosResponse,
  AxiosRequestConfig,
} from "axios";
import { getCookies } from "./cookies";
export interface Result<T> {
  code?: number;
  status: string;
  data: T;
  message?: string;
}

const request: AxiosInstance = axios.create({
  baseURL: "/api",
  timeout: 3000,
});

//請求攔截
request.interceptors.request.use((config) => {
  //請求前
  const token = getCookies("token");
  if (config && config?.headers && token) {
    config.headers.token = token;
  }
  return config;
}),
  (error: AxiosError) => {
    return Promise.reject(error);
  };

//響應攔截
request.interceptors.response.use((response: AxiosResponse) => {
  //請求後
  if (response.data.status === "success") {
    return response.data;
  }
  throw new Error("請求錯誤");
}),
  (error: AxiosError) => {
    return Promise.reject(error);
  };

export type MethodType = "get" | "post" | "put" | "delete" | "patch";
type HttpMethodMap = {
  [key in MethodType]: <T>(
    url: string,
    data?: object,
    config?: AxiosRequestConfig
  ) => Promise<Result<T>>;
};
export const http: HttpMethodMap = {
  get: request.get,
  post: request.post,
  patch: request.patch,
  put: request.put,
  delete: request.delete,
};
export default request;

```

``` typescript!=
export interface Result<T> {
  code?: number;
  status: string;
  data: T;
  message?: string;
}

const baseURL = "/api";
const timeout = 3000;

type HttpMethodMap = {
  [key in MethodType]: <T>(
    url: string,
    data?: object,
    config?: RequestInit
  ) => Promise<Result<T>>;
};

export const http: HttpMethodMap = {
  get: fetchWrapper("GET"),
  post: fetchWrapper("POST"),
  patch: fetchWrapper("PATCH"),
  put: fetchWrapper("PUT"),
  delete: fetchWrapper("DELETE"),
};

function fetchWrapper(method: MethodType) {
  return async function <T>(
    url: string,
    data?: object,
    config?: RequestInit
  ): Promise<Result<T>> {
    const token = localStroage.getItem('token')||""
    const headers = config?.headers || {};
    if (token) {
      headers["token"] = token;
    }

    const requestConfig: RequestInit = {
      method,
      headers,
      ...config,
    };

    if (method !== "GET") {
      requestConfig.body = JSON.stringify(data);
    }

    let response: Response;
    try {
      response = await Promise.race([
        fetch(`${baseURL}${url}`, requestConfig),
        new Promise((_, reject) =>
          setTimeout(() => reject(new Error("Timeout")), timeout)
        ),
      ]);
    } catch (error) {
      throw new Error("網絡錯誤");
    }

    if (!response.ok) {
      throw new Error(response.statusText);
    }

    const responseData = await response.json();
    if (responseData.status === "success") {
      return responseData;
    }

    throw new Error("請求錯誤");
  };
}
```
