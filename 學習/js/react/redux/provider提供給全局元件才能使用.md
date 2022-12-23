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