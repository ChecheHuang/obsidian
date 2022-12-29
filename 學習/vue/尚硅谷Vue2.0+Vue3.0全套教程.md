###### tags: `Vue` `JAVASCRIPT` `尚硅谷`

## 課程簡介
## Vue簡介
## Vue官網使用指南
## 搭建Vue開發環境
[中文文檔](https://v2.cn.vuejs.org/v2/guide/installation.html)
![](https://i.imgur.com/IAD9uND.png)
![](https://i.imgur.com/20dPB3J.png)
基本環境
![](https://i.imgur.com/XxvXvqF.png)

## Hello小案例
準備好容器
## 分析Hello案例
![](https://i.imgur.com/ZcDwtA7.png)
Vue的開發者工具
![](https://i.imgur.com/Qu7F4h4.png)
引入開發版本包與生產版本差異
開發版本錯誤題是比較多
![](https://i.imgur.com/N1WloXS.png)
![](https://i.imgur.com/KCaDGCK.png)
生產版本
![](https://i.imgur.com/8TCpU2w.png)
![](https://i.imgur.com/7uOHkKN.png)
## 模板語法
v-bind
![](https://i.imgur.com/VizkHKz.png)

## 數據綁定
v-model
![](https://i.imgur.com/qrBP52A.png)

## el與data的兩種寫法
Vue實例對象
![](https://i.imgur.com/gDCmcg8.png)
![](https://i.imgur.com/TBLJRLU.png)

## 理解MVVM
![](https://i.imgur.com/FAWCu9J.png)
![](https://i.imgur.com/Ea1G6u1.png)

## Object.difineProperty 
1. Object.difineProperty設定物件屬性無法枚舉，不能修改，不能刪除
![](https://i.imgur.com/KT8bxls.png)
2. 加參數enumerable:true可以枚舉
3. 加參數writable: true可以修改
4. 加參數configurable: true可以刪除
![](https://i.imgur.com/GBXnmoJ.png)
5. get與set
![](https://i.imgur.com/JFzg5rL.png)
![](https://i.imgur.com/AHGpl18.png)
## 理解數據代理
#### 什麼是數據代理
通過一個對象代理對另一個對象中屬性的操作
ex:通過obj2修改obj1
![](https://i.imgur.com/1BDQAn4.png)
## Vue中的數據代理
1. 通過vm對象來代理data對象中屬性的操作
2. 好處:更方便操作data
3. 原理:通過Object.defineProperty()把data對象中所有屬性添加到vm上，為每一個添加到vm上的屬性指定一個getter/setter，在getter/setter內被去讀寫data中對應的屬性
![](https://i.imgur.com/FD2gABN.png)
4. getter
![](https://i.imgur.com/8uHciOu.png)
5. setter
data 存在_data中
![](https://i.imgur.com/jsxGD7l.png)
![](https://i.imgur.com/jtin5Oz.png)
流程
![](https://i.imgur.com/Zo2GeRL.png)
6. _data內部也有getter與setter完成雙向綁定
![](https://i.imgur.com/kotaigR.png)




## 事件處理
1. v-on:事件
2. 簡寫@事件
3. 方法寫在methods裡面，在vm上
4. 不要使用箭頭函數，this指向會變成window
5. 可傳參可不傳參
![](https://i.imgur.com/MEZMsG1.png)

## 事件修飾符
### 事件後面可以帶修飾符
1. prevent:阻止默認事件(常用)
![](https://i.imgur.com/ho5CKV5.png)
2. stop:阻止事件冒泡(不會帶到父層)(常用)
3. once:事件只觸發一次(常用)
4. capture:使用事件的捕獲模式(父層先做)
5. self:只有event.target是當前操作的元素才是觸發事件
6. passive:事件的默認行為立即執行，無需等待事件回調執行完畢


## 鍵盤事件
keyup 和 keydown
1. 後面可以加別名enter,delete,esc,space,tab(必須用keydown),up,down,left,right
![](https://i.imgur.com/L5iWpBd.png)
2. Vue未提供，可使用按鍵原始key值綁定
![](https://i.imgur.com/wnKqGpU.png)

3. 系統修飾鍵ctrl,alt,shift,meta
    keydown正常觸發
    keyup搭配其他按鍵觸發
4. 使用keyCode(不推薦)
5. Vue.config.keyCodes.自定義鍵名=鍵碼，可以訂製按鍵別名
![](https://i.imgur.com/xrLeL13.png)


## 事件總結
1. 修飾符可以累加上去
2. 鍵盤系統修飾鍵可以累加其他鍵
## 姓名案例
1. 插值語法
![](https://i.imgur.com/82uO24C.png)
2. methods實現
![](https://i.imgur.com/l39FIZG.png)

## 計算屬性
![](https://i.imgur.com/WMrnEqh.png)
緩存，使用多次只會執行getter一次，computed裡自動去找get的return值放在vm身上
![](https://i.imgur.com/WCzAksh.png)
使用setter完成雙向綁定
![](https://i.imgur.com/BeZvg8V.png)


## 計算屬性_簡寫
![](https://i.imgur.com/dN0rlW3.png)

## 天氣案例
![](https://i.imgur.com/3PrpFKP.png)

## 監視屬性
![](https://i.imgur.com/E6iAP8H.png)
![](https://i.imgur.com/9LwkpUt.png)

## 深度監視
![](https://i.imgur.com/SunP2oL.png)
![](https://i.imgur.com/VKHbt7N.png)
![](https://i.imgur.com/UrwN0dn.png)
## 監視的簡寫形式
只有handler時可以簡寫
![](https://i.imgur.com/A8FnNhy.png)

## watch對比computed
![](https://i.imgur.com/ZmDaSTX.png)
![](https://i.imgur.com/ylmXzr2.png)
watch內可使用非同步執行
![](https://i.imgur.com/7vVbgIe.png)
 

## 綁定class樣式
可用字串、陣列、物件都可以
![](https://i.imgur.com/zY2UJS5.png)


## 綁定style樣式
物件形式或多個可用陣列包
![](https://i.imgur.com/kvoBSCr.png)
```javascript!
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <!-- 引入Vue -->
    <script type="text/javascript" src="../js/vue.js"></script>
</head>

<body>

    <!-- 準備好一個容器 -->
    <div id="root">
        <div :style="{fontSize:40+'px'}">{{name}}</div>
        <div :style="style">{{name}}</div>
        <div :style="[style,style2]">{{name}}</div>
    </div>


    <script type="text/javascript">
        Vue.config.productionTip = false
        Vue.config.devtools = false


        new Vue({
            el: "#root",
            data: {
                name: "hello Vue",
                style: {
                    color: "red"
                },
                style2:{
                    background:"green"
                }
            },

        })


    </script>
</body>

</html>
```

## 條件渲染
![](https://i.imgur.com/93TEFPp.png)
```javascript!
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <!-- 引入Vue -->
    <script type="text/javascript" src="../js/vue.js"></script>
</head>

<body>

    <!-- 準備好一個容器 -->
    <div id="root">
        <div v-show="true">show</div>
        <div v-show="false">show</div>
        <div v-if="true">if</div>
        <!-- 要使用v-else-if 要有 v-if開頭且中間不可有其他東西 -->
        <div v-if="test===1">if test===1</div>
        <div v-else-if="test>1">if test>1</div>
        <div v-else-if="test===5">if test===5</div>
        <template v-if="true">
            <div>群組一</div>
            <div>群組二</div>
            <div>群組三</div>
        </template>
    </div>


    <script type="text/javascript">
        Vue.config.productionTip = false
        Vue.config.devtools = false


        new Vue({
            el: "#root",
            data: {
                name: "hello Vue",
                test: 5
            }
        })


    </script>
</body>

</html>
```

## 列表渲染
![](https://i.imgur.com/cazwI0v.png)

## key作用與原理
## 列表過濾
## 列表排序
## 更新時的一個問題
## Vue監測數據的原理_對象
## Vue.set()方法
## Vue監測數據的原理_數組
## 總結Vue監視數據
## 收集表單數據
## 過濾器
## v-text指令
## v-html指令
## v-cloak指令
## v-once指令
## v-pre指令
## 自定義指令_函數式
## 自定義指令_對象式
## 自定義指令_總結
## 引出生命週期
## 生命週期_掛載流程
## 生命週期_更新流程
## 生命週期_銷毀流程
## 生命週期_總結
## 對組件的理解
## 非單文件組件
## 組件的幾個注意點
## 組件的千套
## VueComponent構造函數
## Vue實例與組件實例
## 一個重要的內痔關係
## 單文件組件
## 創建Vue腳手架
## 分析腳手架架構
## render函數
## 修改默認配置
## ref屬性
## prop配置
## mixin混入
## 插件
## scoped樣式
## TodoList案例_靜態
## TodoList案例_初始化列表
## TodoList案例_添加
## TodoList案例_勾選
## TodoList案例_刪除
## TodoList案例_底部統計
## TodoList案例_底部交互
## TodoList案例_總結
## 瀏覽器本地存儲
## TodoList_本地存儲
## 組件自定義事件_綁定
## 組件自定義事件_解綁
## 組件自定義事件_總結
## TodoList案例_自定義事件
## 全局事件總線1
## 全局事件總線2
## TodoList案例_事件總線
## 消息訂閱與發佈_pubsub
## TodoList案例_pubsub
## TodoList案例_編輯
## $nextTick
## 動畫效果
## 過度效果
## 多個元素過度
## 集成第三方動畫
## 總結過度與動畫
## 配置代理_方式一
## 配置代理_方式二
## github案例_靜態組件
## github案例_列表展示
## github案例_完善案例
## vue_resource
## 默認插槽
## 具名插槽
## 作用域插槽
## Vuex簡介
## 求和案例_純vue版
## Vuex工作原理圖
## 搭建Vuex環境
## 求和案例_vuex版
## vuex開發者工具的使用
## getters配置項
## mapState與mapGetters
## mapActions與mapMutations
## 多組件共享數據
## vuex模塊化+namespace_1
## vuex模塊化+namespace_2
## 路由的簡介
## 路由基本使用
## 幾個注意點
## 嵌套路由
## 路由的query參數
## 命名路由
## 路由的params參數
## 路由的props配置
## router-link的replace屬性
## 編程式路由導航
## 緩存路由組件
## 兩個新的生命週期鉤子
## 全局前置_路由守衛
## 全局後置_路由守衛
## 獨享路由守衛
## 組件內路由守衛
## history模式與hash模式
## element-ui基本使用
## element-ui按需引入
## vue3簡介
## 使用vue-cli創建工程
## 使用vite創建工程
## 分析工程結構
## 安裝開發者工具
## 初識setup
## ref函數_處理基本類型
## ref函數_處理對象類型
## reactive函數
## 回顧Vue2的響應式原理
## Vue3響應式原理_Proxy
## Vue3響應式原理_Reflect
## reactive對比ref
## setup的兩個注意點
## computed計算屬性
## watch監視ref定義的數據
## watch監視reactive定義的數據
## watch時value的問題
## watchEffect函數
## Vue3生命週期
## 自定義hook
## toRef與toRefs
## shallowReactive與shallowRef
## readonly與shallowReadonly
## toRaw與markRaw
## customRef
## provide與inject
## 響應式數據的判斷
## CompositionAPI的優勢
## Fragment組件
## Teleport組件
## Suspense組件
## Vue3中其他的改變



