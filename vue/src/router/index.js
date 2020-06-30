import Layout from '@/layout'
import VueRouter from 'vue-router'
import { getToken } from '@/utils/auth' // get token from cookie
import store from '@/store'

const routes = [
    {
        path: '/',
        redirect: '/dashboard',
    },
    {
        path: '/dashboard',
        component: Layout,
        redirect: '/dashboard/index',
        name: 'Dashboard',
        children: [
            {
                icon: 'el-icon-location',
                name: 'Index',
                path: 'index',
                component: () => import('@/views/dashboard')
            },
            {
                icon: 'el-icon-word',
                name: 'Vocabulary',
                path: 'vocabulary',
                component: () => import('@/views/vocabulary')
            },
        ]
    },
    {
        // icon: 'el-icon-right',
        path: 'profile',
        name: 'Profile',
        component: () => import('@/views/profile')
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import('@/views/login')
    }
]

const router = new VueRouter({
    routes
})

router.beforeEach(async(to, from, next) => {
    const hasToken = getToken()
    if (hasToken) {
        if (!store.getters.name) {
            await store.dispatch('user/userInfo')
        }
        if (!store.getters.vocabulary.length) {
            await store.dispatch('vocabulary/get')
        }
    }
    if (!store.getters.routes.length) {
        await store.dispatch('permission/getRoutes', routes.find(route => route.name === 'Dashboard').children)
    }
    if (hasToken) {
        if (to.name === 'Login') {
            next({ name: 'Dashboard' }) 
        } else {
            next()
        }
    } else {
        if (to.name === 'Login') {
            next()
        } else {
            next({ name: 'Login' }) 
        }
    }
})

export default router