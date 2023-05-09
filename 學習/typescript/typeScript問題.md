###### tags: `typescript`
# TS
定義一個Person接口
定義一個Person接口，包含name、age和gender三個屬性，以及一個greet方法，該方法返回一個字符串，表示對其他人的問候。例如：
``` typescipt!=
interface Person {
  name: string;
  age: number;
  gender: string;
  greet(): string;
}
```
實現一個Animal類
實現一個Animal類，該類包含name和age兩個屬性，以及一個greet方法，該方法返回一個字符串，表示對其他動物的問候。例如：
``` typescript!=
class Animal {
  name: string;
  age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }

  greet(): string {
    return `Hello, I'm ${this.name} and I'm ${this.age} years old.`;
  }
}
```
實現一個泛型Stack類
實現一個泛型Stack類，該類包含一個私有的items數組，以及push、pop和peek三個方法。其中，push方法用於將一個元素壓入堆棧中，pop方法用於從堆棧中彈出一個元素，peek方法用於返回堆棧頂部的元素，但不從堆棧中刪除該元素。例如：
```typescript!=
class Stack<T> {
  private items: T[] = [];

  push(item: T) {
    this.items.push(item);
  }

  pop(): T | undefined {
    return this.items.pop();
  }

  peek(): T | undefined {
    return this.items[this.items.length - 1];
  }
}
```
實現一個命名空間
實現一個命名空間MyMath，該命名空間包含一個add方法和一個subtract方法，用於實現加法和減法運算。例如：
```typescript!
namespace MyMath {
  export function add(x: number, y: number): number {
    return x + y;
  }

  export function subtract(x: number, y: number): number {
    return x - y;
  }
}
```
使用類型定義文件
使用類型定義文件，將下面的JavaScript庫轉換為TypeScript代碼：
```typescript!=
// math.js
function add(x, y) {
  return x + y;
}

function subtract(x, y) {
  return x - y;
}

module.exports = {
  add: add,
  subtract: subtract
};
```
```typescript!
// math.d.ts
export function add(x: number, y: number): number;
export function subtract(x: number, y: number): number;

// math.ts
import { add, subtract } from "./math";

console.log(add(1, 2)); // 3
console.log(subtract(3, 1)); // 2
```
使用類型保護
定義一個函數calculate，接受一個類型為'add'或'subtract'的操作符和兩個數字，根據操作符將兩個數字相加或相減，並返回結果。使用 TypeScript 的類型保護來驗證操作符是否為有效值。例如：
```typescript=
function calculate(
  operator: 'add' | 'subtract',
  x: number,
  y: number
): number {
  if (operator === 'add') {
    return x + y;
  } else if (operator === 'subtract') {
    return x - y;
  } else {
    throw new Error(`Invalid operator: ${operator}`);
  }
}

console.log(calculate('add', 2, 3)); // 5
console.log(calculate('subtract', 3, 1)); // 2
console.log(calculate('multiply', 2, 2)); // Error: Invalid operator: multiply
```
使用泛型與接口
定義一個泛型的Repository接口，該接口有getById和save兩個方法，分別接受一個id作為參數和一個泛型實例。然後定義一個User類，實現Repository接口，並實現getById和save方法。最後，創建一個UserRepository實例，使用getById和save方法獲取和保存用戶信息。例如：
```typescript!
interface Repository<T> {
  getById(id: number): T;
  save(item: T): void;
}

class User implements Repository<User> {
  constructor(public id: number, public name: string) {}

  getById(id: number): User {
    return new User(id, `User${id}`);
  }

  save(user: User): void {
    console.log(`Saving user ${user.id}: ${user.name}`);
  }
}

const userRepository = new User();
const user = userRepository.getById(1);
userRepository.save(user);
```
使用類型別名與枚舉
定義一個類型別名Status，該別名為一個枚舉類型，包含'Pending'、'Approved'和'Rejected'三個值。然後定義一個Request接口，該接口包含一個id屬性和一個status屬性，類型為Status。最後，創建一個requests數組，包含多個Request對象，並使用Array.filter方法過濾出所有status為'Approved'的請求。例如：
```typescript!
type Status = 'Pending' | 'Approved' | 'Rejected';

interface Request {
  id: number;
  status: Status;
}

const requests: Request[] = [
  { id: 1, status: 'Pending' },
  { id: 2, status: 'Approved' },
  { id: 3, status: 'Rejected' },
  { id: 4, status: 'Approved' },
];

const approvedRequests = requests.filter(request => request.status === 'Approved');
console.log(approvedRequests); // [{ id: 2, status: 'Approved' }, { id: 4, status: 'Approved' }]
```
使用命名空間和模塊
定義一個命名空間MyApp，該命名空間包含一個Greet模塊，該模塊包含一個greet函數和一個Person接口。然後在命名空間外定義一個Student類，實現Person接口，並使用greet函數向其他人問候。最後，創建一個MyApp.Greeter實例，使用greet方法向其他人問候。例如：
```typescript!
namespace MyApp {
  export module Greet {
    export interface Person {
      name: string;
    }

    export function greet(person: Person): string {
      return `Hello, ${person.name}!`;
    }
  }
}

class Student implements MyApp.Greet.Person {
  constructor(public name: string) {}

  greet(): string {
    return MyApp.Greet.greet(this);
  }
}

const student = new Student('Tom');
console.log(student.greet()); // Hello, Tom!
```
使用類型守衛與類型推斷
定義一個函數greet，該函數接受一個參數，類型為string | string[]，如果參數是一個字符串，則返回一個帶有問候語的字符串；如果參數是一個字符串數組，則返回一個帶有問候語的字符串數組。使用 TypeScript 的類型守衛和類型推斷來實現。例如：
```typescript!
function greet(name: string | string[]): string | string[] {
  if (typeof name === 'string') {
    return `Hello, ${name}!`;
  } else {
    return name.map(n => `Hello, ${n}!`);
  }
}

console.log(greet('Tom')); // Hello, Tom!
console.log(greet(['Tom', 'Jerry'])); // [ 'Hello, Tom!', 'Hello, Jerry!' ]
```
定義一個 Props 類型
定義一個名為Props的接口，該接口包含一個name屬性和一個可選的age屬性，類型分別為string和number。然後使用Props接口定義一個Hello組件，該組件接受一個Props對象作為參數，並將name和age屬性顯示在畫面上。例如：
```typescript!
interface Props {
  name: string;
  age?: number;
}

const Hello: React.FC<Props> = ({ name, age }) => (
  <div>
    <p>Hello, {name}!</p>
    {age && <p>You are {age} years old.</p>}
  </div>
);

ReactDOM.render(<Hello name="Tom" age={20} />, document.getElementById('root'));
```
使用泛型與 Props
定義一個泛型的List組件，該組件接受一個items數組和一個renderItem函數作為參數，用於渲染每一個列表項目。然後使用List組件顯示一個字符串數組。例如：
```typescript!
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
}

function List<T>({ items, renderItem }: ListProps<T>) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={index}>{renderItem(item)}</li>
      ))}
    </ul>
  );
}

const fruits = ['Apple', 'Banana', 'Orange'];
ReactDOM.render(
  <List items={fruits} renderItem={fruit => <p>{fruit}</p>} />,
  document.getElementById('root')
);
```
使用 React.RefObject
定義一個TextInput組件，該組件包含一個value屬性和一個inputRef屬性，分別用於設置輸入框的值和引用。然後在TextInput組件內使用React.useEffect來設置輸入框的焦點。最後，在應用程序中使用TextInput組件。例如：
```typescript!
interface TextInputProps {
  value: string;
  inputRef: React.RefObject<HTMLInputElement>;
}

const TextInput: React.FC<TextInputProps> = ({ value, inputRef }) => {
  React.useEffect(() => {
    inputRef.current?.focus();
  }, [inputRef]);

  return <input type="text" value={value} ref={inputRef} />;
};

const App: React.FC = () => {
  const inputRef = React.useRef<HTMLInputElement>(null);

  const handleClick = () => {
    inputRef.current?.focus();
  };

  return (
    <div>
      <button onClick={handleClick}>Focus Input</button>
      <TextInput value="Hello, world!" inputRef={inputRef} />
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
```
使用 React.Context
定義一個名為ThemeContext的上下文，該上下文包含一個theme屬性和一個changeTheme方法，用於設置應用程序的主題。然後在應用程序中使用ThemeContext.Provider提供主題上下文，並在Header和Content組件中使用ThemeContext.Consumer訪問主題上下文。例如：
```typescript!
interface Theme {
  backgroundColor: string;
  textColor: string;
}

interface ThemeContextType {
  theme: Theme;
  changeTheme: (theme: Theme) => void;
}

const ThemeContext = React.createContext<ThemeContextType>({
  theme: { backgroundColor: 'white', textColor: 'black' },
  changeTheme: () => {},
});

const Header: React.FC = () => {
  return (
    <ThemeContext.Consumer>
      {({ theme }) => (
        <header style={{ backgroundColor: theme.backgroundColor, color: theme.textColor }}>
          Header
        </header>
      )}
    </ThemeContext.Consumer>
  );
};

const Content: React.FC = () => {
  return (
    <ThemeContext.Consumer>
      {({ theme }) => (
        <div style={{ backgroundColor: theme.backgroundColor, color: theme.textColor }}>
          Content
        </div>
      )}
    </ThemeContext.Consumer>
  );
};

const App: React.FC = () => {
  const [theme, setTheme] = React.useState<Theme>({ backgroundColor: 'white', textColor: 'black' });

  const changeTheme = (newTheme: Theme) => {
    setTheme(newTheme);
  };

  return (
    <ThemeContext.Provider value={{ theme, changeTheme }}>
      <Header />
      <Content />
      <button onClick={() => changeTheme({ backgroundColor: 'black', textColor: 'white' })}>
        Change Theme
      </button>
    </ThemeContext.Provider>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
```
使用 React.memo 優化性能
定義一個ListItem組件，該組件接受一個item屬性和一個onClick屬性，分別用於渲染列表項目和處理點擊事件。然後在應用程序中使用List組件顯示多個ListItem組件。使用React.memo優化ListItem組件的性能。例如：
```typescript!
interface ListItemProps {
  item: string;
  onClick: () => void;
}

const ListItem: React.FC<ListItemProps> = React.memo(({ item, onClick }) => {
  console.log(`Rendering ${item}...`);
  return <li onClick={onClick}>{item}</li>;
});

interface ListProps {
  items: string[];
  onItemClick: (index: number) => void;
}

const List: React.FC<ListProps> = ({ items, onItemClick }) => {
  return (
    <ul>
      {items.map((item, index) => (
        <ListItem key={index} item={item} onClick={() => onItemClick(index)} />
      ))}
    </ul>
  );
};

const App: React.FC = () => {
  const [items, setItems] = React.useState(['Apple', 'Banana', 'Orange']);

  const handleItemClick = (index: number) => {
    setItems(items => items.filter((_, i) => i !== index));
  };

  return (
    <div>
      <List items={items} onItemClick={handleItemClick} />
      <button onClick={() => setItems(items => [...items, 'Pineapple'])}>Add Item</button>
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
```
使用 React.useReducer 管理狀態
定義一個Counter組件，該組件使用React.useReducer來維護一個計數器的狀態。然後在應用程序中使用Counter組件。例如：
```typescript!
interface CounterState {
  count: number;
}

type CounterAction = { type: 'increment' } | { type: 'decrement' };

const counterReducer = (state: CounterState, action: CounterAction): CounterState => {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    default:
      throw new Error('Invalid action type.');
  }
};

const Counter: React.FC = () => {
  const [state, dispatch] = React.useReducer(counterReducer, { count: 0 });

  const handleIncrement = () => {
    dispatch({ type: 'increment' });
  };

  const handleDecrement = () => {
    dispatch({ type: 'decrement' });
  };

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={handleIncrement}>+</button>
      <button onClick={handleDecrement}>-</button>
    </div>
  );
};

ReactDOM.render(<Counter />, document.getElementById('root'));
```
使用 useContext 管理狀態
定義一個名為CounterContext的上下文，該上下文包含一個count屬性和一個dispatch方法，用於設置計數器的狀態。然後在應用程序中使用CounterContext.Provider提供計數器上下文，並在Counter組件中使用useContext訪問計數器上下文。例如：
```typescript!
interface CounterState {
  count: number;
}

type CounterAction = { type: 'increment' } | { type: 'decrement' };

const counterReducer = (state: CounterState, action: CounterAction): CounterState => {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    default:
      throw new Error('Invalid action type.');
  }
};

interface CounterContextType {
  state: CounterState;
  dispatch: React.Dispatch<CounterAction>;
}

const CounterContext = React.createContext<CounterContextType>({
  state: { count: 0 },
  dispatch: () => {},
});

const Counter: React.FC = () => {
  const { state, dispatch } = React.useContext(CounterContext);

  const handleIncrement = () => {
    dispatch({ type: 'increment' });
  };

  const handleDecrement = () => {
    dispatch({ type: 'decrement' });
  };

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={handleIncrement}>+</button>
      <button onClick={handleDecrement}>-</button>
    </div>
  );
};

const App: React.FC = () => {
  const [state, dispatch] = React.useReducer(counterReducer, { count: 0 });

  return (
    <CounterContext.Provider value={{ state, dispatch }}>
      <Counter />
    </CounterContext.Provider>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
```
使用 useCallback 進行函數優化
定義一個Button組件，該組件接受一個onClick屬性，用於處理點擊事件。然後在應用程序中使用Button組件。使用React.useCallback優化onClick函數的性能。例如：
```typescript!
interface ButtonProps {
  onClick: () => void;
}

const Button: React.FC<ButtonProps> = React.memo(({ onClick }) => {
  console.log('Rendering Button...');
  return <button onClick={onClick}>Click me</button>;
});

const App: React.FC = () => {
  const [count, setCount] = React.useState(0);

  const handleClick = React.useCallback(() => {
    setCount(count => count + 1);
  }, []);

  return (
    <div>
      <p>Count: {count}</p>
      <Button onClick={handleClick} />
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
```

## TypeScript 與 React 的一些最佳實踐：
1. 使用接口定義屬性類型
在 React 中，我們經常需要定義組件的屬性類型。為了讓代碼更具可讀性和可維護性，建議使用 TypeScript 的接口來定義屬性類型，例如：
```typescript!
interface MyComponentProps {
  title: string;
  count: number;
  items: string[];
  onButtonClick: () => void;
}

const MyComponent: React.FC<MyComponentProps> = ({ title, count, items, onButtonClick }) => {
  // ...
};
```
2. 使用枚舉定義常量
當我們需要定義一些常量時，建議使用 TypeScript 的枚舉來定義它們，例如：
```typescript!
enum Color {
  Red = '#ff0000',
  Green = '#00ff00',
  Blue = '#0000ff',
}

const MyComponent: React.FC = () => {
  const [color, setColor] = React.useState(Color.Red);

  const handleColorChange = () => {
    setColor(Color.Green);
  };

  return (
    <div style={{ backgroundColor: color }}>
      <button onClick={handleColorChange}>Change color</button>
    </div>
  );
};
```
3. 使用泛型定義組件類型
當我們需要在組件中使用泛型時，建議使用 TypeScript 的泛型來定義組件類型，例如：
```typescript!
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
}

function List<T>({ items, renderItem }: ListProps<T>) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={index}>{renderItem(item)}</li>
      ))}
    </ul>
  );
}

interface User {
  id: number;
  name: string;
}

const users: User[] = [
  { id: 1, name: 'Alice' },
  { id: 2, name: 'Bob' },
  { id: 3, name: 'Charlie' },
];

const App: React.FC = () => {
  return (
    <List items={users} renderItem={user => <div>{user.name}</div>} />
  );
};
```
4. 使用可選屬性和默認值
當我們需要定義一些可選的屬性時，可以使用 TypeScript 的可選屬性語法。同時，我們也可以為屬性設置默認值，例如：
```typescript!
interface MyComponentProps {
  title: string;
  count?: number;
  items?: string[];
  onButtonClick?: () => void;
}

const MyComponent: React.FC<MyComponentProps> = ({ title, count = 0, items = [], onButtonClick }) => {
  // ...
};
```
5. 使用類型別名簡化類型定義
當我們需要定義一些複雜的類型時，可以使用 TypeScript 的類型別名來簡化類型定義，例如：
```typescript!
type User = {
  id: number;
  name: string;
  email: string;
};

type UsersMap = Record<User['id'], User>;

const users: UsersMap = {
  1: { id: 1, name: 'Alice', email: 'alice@example.com' },
  2: { id: 2, name: 'Bob', email: 'bob@example.com' },
  3: { id: 3, name: 'Charlie', email: 'charlie@example.com' },
};
```
