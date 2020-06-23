<template>
  <el-menu
    class="el-menu"
    text-color="#fff"
    background-color="#545c64"
    active-text-color="#ffd04b"
  >
    <div :key="route.name" v-for="route of routes">
      <el-submenu :index="route.name" v-if="route.children && route.children.length > 0">
        <template slot="title">
          <router-link :to="route.path">
            <i :class="route.icon"></i>
            <span>{{route.name}}</span>
          </router-link>
        </template>
        <el-menu-item-group title="Group One" v-if="route.children">
          <el-menu-item :index="route.name" :key="route.name" v-for="route of route.children">
            <i :class="route.icon"></i>
            <span>{{route.name}}</span>
          </el-menu-item>
        </el-menu-item-group>
      </el-submenu>
      <el-menu-item :index="route.name" v-else>
        <router-link tag="div" :to="route.path">
          <i :class="route.icon"></i>
          <span>{{route.name}}</span>
        </router-link>
      </el-menu-item>
    </div>
  </el-menu>
</template>

<script>
import { mapGetters } from 'vuex'
import SidebarItem from './SidebarItem'

export default {
  computed: {
    ...mapGetters([
      'routes',
    ]),
  },
  components: { SidebarItem },
  methods: {
    handleOpen(key, keyPath) {
      console.log(key, keyPath);
    },
    handleClose(key, keyPath) {
      console.log(key, keyPath);
    }
  }
}
</script>


<style lang="less" scoped>
.el-menu {
  width: 200px;
}
</style>