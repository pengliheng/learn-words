<template lang="pug">
  .vocabulary
    el-card(:body-style="{ padding: '0px' }")
      img.image(src="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png")
      div(style="padding: 14px;")
        el-input(v-model="letter")
</template>

<script>
export default {
  name: 'vocabulary',
  data() {
    return {
      letter: ''
    }
  }
}
</script>

<style lang="less" scoped>
.vocabulary {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>