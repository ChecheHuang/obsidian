# 使用 Laravel 8 PHP 主流框架打造 RESTful API

## 開發環境

- ### 安裝 XAMPP
- ### 安裝編輯器
- ### 套件管理 - Composer
- ### 開發 API 工具 - Postman
- ### 版本控制 - Git
- ### 小練習 - port 是什麼?

## PHP 介紹

- ### PHP 檔案
- ### 基本語法
- ### 控制流程
- ### 函數(function)
- ### 小練習 - 延伸閱讀

## PHP 物件導向

- ### 什麼是物件導向?
- ### 類別(Class)
- ### 繼承(Extends)
- ### 封裝(Encapsulation)
- ### 介面(Interface)
- ### 命名空間(namespace)
- ### 小練習 - 我的理解

## RESTful API

- ### Web API
- ### HTTP 傳輸協定
- ### HTTP 動詞
- ### HTTP 標頭
- ### HTTP 狀態碼
- ### HTTP Body
- ### 第一次開發網站的我
- ### REST 風格
- ### 小練習 - 決定一個資源

## 進入 Laravel、規劃系統核心目的

- ### 安裝 Laravel
  ####開新專案取名 project
  全域安裝

```
composer global require "laravel/installer"
```

```
composer laravel new animal
cd animal
php artisan -V
```

或者

```
cd animal
composer create-project laravel/laravel animal "8.*" --prefer-dist
```

啟 server

```
php artisan serve
```

- ### 新增資料庫
- ### 設定資料庫管理帳號
- ### Laravel 環境變數檔案設定
- ### 從生活找到動力-系統構想
- ### 情境分析-具體目標
- ### 小練習-Git 初始化環境

## 新增資源

- ### 定義一個資源
- ### 新增資源檔案
  建 Model
  -rmc 的意思是建立 Model 同時也會建立 Migration 和 Controller 兩個檔案
  r 參數載入預設 CRUD

```
php artisan make:model Animal -rmc
```

產生檔案如下

1. database\migrations\...
2. app\Http\Controllers\AnimalController.php
3. app\Model\Animal.php

在 routes/api.php 引用 controller

```php
// routes/api.php

use App\Http\Controllers\AnimalController;

Route::apiResource('animals',AnimalController::class);
```

查看路由

```
php artisan route:list
```

![](https://i.imgur.com/ji74QAj.png)

此時可以使用 postman 測試http://127.0.0.1:8080/api/animals/{animal}

- ### MVC 架構
- ### 資料庫結構
- ### 資料庫規劃
- ### 實作 Migration
  建立資料表
  執行 up
  恢復 down

```php
<?php
//database\migrations\2022.....

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateAnimalsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('animals', function (Blueprint $table) {
            $table->id(); // 此方法等於使用遞增整數設定一個ID欄位
            $table->unsignedBigInteger('type_id')->nullable();
            $table->string('name');
            $table->date('birthday')->nullable();
            $table->string('area')->nullable();
            $table->boolean('fix')->default(false);
            $table->text('description')->nullable();
            $table->text('personality')->nullable();
            $table->unsignedBigInteger('user_id');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('animals');
    }
}

```

執行

```
php artisan migrate
```

- ### 新建動物的功能
  ![](https://i.imgur.com/BG4L4lD.png)
  開啟 AnimalController 製作

```php=
//app\Http\Controller\AnimalController.php
use App\Models\Animal;
use Symfony\Component\HttpFoundation\Response;
//other
  public function store(Request $request)
    {
        //
        $animal = Animal::create($request->all());
        $animal = $animal->refresh();
        return response($animal,Response::HTTP_CREATED);
    }
```

撰寫 Model

```php=
//app\Models\Animal.php

class Animal extends Model
{
    use HasFactory;
    protected $fillable = [
        'type_id',
        'name',
        'birthday',
        'area',
        'fix',
        'description',
        'personality',
        'user_id',
    ];
}

```

- ### 嘗試可不可以運行

  ![](https://i.imgur.com/AFZxFVs.png)

- ### 小練習-Git 目前進度

## 刪除資源以及異常處理

- ### 實作刪除功能
  ![](https://i.imgur.com/q4jmL7S.png)

```php=
//app\Http\Controllers\AnimalController.php

public function destroy(Animal $animal)
    {
        $animal->delete();
        return response(null,Response::HTTP_NO_CONTENT);
    }

```

- ### Delete 動詞回應資料
- ### 嘗試可不可以運行

  ![](https://i.imgur.com/VpRYlKA.png)
  再次
  ![](https://i.imgur.com/tr4DnV2.png)

- ### 異常錯誤處理

```php=
//app\Exceptions\Handler.php

public function render($request,Throwable $exception)
{
        dd($exception);
        //執行父類別render的程式
        return parent::render($request,$exception);
}

```

```php=
public function render($request,Throwable $exception){

        if($request->expectsJson()){
            if($exception instanceof ModelNotFoundException){
                return $this->errorResponse(
                    [
                        'error'=>'找不到資源'
                    ],
                    Response::HTTP_NOT_FOUND
                );
            }

        return parent::render($request,$exception);
    }
```

#### Error 回傳

#### 其他異常

PHP Trait 統一例外輸出格式及處理常見例外

- NotFoundHttpException 找不到網址
  請求專案系統由未設定的網址將拋出這個錯誤
- MethodNotAllowedHttpException 請求動詞不被允許

新增 PHP 特徵檔案命名為 ApiResponseTrait

```php=
//app\Traits\ApiResponseTrait.php

<?php
namespace App\Traits;

trait ApiResponseTrait
{
    public function errorResponse($message, $status,$code=null){
        $code = $code ?? $status;

        return response()->json(
            [
                'message' => $message,
                'code' => $code,
            ],
            $status
        );
    }
}
?>


```

回 laravel 繼續處理

```php=
//app\Exceptions\Handler.php

use App\Traits\ApiResponseTrait;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;

class Handler extends ExceptionHandler
{
    use ApiResponseTrait;
    public function render($request,Throwable $exception){

        if($request->expectsJson()){
            //1.Model找不到資源
            if($exception instanceof ModelNotFoundException){
                return $this->errorResponse(
                    [
                        'error'=>'找不到資源'
                    ],
                    Response::HTTP_NOT_FOUND
                );
            }
            //2.網址輸入錯誤(新增判斷)
            if($exception instanceof NotFoundHttpException){
                return $this->errorResponse(
                    '無法找到此網址',
                    Response::HTTP_NOT_FOUND
                );
            }
            //3.網址不允許該請求動詞(新增判斷)
            if($exception instanceof MethodNotAllowedHttpException){
                return $this ->errorResponse(
                    $exception->getMessage(),
                    Response::HTTP_METHOD_NOT_ALLOWED
                );
            }
        }

        return parent::render($request,$exception);
    }
}

```

![](https://i.imgur.com/fYl1McO.png)

- ### 小練習-Laravel 軟體刪除

## 更新資源

![](https://i.imgur.com/KVuQGN5.png)

```php=
//app\Http\Controllers\AnimalController.php

  public function update(Request $request, Animal $animal)
    {
        //
        $animal -> update($request->all());
        return response($animal,Response::HTTP_OK);
    }

```

- ### PUT|PATCH 動詞的差別

#### PATCH 修改資源部分內容

#### 替換一個資源

- ### 嘗試可不可以更新動物
  ![](https://i.imgur.com/dQVVcXj.png)
- ### HTTP Content-Type header
  x-www-form-urlencoded 因為 put 和 patch 才能操作
- ### 小練習- \_method

## 查詢資源

![](https://i.imgur.com/qcCX9Bo.png)
![](https://i.imgur.com/pIWaBlK.png)

```php=
//app\Http\Controllers\AnimalController.php

    public function show(Animal $animal)
    {
        //
        return response($animal,Response::HTTP_OK);
    }
```

![](https://i.imgur.com/jl69ZNV.png)

- ### 兩種查詢資源的動作
- ### 查詢單一資源資料
- ### 查詢資料列表

```php=
    public function index()
    {
        //
        $animals = Animal::get();
        return response(['data'=>$animals],Response::HTTP_OK);
    }
```

![](https://i.imgur.com/dIbUAH3.png)

- ### Factory 產生資料
  產生動物的模型工廠

```
php artisan make:factory AnimalFactory --model=Animal
```

```php=
<?php
//database\factories\AnimalFactory.php
namespace Database\Factories;

use App\Models\Animal;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;



class AnimalFactory extends Factory
{

    protected $method = Animal::class;

    public function definition()
    {
        return [
            //numberBetween隨機產生範圍1到3之間的整數
            'type_id'=>$this->faker->numberBetween(1,3),
            'name'=>$this->faker->name,
            'birthday' =>$this->faker->date(),
            'area'=>$this->faker->city,
            'fix' =>$this->faker->boolean,
            'description'=>$this->faker->text,
            'personality' =>$this->faker->text,
            'user_id' => User::all()->random()->id
        ];
    }
}

```

````php=
<?php
//database\seeders\DatabaseSeedeer.php

namespace Database\Seeders;

use App\Models\Animal;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // 取消外鍵約束（後面章節將介紹外鍵約束）
        Schema::disableForeignKeyConstraints();
        Animal::truncate(); // 清空animals資料表 ID歸零
        User::truncate(); // 清空users資料表 ID歸零

        // 建立5筆會員測試資料
        User::factory(5)->create();
        // 建立一萬筆動物測試資料
        Animal::factory(10000)->create();
        // 開啟外鍵約束
        Schema::enableForeignKeyConstraints();
    }
}
修改產生中文
```php=
//config\app.php
   'faker_locale' => 'zh-Tw',
````

- ### 資料列表限制
- ### 資料列表分頁
  最多 10 筆
  GET /api/animals?limit=10
  最多 20 筆並查第三頁
  GET /api/animals?limit=20&page=3
  app\Http\Controller\AnimalController.php

```php=
public function index(Request $request)
    {
        //設定預設值
        $limit = $request->limit ?? 10;

        //使用Model orderBy 方法加入SQL語法排序條件，依照ID由大到小排序
        $animals = Animal::orderBy('id','desc')
            ->paginate($limit)//使用分頁方法
            ->appends($request->query());

        return response($animals,Response::HTTP_OK);
    }
```

![](https://i.imgur.com/Xs43jj3.png)

- ### JSON 格式建議
- ### 資源列表篩選
- ### 資源列表排序
  撰寫程式
  http://127.0.0.1:8000/api/animals?filters=name:Towne
  ![](https://i.imgur.com/PQXjLYd.png)

http://127.0.0.1:8000/api/animals?filters=name:Towne,area:Rudolph
![](https://i.imgur.com/f0fnlv7.png)

app\Http\Controllers\AnimalController.php

```php=
   public function index(Request $request)
    {
        //設定預設值
        $limit = $request->limit ?? 10;

        //建立查詢建構器，分段的方式撰寫SQL
        $query = Animal::query();

        //篩選程式邏輯，如果有設定filters參數
        if(isset($request->filters)){
            $filters = explode(',',$request->filters);
            foreach($filters as $key => $filter){
                list($key,$value)=explode(':',$filter);
                $query->where($key,'like',"%$value");
            }
        }

        $animals = $query->orderBy('id','desc')
            ->paginate($limit)
            ->appends($request->query());

        return response($animals,Response::HTTP_OK);
    }
```

- ### 資源列表快取
- ### 小練習-Model 查詢及集合運用

## 表單驗證以及語系設定

- ### 前言
- ### 安全的輸入資料
- ### 嘗試可不可以運行
- ### 設定系統語系
- ### 小練習-查詢 Laravel 官方文件

## Model 關聯以及統一輸出

- ### 分類資源 CRUD
- ### 嘗試讓 API 回傳以下結果
- ### 建立模型關連-一對多
- ### Resource 轉換格式
- ### 分析需求統一輸出格式
- ### 補強新增、更新動物資源功能
- ### 小練習-關聯式資料庫

## 身分驗證

- ### 加入會員認證
- ### 註冊帳號
- ### Laravel 安裝 Passport 身分驗證套件
- ### 設定 Passport
- ### OAuth2 認證機制 Token 原理
- ### 設定操作資源需驗證的方法
- ### 密碼授權取得 Token
- ### 自訂 Token 過期期間
- ### 刷新 access_token
- ### SCOPE
- ### 客戶端憑證授權
- ### 修改由身分驗證寫入 user_id
- ### 小練習-Passport 其他授權方式
- ### 小練習-中介層式什麼

## 需求變更

- ### 修改資料表新建 Migration
- ### Policy 會員權限原則設計
- ### 增加需求-我的最愛追蹤功能
- ### 小練習-try....catch...資料庫交易

## 容易擴充維護的 API

- ### URI 格式
- ### Resource | Utility API
- ### 設定請求次數
- ### CORS
- ### 快取機制
- ### HTTPS
- ### 其他建議
- ### 小練習-CORS 體驗

## 重構的觀念

- ### 什麼是重構?
- ### 評估現有的程式碼
- ### 重構步驟
- ### 大型專案設計模式
- ### 小練習-VSCode 建議安裝套建

## 測試的初探

- ### 為什麼寫測試
- ### 測試檔案命名規則
- ### 重置資料庫
- ### 建立測試資料庫
- ### 功能測試
- ### 結論

## 開始重構程式碼

- ### Request 驗證資料檔案
- ### Service 設計架構
- ### 結論

## 更好的自己更好的 API

- ### 直接動手做(心情分享)
- ### 修改原本設計的 URI
- ### API 的 Controller 歸類在一個資料夾中
- ### 如何安心升級版本

## 產生 API 文件

- ### 安裝套件
- ### 設定 API 說明文件基本資訊
- ### 註解關鍵字介紹
- ### 總結
- ### 小練習-建立 API 流程心法
- ### 小練習-正式上線設定建議

## 附錄

- ### Mac 更新 PHP
- ### 常見 HTTP 狀態碼總覽

```

```
