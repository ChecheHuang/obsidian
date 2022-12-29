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