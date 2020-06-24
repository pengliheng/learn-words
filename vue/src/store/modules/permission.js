// import router from '@/router'
// const routes = router.options.routes

const state = {
  routes: []
  // routes: routes.find(route => route.name === 'Dashboard').children
}

const mutations = {
  SET_ROUTE(state, payload) {
    state.routes = payload
  }
}

const actions = {
  async getRoutes({ commit }, routes) {
    commit('SET_ROUTE', routes)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
