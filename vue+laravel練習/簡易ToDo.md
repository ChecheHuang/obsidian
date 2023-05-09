# Users
[php-open-source-saver/jwt-auth](https://laravel-jwt-auth.readthedocs.io/en/latest/)
### JWT驗證
1. 安裝
   ```
   composer require php-open-source-saver/jwt-auth
   ```
2. 設置secret
```
php artisan jwt:secret
```

3. 修改config
   ```php
    'guards' => [
        'web' => [
            'driver' => 'session',
            'provider' => 'users',
        ],
        'api' => [
            'driver' => 'jwt',
            'provider' => 'users',
        ],
    ]
   ```
4. 修改使用JWT的Model
```php
class User extends Authenticatable implements JWTSubject
{
    use Notifiable;
    use HasFactory;
    public $timestamps = false;
    protected $table = 'users';

    protected $fillable = [
        'user_name',
        'user_password',
        'user_email',
        'user_avatar',
    ];
    public  function  getJWTIdentifier()
    {
        return  $this->getKey();
    }

    public  function  getJWTCustomClaims()
    {
        return [];
    }
    //預設會抓password，但表格不是所以需要另外設定password抓取欄位
    public function getAuthPassword()
    {
        return $this->user_password;
    }
}
```
login產生token回傳
   ```php
   public function login(Request $request)
    {
        $user = User::where('user_name', $request->input('name'))
            ->first();
        if ($user) {
            if ($user && Hash::check($request->input('password'), $user->user_password)) {
                // 密碼正確，執行登入邏輯
                $credentials = [
                    'user_name' => $user->user_name,
                    'password' => $request->input('password'),
                ];
                $token = Auth::attempt($credentials);
                return response()->json([
                    'status' => 'success',
                    'data' => [
                        'user' => [
                            'id' => $user->id,
                            'user_name' => $user->user_name,
                            'user_password' => $user->user_password,
                            'user_email' => $user->user_email,
                            'user_avatar' => $user->user_avatar,
                        ],
                        'token' => $token,
                    ],
                ]);
            } else {
                return response()->json([
                    'status' => 'error',
                    'msg' => '密碼錯誤',
                ], 200);
            }
        } else {
            return response()->json([
                'status' => 'error',
                'msg' => '查無此帳號',
            ], 200);
        }
    }
   ```
middleware驗證
寫在controller中
```php
   public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['login', 'register', 'lineLogin']]);
    }
```
寫在routes中
```php !=
Route::prefix('cus')->middleware('auth:api')->controller(CusProfileController::class)->group(function () {
    Route::get('/', 'index');
    Route::get('/index', 'index2');
    Route::post('/', 'create');
    Route::delete('/{cusProfile}', 'destroy');
    Route::patch('/{cusProfile}', 'edit');
});
```
驗證通過
```php
	use Illuminate\Support\Facades\Auth;

    public function getUserInfo()
    {
        // 會員訊息
        $user = auth()->user();
        // $user = Auth::user();
        $userInfo = [
            'id' => $user->id,
            'user_name' => $user->user_name,
            'user_email' => $user->user_email,
            'user_avatar' => $user->user_avatar
        ];
        return response()->json([
            'status' => 'success',
            'data' => $userInfo
        ]);
    }
```
驗證不通過
Middleware/Authenticate.php
```php
class Authenticate extends Middleware
{
    protected function redirectTo($request)
    {
        if (!$request->expectsJson()) {
            abort(response()->json([
                'status' => 'error',
                'message' => 'Token 驗證失敗。請重新登入。',
            ], Response::HTTP_UNAUTHORIZED));
        }
    }
}
```

# label 
Label
```php
class Label extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $table = 'labels';

    protected $fillable = [
        'label_name',
    ];
    public function cusProfileLabels()
    {
        return $this->hasMany(CusProfileLabel::class, 'label_id', 'id');
    }
}
```
LabelController
```php
class LabelController extends Controller
{
	// get api/label
    public function index()
    {
        $label = Label::get();
        return response()->json([
            'status' => 'success',
            'data' => $label,
        ]);
    }
	// post api/label
    public function create(Request $request)
    {
        // 驗證請求參數
        if (empty($request->label_name)) {
            return response()->json(['status' => 'error', 'message' => '標籤不能為空']);
        }
        // 檢查是否已經存在於資料庫中
        $existingLabel = Label::where('label_name', $request->label_name)->first();
        if ($existingLabel !== null) {
            return response()->json(['status' => 'error', 'message' => '標籤重複']);
        }
        // 新增資料
        $label = Label::create([
            'label_name' => $request->label_name
        ]);
        // 返回新增的資料
        return response()->json(['status' => 'success', 'data' => $label]);
    }
}
```
## 自定義trait
resources/lang/exceptions.php
```php
<?php
return [
    'Ok' => 'OK',
    'API_ERROR_EXCEPTION'=>"error"
];

```

Exceptions/StatusData.php
```php
<?php
namespace App\Exceptions;


class StatusData
{
    const API_OK = "success";
    // const API_OK = 200;
    const API_ERR = 201;
    const NOT_LOGGED_IN = 202;
    const TIMEOUT_OR_INVALID = 203;
    const PARAM_ERROR = 204;
    const INFO_EXIST = 205;
    const INFO_NOT_EXIST = 206;
    const UPLOAD_ERROR = 207;
    const BONUS_ERROR = 208;//紅利token失效
    const PAYMENT_FEIBI_ERROR = 500; // 未設置交易密碼

}

```

Traits/ApiResponseTrait.php
```php
<?php
namespace App\Traits;

use App\Exceptions\StatusData;

trait ApiResponseTrait
{
    public function errorResponse($message, $status,$code=null){
        $code = $code ?? $status;

        return response()->json(
            [
                'status'=>"error",
                'message' => $message,
            ],
        );
    }
    public function webSuccess($data = array(), string $message = '', string $status = StatusData::API_OK)
    {
        return response()->json([
            'status' => $status,
            'message' => $message ?: __('exceptions.Ok'),
            'data' => (object)$data
        ]);
    }
    public function message( string $message = '', string $status = StatusData::API_OK)
    {
        return response()->json([
            'status' => $status,
            'message' => $message ?: __('exceptions.Ok'),
        ]);
    }
    public function webError(string $message = '', int $status = StatusData::API_ERR)
    {
        return response()->json([
            'status' => $status,
            'message' => $message ?: __('exceptions.API_ERROR_EXCEPTION'),
            'data' => null
        ]);
    }
}

```



## CusProfile
CusProfile
```php
class CusProfile extends Model
{
    protected $table = 'cus_profile';
    public $timestamps = false;

    protected $fillable = [
        'create_user_id',
        'cus_name',
        'cus_number',
        'cus_email',
        'cus_idNumber',
        'cus_birthday',
        'cus_remark',
        'cus_status',
        'cus_level',
        'cus_edit_user_id',
        'edit_user_id',
    ];
    protected static $tableColumns = [
        'create_user_id',
        'cus_name',
        'cus_number',
        'cus_email',
        'cus_idNumber',
        'cus_birthday',
        'cus_remark',
        'cus_status',
        'cus_level',
        'cus_edit_user_id',
        'edit_user_id',
    ];

    use HasFactory;
    public function labels()
    {
        return $this->hasMany('App\Models\CusProfileLabel', 'cus_id', 'id');
    }
    public function labelValues()
    {
        return $this->hasManyThrough(
            'App\Models\Label',
            'App\Models\CusProfileLabel',
            'cus_id', // CusProfileLabel連接的foreign key
            'id', // Label連接的foreign key
            'id', // 自己 要連出去的key
            'label_id' // CusProfileLabel 要連出去的key
        );
    }
    public static function list($param)
    {
        $query = static::query();
        $filtered = array_filter($param, function ($key) {
            return $key !== 'page' && $key !== 'size';
        });
        foreach ($filtered as $key => $value) {
            if (array_key_exists($key, array_flip(static::$tableColumns))) {
                $query->where($key, 'like', "%$value%");
            }
        }
        $query->when(!empty($param['label_name']), function ($query) use ($param) {
            $query->whereHas('labelValues', function ($query) use ($param) {
                $query->where('labels.label_name', 'like', "%{$param['label_name']}%");
            });
        });
        return $query;
    }
    public function getCusAgeAttribute()
    {
        return Carbon::parse($this->attributes['cus_birthday'])->age;
    }
}
```
CusProfileController
```php
class CusProfileController extends Controller
{
    use ApiResponseTrait;
    public function index()
    {
        // 預先載入 CusProfile 與 Label 的資料
        $cusProfiles = CusProfile::with('labelValues')->get();
        // 將每一筆資料轉換成需要的格式，並且建立一個新的陣列
        $data = $cusProfiles->map(function ($profile) {
            return [
                'id' => $profile->id,
                'cus_name' => $profile->cus_name,
                'cus_number' => $profile->cus_number,
                'cus_email' => $profile->cus_email,
                'cus_idnumber' => $profile->cus_idnumber,
                'cus_birthday' => $profile->cus_birthday,
                'cus_age' => $profile->cus_age,
                'cus_remark' => $profile->cus_remark,
                'cus_status' => $profile->cus_status,
                'cus_level' => $profile->cus_level,
                'label_names' => $profile->labelValues->map(function ($label) {
                    return [
                        'id' => $label->id,
                        'label_name' => $label->label_name,
                    ];
                })->toArray(),
            ];
        });

        return $this->webSuccess($data);
    }
    public function index2(Request $request)
    {
        $param = $request->all();
        $page = $request->input('page', 1);
        $size = $request->input('size');
        $total = CusProfile::list($param)->count();
        $limit = $size ? $size : $total;
        $offset = ($page - 1) * $size;
        $cusProfiles = CusProfile::list($param)
            // ->with([ 'labelValues'])

            // 關聯用法，如果orderby id 不加上前墜會出現錯誤
            // ->with(['labelValues' => function ($query) {
            //     $query
            //     ->select(['labels.label_name', 'cus_profile_label.label_id'])
            //         ->orderBy('labels.id','desc')
            //         ;
            // }])

            //也可以用一對多的關係再拿到更遠的關聯資料
            // ->with(['labels' => function ($query) {
            //     $query->with(['label']);
            // }])
            ->offset($offset)
            ->limit($limit)
            ->get();


        $data = $cusProfiles->map(function ($profile) {
            return [
                'id' => $profile->id,
                'cus_name' => $profile->cus_name,
                'cus_number' => $profile->cus_number,
                'cus_email' => $profile->cus_email,
                'cus_idnumber' => $profile->cus_idnumber,
                'cus_birthday' => $profile->cus_birthday,
                'cus_age' => $profile->cus_age,
                'cus_remark' => $profile->cus_remark,
                'cus_status' => $profile->cus_status,
                'cus_level' => $profile->cus_level,
                'label_names' => $profile->labelValues->map(function ($label) {
                    return [
                        'id' => $label->id,
                        'label_name' => $label->label_name,
                    ];
                })->toArray(),
            ];
        });
        $response = ['data'=>$data,'total'=>$total];
        return $this->webSuccess($response);

       
    }

    public function create(Request $request)
    {
        // $user = Auth::user();
        $userId = auth()->user()->id;
        $validatedData = $request->validate([
            'cus_name' => 'required',
            'cus_number' => 'required',
            'cus_email' => 'required|email',
            'cus_idnumber' => 'required',
            'cus_remark' => 'nullable',
            'cus_status' => 'nullable',
            'cus_level' => 'nullable',
        ]);

        // $cusProfile->create_user_id = Auth::id();
        try {
            CusProfile::create([
                'create_user_id' => $userId,
                'edit_user_id' => 0,
                'cus_name' => $validatedData['cus_name'],
                'cus_number' => $validatedData['cus_number'],
                'cus_email' => $validatedData['cus_email'],
                'cus_idNumber' => $validatedData['cus_idnumber'],
                'cus_remark' => $validatedData['cus_remark'],
                'cus_status' => $validatedData['cus_status'],
                'cus_level' => $validatedData['cus_level'],
            ]);
            return $this->message('新增成功');
            // return response()->json(['status' => "success", 'message' => '新增成功']);
        } catch (\Exception $e) {
            dd($e);
        }
    }
    public function edit(Request $request, CusProfile $cusProfile)
    {
        $data = $request->all(); // 從請求中取得所有資料
        // $label_ids = collect($data['label_names'])->pluck('id')->toArray(); // 從請求中取得標籤 ID 陣列
        $label_ids = array_column($data['label_names'], 'id');

        // $label_ids = array_map(function ($label) {
        //     return $label['id'];
        // }, $data['label_names']);

        $user_id = auth()->user()->id; // 取得當前使用者的 ID
        $id = $request->id; // 從請求中取得客戶的 ID

        try {
            DB::beginTransaction(); // 開始資料庫事務
            //改成由路由直接獲取
            // $cusProfile = CusProfile::findOrFail($id); // 根據客戶的 ID 取得客戶資料
            // 更新客戶資料
            $columns = array_diff_key($data, array_flip(['label_names', 'cus_id', 'user_id', 'id', 'cus_age'])); // 從請求中移除不需要更新的欄位

            $columns['edit_user_id'] = $user_id; // 設定編輯使用者的 ID
            $columns['update_time'] = Carbon::now(); // 設定更新時間
            $cusProfile->update($columns); // 更新客戶資料

            // 取得客戶的標籤
            $labels = $cusProfile->labels()->pluck('label_id')->toArray(); // 取得客戶標籤的 ID
            // 新增標籤
            $labelIdsToAdd = array_diff($label_ids, $labels); // 找出需要新增的標籤
            $cusProfile->labels()->createMany(array_map(function ($label_id) {
                return [
                    'label_id' => $label_id,
                ];
            }, $labelIdsToAdd)); // 逐一新增標籤

            // 刪除標籤
            $labelIdsToDelete = array_diff($labels, $label_ids); // 找出需要刪除的標籤
            $cusProfile->labels()->whereIn('label_id', $labelIdsToDelete)->delete(); // 刪除標籤

            DB::commit(); // 提交資料庫事務
            return $this->message('成功修改');
        } catch (\Exception $e) { // 如果發生錯誤，回滾資料庫事務
            DB::rollBack();
            return $this->webError($e->getMessage());
        }
    }

    public function edit2(Request $request)
    {
        $data = $request->all(); // 從請求中取得所有資料
        $label_names = $data['label_names']; // 從請求中取得標籤名稱
        $userId = auth()->user()->id; // 取得當前使用者的 ID
        $id = $request->id; // 從請求中取得客戶的 ID

        try {
            DB::beginTransaction(); // 開始資料庫事務
            $cusProfile = CusProfile::findOrFail($id); // 根據客戶的 ID 取得客戶資料
            // 更新客戶資料
            $columns = array_diff_key($data, array_flip(['label_names', 'cus_id', 'user_id', 'id'])); // 從請求中移除不需要更新的欄位
            $columns['edit_user_id'] = $userId; // 設定編輯使用者的 ID
            $columns['update_time'] = Carbon::now(); // 設定更新時間
            $cusProfile->update($columns); // 更新客戶資料

            // 取得客戶的標籤
            $labels = $cusProfile->labels->pluck('label_id')->toArray(); // 取得客戶標籤的 ID
            // 新增標籤
            $labelIdsToAdd = array_filter($label_names, function ($label) use ($labels) {
                return !in_array($label['id'], $labels);
            }); // 找出需要新增的標籤
            foreach ($labelIdsToAdd as $label) { // 逐一新增標籤
                $cusProfile->labels()->create([
                    'cus_id' => $id,
                    'label_id' => $label['id']
                ]);
            }
            // 刪除標籤
            $labelIdsToDelete = array_filter($labels, function ($label) use ($label_names) {
                return !in_array($label, array_column($label_names, 'id'));
            }); // 找出需要刪除的標籤
            $cusProfile->labels()->where('cus_id', $id)->whereIn('label_id', $labelIdsToDelete)->delete(); // 刪除標籤

            DB::commit(); // 提交資料庫事務

            return response()->json(['status' => "success", 'message' => '成功修改'], 200); // 回傳修改成功的訊息
        } catch (\Exception $e) { // 如果發生錯誤，回滾資料庫事務
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500); // 回傳錯誤訊息
        }
    }
    public function destroy(CusProfile $cusProfile)
    {
        if (!$cusProfile) {
            return response()->json(['status' => "error", 'message' => '刪除失敗，指定的用戶不存在'], 404);
        }
        // 刪除 CusProfile 資料及其相關的 CusProfileLabel 資料
        $cusProfile->delete();
        $cusProfile->labels()->delete();
        return response()->json(['status' => "success", 'message' => '成功刪除']);
    }
}
```