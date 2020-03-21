import Axios, { AxiosResponse } from 'axios'
const axois = Axios.create({
    baseURL: `//${document.domain}:8002`,
    timeout: 1000,
    withCredentials: true,
})

export default {
    async SignIn(data: API.SignIn.Request):Promise<AxiosResponse<API.SignIn.Response>>{
        const res:AxiosResponse<API.SignIn.Response> = await axois({
            url: '/api/login',
            method: 'POST',
            data
        })
        return res
    },
    async SignUp(data: API.SignUp.Request):Promise<AxiosResponse<API.SignUp.Response>>{
        const res:AxiosResponse<API.SignIn.Response> = await axois({
            url: '/api/login',
            method: 'POST',
            data
        })
        return res
    }
}