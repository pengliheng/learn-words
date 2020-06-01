import VueRouter from 'vue-router'
const routes = [
    {
        path: '/',
        name: 'dashboard',
        component: () => import('@/views/dashboard')
    },
    {
        path: '/login',
        name: 'login',
        component: () => import('@/views/login')
    },
    {
        path: '/register',
        name: 'register',
        component: () => import('@/views/register')
    },
]

export default new VueRouter({
    routes
})