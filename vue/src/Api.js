import Axios from 'axios'
import { getToken, setToken, removeToken } from '@/utils/auth' // get token from cookie
import { Message } from 'element-ui';
import router from '@/router'

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
                message: res.message||error,
                type: 'error'
            });
        }else{
            if (res.message) {
                Message({
                    message: res.message,
                    type: 'success'
                });
            }
        }
        return response;
    },
    (error) => {
        if (error.response) {
            Message({
                message: `${error.response.status}: ${error.response.data}`,
                type: 'error'
            });
        }else{
            Message({
                message: error.message,
                type: 'error'
            });
        }
        removeToken()
        router.push({name: 'Login'})
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
    return r.data.data
});




const VOCABULARY = {
    async Get() {
        return await axios({
            url: '/api/vocabulary',
            method: 'GET',
        })
    },
    async Delete(id) {
        return await axios({
            url: '/api/vocabulary/' + id,
            method: 'DELETE',
        })
    },
    async Create(data) {
        return await axios({
            url: '/api/vocabulary',
            method: 'post',
            data
        })
    },
    async Update(data) {
        return await axios({
            url: '/api/vocabulary/' + data._id,
            method: 'PATCH',
            data
        })
    },
}

const APP = {
    async SignIn(data) {
        return await axios({
            url: '/api/login',
            method: 'POST',
            data
        })
    },
    async SignUp(data) {
        return await axios({
            url: '/api/register',
            method: 'POST',
            data
        })
    },
    async Logout() {
        return await axios({
            url: '/api/logout',
            method: 'POST'
        })
    },
    async UserInfo() {
        return await axios({
            url: '/api/userInfo',
            method: 'GET',
        });
    },

}

export default {
    APP,
    VOCABULARY
}