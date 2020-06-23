<template>
  <div class="app-wrapper">
    <div class="app-content">
      <sidebar class="sidebar-container theme-sidebar" />
      <div class="main-container">
        <navbar />
        <app-main />
      </div>
    </div>
    <div class="app-footer">
      © 2019 Learn Words
    </div>
  </div>
</template>

<script>
import { AppMain, Navbar, Sidebar } from './components'
import { mapState } from 'vuex'

export default {
  name: 'Layout',
  components: {
    AppMain,
    Navbar,
    Sidebar
  },
  methods: {
  }
}
</script>

<style lang="less" scoped>
  .app-wrapper {
    position: relative;
    height: 100%;
    width: 100%;
    display: flex;
    flex-direction: column;

    .app-content {
      display: flex;
      height: calc(100vh - 33px);
      flex-direction: row;
      .sidebar-container {
        position: relative;
      }
      .main-container {
        flex: 1;
      }
    }
    .app-footer {
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1111;
      width: 100%;
      height: 33px;
      font-size: 10px;
      font-weight: normal;
      font-stretch: normal;
      font-style: normal;
      line-height: 1.1;
      letter-spacing: 0.1px;
      color: #fff;
      background-color: #909399;
    }
  }

  .drawer-bg {
    background: #000;
    opacity: 0.3;
    width: 100%;
    top: 0;
    height: 100%;
    position: absolute;
    z-index: 999;
  }

  .fixed-header {
    position: fixed;
    top: 0;
    right: 0;
    z-index: 9;
    width: calc(100% - 300px);
    transition: width 0.28s;
  }

  .hideSidebar .fixed-header {
    width: calc(100% - 54px)
  }
</style>
