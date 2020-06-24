import Api from '@/Api'
// import { Message } from 'element-ui'

export default {
    namespaced: true,
    state: () => ({
        list: [],
    }),
    mutations: {
        SET_VOCABOLUARY(state, payload) {
            state.list = payload
        },
        CREATE_VOCABOLUARY(state, payload) {
            state.list.push(payload)
        },
        DELETE_VOCABOLUARY(state, payload) {
            state.list = state.list.filter(item => item._id !== payload)
        },
        UPDATE_VOCABOLUARY(state, payload) {
            const target = state.list.filter(item => item._id === payload._id)
            if (target.length === 1) {
                target[0].name = payload.name
                target[0].author = payload.author
                target[0].updateAt = new Date()
            }
        }
    },
    actions: {
        async get({ commit }) {
            const vocabulary = await Api.VOCABULARY.Get()
            commit('SET_VOCABOLUARY', vocabulary.data)
        },
        async update({ commit }, form) {
            await Api.VOCABULARY.Update(form)
            commit('UPDATE_VOCABOLUARY', form)
        },
        async create({ commit }, form) {
            await Api.VOCABULARY.Create(Object.assign(form, {
                createAt: new Date(),
                updateAt: new Date(),
                author: this.getters.name
            }))
            commit('CREATE_VOCABOLUARY', form)
        },
        async delete({ commit }, id) {
            await Api.VOCABULARY.Delete(id)
            commit('DELETE_VOCABOLUARY', id)
        },
        
    }
}