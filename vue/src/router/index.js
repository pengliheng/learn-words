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
    }
]

const router = new VueRouter({
    routes
})

router.beforeEach((to, from, next) => {
    if (to.name !== 'Login') {
        next({ name: 'Login' }) 
    } else {
        next()
    }
})

export default router