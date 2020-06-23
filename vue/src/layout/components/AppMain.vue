<template>
  <section class="app-main">
    <transition name="fade-transform" mode="out-in">
        <router-view :key="key" />
    </transition>
  </section>
</template>

<script>
export default {
  name: 'AppMain',
  computed: {
    key() {
      return this.$route.path
    }
  }
}
</script>

<style lang="less" scoped>
.app-main {
  display: flex;
  flex-direction: column;
  width: 100%;
  overflow: auto;
  position: relative;
  height: calc(100vh - 80px - 33px);
}

.fixed-header+.app-main {
  padding-top: 50px;
}

.hasTagsView {
  .fixed-header+.app-main {
    padding-top: 84px;
  }
}
</style>

<style lang="less">
.el-popup-parent--hidden .fixed-header {
  padding-right: 15px;
}
</style>
