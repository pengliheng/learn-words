<template lang="pug">
  .vocabulary
    el-card(:body-style="{ padding: '0px' }")
      .imageContainer
        img.image(v-for="(url,i) of randomOne.images" v-if="i<6" :key="url" :src="url")
      div(style="padding: 14px;")
        el-input(v-model="letter" @keyup.enter.native="handleSubmit")
</template>

<script>
export default {
  name: 'vocabulary',
  computed: {},
  data() {
    return {
      letter: '',
      randomOne: ''
    }
  },
  async mounted() {
    this.getRandomOne()
  },
  methods: {
    async getRandomOne() {
      this.randomOne = await this.$store.dispatch('vocabulary/getRandomOne')
    },
    handleSubmit() {
      if (this.letter === this.randomOne.name) {
        this.$message.success('Right!')
        this.letter = ''
        this.getRandomOne()
      }else{
        this.$message.error('Wrong!')
      }
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
  .imageContainer {
    width: 777px;
    display: flex;
    flex-wrap: wrap;
    flex-direction: row;
    justify-content: space-between;
    .image {
      padding: 14px;
    }
  }
}
</style>
