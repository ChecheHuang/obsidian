# Lavarel 啟動與運行

## [[1.為何選擇 Lavarel]]?

### _為何使用框架?_

- #### "我想要自己建構"
- #### 一致性與靈活性

### _web 與 PHP 框架簡史_

- #### Ruby on Rails
- #### 如雨後春筍般冒出的 PHP 框架
- #### CodeIgniter 的優與劣
- #### Lavarel 1、2 與 3
- #### Lavarel 4
- #### Lavarel 5

### _到底 Lavarel 特別在哪?_

- #### Lavarel 的哲學
- #### Lavarel 如何讓開發者更幸福
- #### Lavarel 社群
- #### 它如何工作
- #### 為何選擇 Lavarel

---

## [[2.設置 Lavarel 開發環境]]

### _系統需求_

### _Composer_

### _本地開發環境_

- #### Lavarel Valet
- #### Lavarel Homestead

### _建立 Laravel 新專案_

- #### 使用 Laravel 安裝工具來安裝 Laravel
- #### 使用 Composer 的 create-project 功能來安裝 Laravel
- #### Lambo:超強的"Laravel New"

### _Laravel 的目錄結構_

- #### 資料夾
- #### 零星的檔案

### _設置_

- #### .env

### _啟動並執行_

### _測試_

---

## [[3.路由與 controller]]

### _簡介 MVC HTTP 動詞與 REST_

- #### 什麼是 MVC

1. modal 存取資料庫
2. controller 中間站
3. view client 端頁面

- #### HTTP 動詞
- #### 什麼是 REST

### _路由定義_

```php
//routes/web.php
Route::get('/',function(){
	return 'Hello,World!';
})
//當路由closure跟controller完成後中間會經過middleware在過去client端
```

```php
Route::get('/',function(){
	return view('welcome');
})
Route::get('/about',function(){
	return view('about');
})
```

- #### 路由動詞
- #### 路由處理

```php
Route::get('/','WelcomeController@index')
```

- #### 路由參數

```php
//可使用regex來篩選
Route:get('posts/{id}',function($id){
//
})->where('id','[0-9]+');

//多個路由參數的限制
Route:get('posts/{id}/{slug}',function($id,$slug){
//
})->where(['id'=>'[0-9]+','slug'=>'[A-Za-z]+']);
```

- #### 路由名稱

```php
//定義路由名稱
Route::get('members/{id}','MembersController@show')->name('members.show');
//view裡面用route()
<a href="<?php echo route('members.show',['id'=>14]); ?>">
```

傳遞路由參數給 route()輔助函式

```php
// users/userId/comments/commentId如果userId=1   commentId=2
1.route('users.comments.show',[1,2])
2.route('users.comments.show',['userId'=>1,'commentId'=>2])
3.route('users.comments.show',['commentId'=>2],'userId'=>1)
//http://myapp.com/users/1/comments/2
4.route('users.comments.show',['userId'=>1,'commentId'=>2,'opt'=>'a'])
//http://myapp.com/users/1/comments/2?opt=a
```

### _路由群組_

```php
Route::group(function(){
    Route::route('hello',function(){
        return 'Hello';
    });
    Route::route('World',function(){
        return 'World';
    })
});
```

- #### middleware
- ##### 在 controller 中套用 middleware

```php
class DashboardController extends Controller {
    public function __construct() {
        $this->middleware('auth');
        $this->middleware('admin-auth')
            ->only('editUser');
        $this->middleware('team-member')
            ->except('editUser');
    };
}
```

- ##### 速率限制

```php
Route::middleware('auth:api','throttle:60,1')->group(function(){
    Route::get('/profile',function(){
        //
    });
})
```

- #### 路徑前綴詞

```php
Route::prefix('dashboard')->group(function(){
    Route::get('/',function(){});
    //    /dashboard/
    Route::get('/users',function(){});
    //    /dashboard/users
});
```

- #### 後備路由
  找不到放在最後

```php
Route::fallback(function(){
    //
});
```

- #### 子網域路由

```php
//基本用法
Route::domain('api/myapp.com')->group(function(){
    Route::get('/',function(){});
});
//參數化
Route::domain('{account}/myapp.com')->group(function(){
    Route::get('/',function($account){});
    Route::get('/users/{id}',function($account,$id){});
});
```

- #### 名稱空間前綴詞
  使用子網域路由 controller 通常會有差不多的名稱空間

```php
//App\Http\Controllers\UsersController
Route::get('','UsersController@index');
//App\Http\Controllers\Dashboard\PurchasesController
Route::namespace('Dashboard')->group(function(){
    Route::get('dashboard/purchases','PurchasesController@index');
})
```

- #### 名稱前綴詞

```php
Route::name('users.')->prefix('users')->group(function(){
    Route::name('comments.')->prefix('comments')->group(function(){
        Route::get('{id}',function(){

        })->name('show');
    });
});
```

### _signed 路由_

- #### 簽署路由

```php
//產生一般的連結
URL::route('invitations',['invitations'=>12345,'answer'=>'yes']);
//產生signed連結
URL::signedRoute('invitations',['invitations'=>12345,'answer'=>'yes']);
//產生有期限的signed連結
URL::temporarySignedRoute(
    'invitations',
    now()->addHour(4),
    ['invitations'=>12345,'answer'=>'yes']
);
```

- #### 修改路由來允許 signed 連結

```php
Route::get('invitations/{invitations}/{answer}','InvitationController')
    ->name('invitations')
    ->middleware('signed');
```

### _view_

```php
//將變數傳給view
Route::get('tasks',function(){
    return view('tasks.index')
        ->with('tasks',Task::all());
});
```

- #### 用 Route::view()直接回傳簡單的路由
  Route::view()

```php
//不需要傳變數
Route::view('/','welcome')
//傳遞簡單資料
Route::view('/','welcome',['User'=>'Michael'])
```

- #### 使用 view composer 來讓所有 view 共用變數

```php
//view composer讓所有view共用變數
view()->share('variableName','variableValue');
```

### _controller_

```php
//這會在app/Http/Controllers建立TasksController.php
php artisan make:controller TasksController
//原始TasksController.php樣子
<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
class TasksController extends Controller{

}
//修改成
namespace App\Http\Controllers;
use Illuminate\Http\Request;
class TasksController extends Controller{
    public function index(){
        return 'Hello World';
    }
}
//建立簡單路由
//routes/web.php
<?php
Route::get('/','TasksController@index')
//去/就可以看到Hello World
```

- #### 常見 controller 方法案例

```php
//TasksController.php
...
public function index(){
    return view('tasks.index')
        ->with('tasks',Task::all());
  }
//會載入resources/views/tasks/index.blade.php 或者....index.php
//傳入tasks變數，這個變數有Task::all()Eloquent方法的結果
```

- #### 取得用戶輸入

```php
//routes/web.php
Route::get('tasks/create','TasksController@create');
Route::post('tasks','TasksController@store');

//TasksController內的store方法
//TasksController.php
...
public function store() {
    Task::create(request()->only(['title','description']));
    return redirect('tasks');
}
```

- #### 將依賴項目注入 controller
  例如：想使 Request 物件實例，而不是使用全域輔助函示，只需將方法中 typehint Illuminate\Http\Request

```php
//TasksController.php
...
public function store(\Illuminate\Http\Request $request) {
    Task::create(request()->only(['title','description']));
    return redirect('tasks');
}
```

- #### 資源控制器
  內建產生器

```
//commend lines製作新controller
php artisan make::controller MySampleController.php
//裡面就內建一些方法
```

- #### API 資源控制器
  建立 controller 時加--api

```commend lines
php artisan make::controller MySampleController.php --api
```

- #### 單一動作 controller
  將單一路由指向單一 controller

```php
// \APP\Http\Controller\UpdateUserAvatar.php
public function __invoke(User $user){
    //
}
//routes/web.php
Route::post('users/{user}/update_avatar','UpdateUserAvatar');
```

### _路由 modal 綁定_

常見路由模式:所有 controller 方法第一行會試著找出特定 ID

```php
Route::get('controller/{id}', function($id){
    $conference = Conference::findOrFail($id);
});
```

Laravel 有簡化的功能，稱為 **_路由 modal 綁定_**

- #### 隱性路由 modal 綁定

```php
//使用顯性路由modal綁定
Route::get('controller/{conference}', function(Conference $conference){
    return view('conferences.show')->with('conference', $conference);
});
```

- #### 自訂路由 modal 綁定
  在 App\Providers\RouteServiceProvider 中的 boot()加入

```php
public function boot() {
    //為了讓父代的boot()方法持續運行
    parent::boot();
    //執行綁定
    Route::model('event',Conference::class);
}
```

```php
Route::get('events/{event}',function(Conference $event){
    return view('events.show')->with('event', $event);
});
```

### _路由快取_

```commend lines
//Laravel會將routes/*檔案結果序列化
php artisan route:cache
//刪除快取
php artisan route:clear
```

**缺點**
Laravel 會拿路由與快取比較，而不是 routes/\*，所以修改路由檔案不會有效果，除非再次 cache
**建議**
使用 git 然後執行 php artisan route:cache

### _表單方法欺騙_

- #### Lavarel 的 HTTP 動詞
- #### 在 HTML 表單內的 HTTP 方法欺騙

### _CSRF 保護_

//跨網站偽造請求，使用權杖保護所有入站路由

1. form 內加入\_token 輸入
2. <meta>中儲存權杖

```javascript
//axios
window.axios.defaults.headers.common["X-CSRF-Token"] =
  document.head.querySelector('meta[name="X-CSRF-Token"]');
```

### _轉址_

- #### redirect()->to()
- #### redirect()->route()
- #### redirect()->back()
- #### 其他轉址方法
- #### redirect()->with()

### _中止請求_

### _自訂回應_

- #### response()->make()
- #### response()->json() 與 ->jsonp()
- #### response()->download()、 ->streamDownload()與->file()

### _測試_

---

## [[4.Blade 模板]]

### *echo 資料*　

### *控制結構*　

- #### 條件邏輯
- #### 迴圈

### *模板繼承*　

- #### 使用@section/@show 與@yield 來定義區段
- #### 包含部分 view
- #### 使用堆疊
- #### 使用元件與槽

### _view composer 與服務注入_

- #### 使用 view composer 來將資料綁定 view
- #### Blade 服務注入

### _自訂 Blade 指令_

- #### 自訂 Blade 指令的參數
- #### 範例:在多租戶 app 中使用自訂 Blade 指令
- #### 用更簡單的方式自訂"if"陳述式的指令

### _測試_

---

## [[5.資料庫與 Eloquent]]

### _設置_

- #### 資料庫連結
- #### 其他的資料庫設定選項
- #### 定義 migration
- #### 執行 migration

### _seeding_

- #### 建立 seeder
- #### model 工廠

### _查詢購建器_

- #### DB 靜態介面的基本用法
- #### 原始 SQL
- #### 串接查詢構建器
- #### 交易

### _Eloquent 簡介_

- #### 建立與定義 Eloquent model
- ####　使用 Eloquent 取出資料
- #### 使用 Eloquent 來插入與更新
- #### 使用 Eloquent 來刪除
- #### 範圍
- #### 使用 accessor、mutator 及屬性轉義來自訂欄位互動
- #### Eloquent 集合
- #### Eloquent 序列化
- #### Eloquent 關係
- #### 從子紀錄更新親紀錄的時戳

### _Eloquent 事件_

### _測試_

---

---

## [[6.前端元件]]

### _Laravel Mix_

- #### Mix 資料結構
- #### 執行 Mix\*\*-
- #### Mix 提供什麼

### _前端 preset 與身分驗證鷹架_

- #### 前端 preset
- #### 身分驗證鷹架

### _分頁_

- #### 將資料庫結果分頁
- #### 手動建立分頁器

### _訊息袋_

- #### 具名錯誤袋
- #### 字串輔助函示、複數化與當地語系化
- #### 字串輔助函示與複數化
- #### 當地語系化

### _測試_

- #### 測試訊息與錯誤袋
- #### 翻譯與當地語系化

---

---

## [[7.收集與處理用戶資料]]

### _注入 Request 物件_

- #### $request->all()
- #### $request->except()與$request->only()
- #### $request->has()
- #### $request->input()
- #### $request->method()與->isMethod()
- #### 陣列輸入
- #### JSON 輸入(與$request->json())

### _路由資料_

- #### 透過 Request
- #### 透過路由參數

### _被上傳的檔案_

### _驗證_

- #### Request 物件的 validate()
- #### 手動驗證
- #### 自訂規則物件
- #### 顯示驗證錯誤訊息

### _表單請求_

- #### 建立表單請求
- #### 使用表單請求

### _Eloquent model 的大量賦值_

### _{{vs.{!!_

### _測試_

---

---

## [[8.Artisan 與 Tinker]]

### _Artisan 簡介_

### \*基本 Artisan 命令

- #### 選項
- #### 分組的命令

### _編寫自訂的 Artisan 命令_

- #### 命令範圍
- #### 引數與選項
- #### 使用輸入
- #### 提示
- #### 輸出
- #### 將命令寫成 closure

### _在一般程式中呼叫 Artisan 命令_

### _Tinker_

### _Laravel dump 伺服器_

### _測試_

---

---

## [[9.用戶身分驗證與授權]]

### _用戶 model 與 migration_

### _使用 auth()全域輔助函示與 Auth 靜態介面_

### _Auth controller_

- #### RegisterController
- #### LoginController
- #### ResetPasswordController
- #### ForgotPasswordController
- #### VerificationController

### _Auth::routes()_

### _Auth 鷹架_

### _"記住我"_

### _手動驗證用戶_

### _手動登出用戶_

- #### 讓其他裝置上的 session 失效

### _驗證 middleware_

### _email 驗證_

### _Blade 身分驗證指令_

### _守衛_

- #### 改變預設的守衛
- #### 使用其他的守衛而不改變內定的守衛
- #### 加入新守衛
- #### closure 請求守衛
- #### 建立自訂用戶 provider
- #### 為非關連式資料庫自訂 user provider

### _驗證式建_

### _授權(ACL)與角色_

- #### 定義授權規則
- #### Gate 靜態介面(與注入 Gate)
- #### 資源 Gate
- #### Authorize middleware
- #### controller 授權
- #### 在用戶實例檢查
- #### Blade 檢查
- #### 攔截檢查
- #### policy

### _測試_

---

---

## [[10.請求、回應與 middleware]]

### _Laravel 請求的生命週期_

- #### 啟動應用程式
- #### 服務供應器

### _Request 物件_

- #### 在 Laravel 中取得 Request 物件
- #### 取得 Request 的基本資訊

### _Response 物件_

- #### 在 controller 中使用與建立 Response 物件

---

## [[11.容器]]

### _依賴項目注入簡介_

### _依賴項目注入與 Laravel_

### _app()全域輔助函示_

### _容器是如何連接的?_

### _將類別綁定容器_

- #### 綁定 closure
- #### 綁定 singleton、別名與實例
- #### 將具體實例綁定介面
- #### 情境綁定

### _在 Laravel 框架檔案內進行建構式注入_

### _方法注入_

### _靜態介面與容器_

- #### 靜態介面如何運作?
- #### 即時靜態介面

### _服務供應器_

### _測試_

---

## [[12.測試]]

### _測試基本知識_

### _為測試命名_

### _測試環境_

### _測試特徵_

- #### RefreshDatabase
- #### WithoutMiddleware
- #### DatabaseMigrations
- #### DatabaseTranslations

### _簡單的單元測試_

### _應用測試:工作原理_

- #### TestCase

### _HTTP 測試_

- #### 用$this->get()與其他 HTTP 呼叫來測試基本網頁
- #### 用$this->getJson()和其他 JSON HTTP 呼叫來測試 JSON API
- #### 對著$response 斷言
- #### 身分驗證回應
- #### HTTP 測試的其他自訂選項
- #### 在應用測試中處理例外

### _資料庫測試_

- #### 在測試中使用 model 工廠
- #### 在測試中 seeding

### _測試其他的 Laravel 系統_

- #### 事件 fake
- #### Bus 與 Queue fake
- #### Mail fake
- #### Notification fake
- #### Storage fake

### _模仿(mocking)_

- #### Mock 簡介
- #### Mockery 簡介
- #### 偽造其他靜態介面

### _測試 Artisan 命令_

- #### 對 Artisan 命令語法執行斷言

### _瀏覽器測試_

- #### 選擇工具
- #### 使用 Dusk 進行測試

---

## [[13.編寫 API]]

### _類 REST JSON API 基礎_

### _controller 組織與 JSON 回傳_

### _讀取與傳送標頭_

- #### 在 Laravel 中傳送回應標頭
- #### 在 Laravel 中讀取請求標頭

### _Eloquent 分頁_

### _排序與篩選_

- #### 排序 API 結果
- #### 篩選 API 結果

### _轉換結果_

- #### 編寫你自己的轉換器
- #### 使用自訂轉換器時的嵌套與關係

### _API 資源_

- #### 建立資源類別
- #### 資源集合
- #### 嵌套的關係
- #### 使用 API 資源分頁
- #### 有條件第套用屬性
- #### 關於 API 資源的其他自訂

### *使用 Laravel Passport*來做 API 身分驗證

- #### OAuth2.0 簡介
- #### 安裝 Passport
- #### Passport 的 API
- #### Passport 的授權類行
- #### 使用 Passport API 與 Vue 元件來管理用戶端與權杖
- #### Passport 範圍
- #### 部屬 Passport

### _API 權杖驗證_

### _自訂 404 回應_

- #### 觸發後備路由

### _測試_

- #### 測試 Passport

---

## [[14.儲存與取回]]

### _本地與雲端檔案管理器_

- #### 組態檔案存取
- #### 使用 Storage 靜態介面
- #### 增加額外的 Flysystem 提供者

### _基本檔案上傳與操作_

### _簡單的檔案下載_

### _Session_

- #### 存取 session
- #### session 實例提供的方法
- #### Flash session 儲存系統

### _快取_

- #### 存取快取
- #### Cache 實例提供的方法

### _cookie_

- #### Laravel 的 cookie
- #### 使用 cookie 工具

### _log_

- #### 何時與為何使用 log?
- #### 寫入 log
- #### log 通道

### _用 Laravel Scout 來做全文搜尋_

- #### 安裝 Scout
- #### 標記你的索引 model
- #### 搜尋你的索引
- #### 佇列與 Scout
- #### 不使用索引來執行操作
- #### 依條件檢所的 model
- #### 透過程式碼來手動觸發索引
- #### 透過 CLI 來手動觸發檢索

### _測試_

- #### 檔案儲存系統
- #### session
- #### 快取
- #### cookie
- #### log
- #### Scout

---

## [[15.郵件與通知]]

### _郵件_

- #### "classic"郵件
- #### 基本的"mailable"郵件用法
- #### 郵件模板
- #### build()提供的方法
- #### 附加與內嵌圖像
- #### Markdown mailable
- #### 將 mailable 算繪至瀏覽器
- #### 佇列
- #### 本地開發

### _通知_

- #### 為你的 notifiable 定義 via()方法
- #### 傳送通知
- #### 將通知放入佇列
- #### 內建的通知類型

### _測試_

- #### 郵件
- #### 通知

---

## [[16.佇列、job、事件、廣播與排程器]]

### _佇列_

- #### 為何使用佇列?
可以讓執行時間比較長的程式移出同步，在背景執行
- #### 基本的佇列組態設定
```
php artisan make:job Test_Job
```
創建job模板
app\Jobs\Test_Job.php
```php
<?php
namespace App\Jobs;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
	//實例化
    public function __construct()

    {
        //
    }
    public function handle()

    {
	    //todo
    }
```
別的程式要用時
```php
\App\Jobs\Test_Jobs:dispatch();
```
- #### 佇列中的 job
佇列中的 job要如何執行?
1. 單執行序監聽
```
php artisan queue:work
```
執行後，如果有任務就會執行，否則就會持續監聽等待任務，一旦關閉命令視窗佇列執行就關閉
```
php artisan queue:work --daemon
```
只是放到後臺執行而已，如果佇列出現致命錯誤，佇列必然掛彩，唯一的解決方法就是通過程式守護的方式實現重啟(supervisord)。只要supervisord程式存在，你的佇列就能永久的常駐程式
2. 多執行序監聽Supervisor
```
vi /etc/supervisor/要修改的config
```
建立fail-table
```
php artisan queue:failed-table
php artisan migrate
```
- #### 運行佇列工人
- #### 處理錯誤
- #### 控制佇列
- #### 佇列支援其他功能

### _Laravel Horizon_

### _事件_

- #### 觸發事件
- #### 監聽事件

### _用 WebSocket 與 Laravel Echo 來廣播事件_

- #### 組態與設定
- #### 廣播事件
- #### 接收訊息
- #### 進階廣播工具
- #### Laravel Echo(Javascript 端)

### _排程器_

- #### 可用的工作類型
- #### 可用的時間範圍
- #### 定義排程命令的時區
- #### 阻塞與重疊
- #### 處理工作輸出
- #### 工作掛勾

### _測試_

---

## [[17.輔助函式與集合]]

### _輔助函式_

- #### 陣列
- #### 字串
- #### 應用程式路徑
- #### URL
- #### 其他

### _集合_

- #### 基本知識
- #### 一些方法

---

## [[18.Laravel 生態系統]]

### _本書介紹過的工具_

- #### Valet
- #### Homestead
- #### Laravel 安裝程式
- #### Mix
- #### Dusk
- #### Passport
- #### Horizon
- #### Echo

### _本書介紹過的工具_

- #### Forge
- #### Envoyer
- #### Cashier
- #### Socialite
- #### Nova
- #### Spark
- #### Lumen
- #### Envoy
- #### Telescope

### _其他資源_
