import Axios from 'axios'
const axios = Axios.create({
    baseURL: `//${document.domain}:8080`,
    timeout: 1000,
    withCredentials: true,
})

export default {
    async SignIn(data){
        const res = await axios({
            url: '/api/login',
            method: 'POST',
            data
        })
        return res.data
    },
    async SignUp(data){
        const res = await axios({
            url: '/api/register',
            method: 'POST',
            data
        })
        return res.data
    }
}