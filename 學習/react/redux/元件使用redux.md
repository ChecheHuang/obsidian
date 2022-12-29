```javascript
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