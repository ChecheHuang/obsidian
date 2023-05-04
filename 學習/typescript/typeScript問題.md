<details>
  <summary>什麼是Array and Readonly Array</summary>
  <pre><code class="language-typescript">
let list: number[] = [1, 2, 3];  
let list: Array<number> = [1, 2, 3]; // 等同於上面的寫法    
let list: readonly number[] = [1, 2, 3]; // 不能修改 Array 裡的元素  
let list: ReadonlyArray<number> = [1, 2, 3]; // 等同於上面的寫法
	</code></pre>
</details>


