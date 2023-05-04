###### tags: `TypeScript` `影片`

## 環境

```
npm i typescript -g
```
```
tsc index.ts
```
```
tsc --init
```
tsconfig.json
```
"rootDir": "./src",
"outDir": "./dist",
"inlineSourceMap": true,
```
```
tsc --watch
```
## 介紹
### 基本類型
``` typescript
let str: string = "test";
let num: number = 1000;
let bool: boolean = true;
let n: null = null;
let un: undefined = undefined;
let test: any = "any";
```
### 陣列
``` typescript
let arr: string[] = ["a", "b"];
let arr2: string[][] = [
  ["aa", "bb"],
  ["cc", "dd"],
];
```
### 元祖
``` typescript
let tuple: [number, string, boolean] = [1, "a", true];
let tuple2: [string, string][] = [
  ["a", "b"],
  ["c", "d"],
];
```
### Enum枚舉
``` typescript
enum liveStatus {
  SUCCESS = 0,
  FAIL = 1,
  STREAMING = 1,
}
const curStatus = liveStatus.SUCCESS;
```
### Union
``` typescript
let aaa: number | string;

```
### type
``` typescript
type A = number | string;
let a1: A;
```
### interface
``` typescript
interface User {
  name: string;
  age: number;
}
```
### object
``` typescript
interface Card {
  name: string;
  age?: number;
}
interface Card {
  desc: string;
}
const obj: Card = {
  name: "carl",
  desc: ".....",
};
```
### function
``` typescript
function hello(a: string, b: string, c?: number): number {
  console.log(a, b);
  let d: number;
  if (c === undefined) return -1;
  d = c;
  return 999;
}
```
### 斷言 as unknown
``` typescript
type Data = {
  userId: number;
  id: number;
  title: string;
  completed: boolean;
};

(async function getData() {
  const res = await fetch("https://jsonplaceholder.typicode.com/todos/1");
  //從外部拿到的資料類型
  const data = (await res.json()) as Data;
})();
const data1: Data = {
  userId: 1,
  id: 1,
  title: "delectus aut autem",
  completed: false,
};
type Beta = {
  name: string;
};
//未知類型可以這樣寫
const beta1 = data1 as unknown as Beta;

```
### class
``` typescript

// private 私有
// public 公開
// protected 受保護
class Live {
  public roomName: string;
  private id: string;
  protected name: string;

  constructor(roomName1: string, id1: string, name1: string) {
    this.roomName = roomName1;
    this.id = id1;
    this.name = name1;
  }
}

class CarLive extends Live {
  constructor(roomName1: string, id1: string, name1: string) {
    super(roomName1, id1, name1);
  }
  start() {
    //透過super來訪問private及protected
    super.name;
  }
}

const live = new Live("1號", "1", "carl");
const carLive = new CarLive("1號", "1", "carl");
// console.log("live", live);
// console.log("carLive", carLive);

class Live2 {
  //私有
  #name;
  constructor(name: string) {
    this.#name = name;
  }
}
const live2 = new Live2("live2");
// console.log(live2)

interface CarProps {
  name: string;
  age: number;
  start: () => void;
}

class Car implements CarProps {
  name: string;
  age: number;
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
  start() {}
}
```
### 泛型
``` typescript
function print<T>(data: T) {
  console.log("data", data);
}
// print<number>(999);

class Print<T> {
  data: T;
  constructor(d: T) {
    this.data = d;
  }
}
const p = new Print<string>("string");
// console.log("p", p);
```
### utility
``` typescript
    //Record
interface CatInfo {
  age: number;
  breed: string;
}
type CatName = "miffy" | "boris" | "mordred";
const cats: Record<CatName, CatInfo> = {
  miffy: { age: 10, breed: "Persian" },
  boris: { age: 5, breed: "Maine Coon" },
  mordred: { age: 16, breed: "British Shorthair" },
};
cats.boris;
    //Pick
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}
type TodoPreview = Pick<Todo, "title" | "completed">;
const todo: TodoPreview = {
  title: "Clean room",
  completed: false,
};
todo;
    //Omit
interface Todo1 {
  title: string;
  description: string;
  completed: boolean;
  createdAt: number;
}
type TodoPreview1 = Omit<Todo1, "description">;
const todo1: TodoPreview1 = {
  title: "Clean room",
  completed: false,
  createdAt: 1615544252770,
};
```

## React與typecript結合
```
npx create-react-app carl-app --template typescript
```
src/App.jsx
```javascript!
import React, { useState } from "react";
import "./App.css";

// type TitleProps = {
//   name:string
// }

//export
interface TitleProps {
  name: string;
}

//import
interface TitleProps {
  desc?: string;
}

const Title: React.FC<TitleProps> = ({ name }) => {
  return <div>{name}</div>;
};

const App: React.FC = () => {
  const [title,setTitle]=useState<number|string>()

  return (
    <div>
      <Title name="string" />
    </div>
  );
};

export default App;

```
