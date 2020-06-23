import Axios from 'axios'
import { getToken, setToken, removeToken } from '@/utils/auth' // get token from cookie
import { Message } from 'element-ui';

const axios = Axios.create({
    baseURL: `//${document.domain}:8080`,
    timeout: 1000,
    withCredentials: true,
})


// request interceptor
axios.interceptors.request.use(
    (config) => {
        // store.dispatch('loading/start');
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);
axios.interceptors.response.use(
    (response) => {
        // store.dispatch('loading/end');
        // 处理200的逻辑
        const res = response.data
        if (res.errorCode !== 0) {
            Message({
                message: res.message,
                type: 'error'
            });
        }
        return response;
    },
    (error) => {
        if (error.response && error.response.status !== 401) {
            Message({
                message: error.response.data.message
                    ? error.response.data.message
                    : 'Could not connect to server',
                type: 'error',
                duration: 2000
            });
        }
        removeToken()
        router.push('/login')
        return Promise.reject(error);
    }
);

axios.interceptors.response.use((r) => {
    if (r.message) {
        Message({
            message: r.message,
            type: r.errorCode==0 ? 'success' : 'error',
            duration: 2000
        });
    }
    return r
});




const VOCABULARY = {
    async Get() {
        const res = await axios({
            url: '/api/word',
            method: 'GET',
        })
        return res.data
    },
    async Delete(id) {
        const res = await axios({
            url: '/api/word/' + id,
            method: 'DELETE',
        })
        return res.data
    },
    async Create(data) {
        const res = await axios({
            url: '/api/word',
            method: 'post',
            data
        })
        return res.data
    },
    async Update(data) {
        const res = await axios({
            url: '/api/word/' + data._id,
            method: 'PATCH',
            data
        })
        return res.data
    },
}

const APP = {
    async SignIn(data) {
        const res = await axios({
            url: '/api/login',
            method: 'POST',
            data
        })
        return res.data
    },
    async SignUp(data) {
        const res = await axios({
            url: '/api/register',
            method: 'POST',
            data
        })
        return res.data
    },
    async Logout() {
        const res = await axios({
            url: '/api/logout',
            method: 'POST'
        })
        return res.data
    },
    async UserInfo() {
        const res = await axios({
            url: '/api/userInfo',
            method: 'GET',
        });
        return res.data
    },

}

export default {
    APP,
    VOCABULARY
}