contcat用來結合陣列，會回傳一個新陣列，不會改動舊陣列
``` bash
var alpha = ['a', 'b', 'c'];

var alphaNumeric = alpha.concat(1, [2, 3]);

console.log(alphaNumeric);
// 結果：['a', 'b', 'c', 1, 2, 3]
```