import Vue from 'vue';
import App from './App.vue';
import router from '@/router'
import store from '@/store'
import VueRouter from 'vue-router'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import '@/styles/reset.less'

Vue.config.productionTip = false;
Vue.use(VueRouter)
Vue.use(ElementUI);

Vue.config.devtools = true

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount('#app');
