import Api from '@/Api'
import router from '@/router'
import { Message } from 'element-ui'
import { getToken, setToken, removeToken } from '@/utils/auth' // get token from cookie

export default {
    namespaced: true,
    state: () => ({
        name: '',
        token: ''
    }),
    mutations: {
        SET_INFO(state, payload) {
            for(let key in payload) {
                if (key === 'token') {
                    setToken(payload.token)
                }
                state[key] = payload[key]
            }
        }
    },
    actions: {
        async logout () {
            await Api.APP.Logout()
            removeToken()
            router.push('/login')
        },
        async login ({ commit }, form) {
            const signData = await Api.APP.SignIn(form)
            if (signData) {
                commit('SET_INFO', signData)
                router.push('/')
            } else {
                // not have account
                const registerData = await Api.APP.SignUp(form)
                if (registerData) {
                    commit('SET_INFO', registerData)
                    router.push('/')
                }
            }
        },
        async userInfo ({ commit }) {
            const signData = await Api.APP.UserInfo()
            commit('SET_INFO', signData)
        }
    }
}