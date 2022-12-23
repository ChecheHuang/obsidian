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