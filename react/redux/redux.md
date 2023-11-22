
``` shell
npm i react-redux redux @reduxjs/toolkit
```
create-react-app內的src創redux/store.js   redux/userSlice
```javascript
//store
import { configureStore } from '@reduxjs/toolkit'
import userReducer from './userSlice'
export default configureStore({
  reducer: {
  //對應createSlice裡面的name
    user: userReducer,
  },
})
```
src內index.js要用provider包全局
```javascript
import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'
import App from './App'
import { Provider } from 'react-redux'//引入provider
import store from './redux/store'
const root = ReactDOM.createRoot(document.getElementById('root'))
root.render(
  <Provider store={store}>//用provider包住app並且store為自己包好的store
    <App />
  </Provider>
)
```
要接api可自訂方法
``` javascript
//userSlice
import { createSlice } from '@reduxjs/toolkit'
//創建
export const userSlice = createSlice({
  name: 'user',
  initialState: {
    userInfo: {
      name: 'anna',
      email: 'anna@gmai.com',
    },
    pending: null,
    error: false,
  },
  reducers: {
    updateStart: (state) => {
      state.pending = true
    },
    updateSuccess: (state, action) => {
      state.pending = false
      state.userInfo = action.payload
    },
    updateError: (state) => {
      state.error = true
      state.pending = false
    },
  },
})
export const { updateStart, updateSuccess, updateError } =userSlice.actions
export default userSlice.reducer
```
使用上面export出來的三個方式
```javascript
//檔名為apiCalls
import { updateStart, updateSuccess, updateError } from './userSlice'
import axios from 'axios'
//自定義方法export出去，使用時再把dispatch傳進來
export const updateUser = async (user, dispatch) => {
  dispatch(updateStart())//先使用start讓pending為true
  try {
    const res = await axios.post(
    //自己定義api
      'http://localhost:8800/api/users/123/update',
      user
    )
    dispatch(updateSuccess(res.data))//拿到東西pending改回false 資料更新
  } catch (err) {
    dispatch(updateError())//若是錯誤pending也改回false
  }
}
-----------------------------------------------------
//使用redux
import { useDispatch/*更改*/, useSelector/*拿出來*/ } from 'react-redux'
import { updateUser } from '../redux/apiCalls'//上述方法
//用useSelector取出user裡面的值
//要使用的元件裡面
export default function 元件名稱(){
const { userInfo, pending, error } = useSelector((state) => state.user)
const dispatch = useDispatch()
function handleUpdate(e) {
    updateUser({ name, email }, dispatch)//自定義方法要把dispatch傳進去
  }
return <button onClick={handleUpdate}>test</button>
}

```
第二種使用redux內提供的方法
```javascript
import { createAsyncThunk, createSlice } from '@reduxjs/toolkit'
import axios from 'axios'
//使用createAsyncThunk來創建async方法
export const updateUser2 = createAsyncThunk('users/update', async (user) => {
  const res = await axios.post(
    'http://localhost:8800/api/users/123/update',
    user
  )
  return res.data
})
export const userSlice = createSlice({
  name: 'user',
  initialState: {
    userInfo: {
      name: 'anna',
      email: 'anna@gmai.com',
    },
    pending: null,
    error: false,
  },
  reducers: {
  //reducer裡面使用extraReducers建立createAsyncThunk創建promise的三種狀態
  extraReducers: {
    [updateUser2.pending]: (state) => {
      state.pending = true
      state.error = false
    },
    [updateUser2.fulfilled]: (state, action) => {
      state.pending = false
      state.userInfo = action.payload
    },
    [updateUser2.rejected]: (state) => {
      state.pending = null
      state.error = true
    },
  },
})
export default userSlice.reducer
//使用redux
import { useDispatch/*更改*/, useSelector/*拿出來*/ } from 'react-redux'
import { updateUser2 } from '../redux/userSlice'//直接從slice拿這個async方法
//用useSelector取出user裡面的值
//要使用的元件裡面
export default function 元件名稱(){
const { userInfo, pending, error } = useSelector((state) => state.user)
const dispatch = useDispatch()
function handleUpdate(e) {
	dispatch(updateUser2({ name, email }))
  }
return <button onClick={handleUpdate}>test</button>
}

```

![](files/Pasted%20image%2020231023113757.png)