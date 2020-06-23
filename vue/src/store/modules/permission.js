import router from '@/router'
const routes = router.options.routes

const state = {
  routes: routes.find(route => route.name === 'Dashboard').children
}

const mutations = {
}

const actions = {
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
