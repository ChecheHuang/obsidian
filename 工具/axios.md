``` typescript!
import originAxios, { AxiosInstance, AxiosError, AxiosResponse } from 'axios'
import { message } from 'antd'
import { wait } from './utils'

type RefreshResponseType = {
  access_token: string
  refresh_token: string
}

const axios: AxiosInstance = originAxios.create({
  baseURL: '/api',
  timeout: 10000,
})

axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('access_token')
    if (token !== null) {
      config.headers['authorization'] = 'Bearer ' + token
    }
    return config
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)

axios.interceptors.response.use(
  (response: AxiosResponse) => {
    return response
  },
  async (error: AxiosError) => {
    const text = error.response?.data || error.config!.url || '伺服器錯誤'
    const status = error.response?.status
    if (text === 'Token已過期') {
      try {
        const refreshToken = localStorage.getItem('refresh_token')
        const {
          data: { access_token, refresh_token },
        } = await axios.post<RefreshResponseType>('/auth/refresh', {
          refreshToken,
        })
        localStorage.setItem('access_token', access_token)
        localStorage.setItem('refresh_token', refresh_token)

        const originalRequest = error.config!
        originalRequest.headers['Authorization'] = `Bearer ${access_token}`
        return axios.request(originalRequest)
      } catch (err) {
        await wait(1000)
        localStorage.clear()
        window.location.href = '/login'
      }
    }
    message.error(text as string)

    return Promise.reject(error)
  }
)

export default axios

type BaseRequest<T, V> = (params?: T) => Promise<AxiosResponse<V>>

type SuccessResponse<V> = {
  code: 'success'
  data: V
}

type ErrorResponse<E = AxiosError> = {
  code: 'error'
  data: E
}

type BaseResponse<V, E> = Promise<SuccessResponse<V> | ErrorResponse<E>>

export const requestHandler =
  <T, V, E = AxiosError>(request: BaseRequest<T, V>) =>
  async (params?: T): BaseResponse<V, E> => {
    try {
      const response = await request(params)
      return { code: 'success', data: response.data }
    } catch (e) {
      return { code: 'error', data: e as E }
    }
  }

```