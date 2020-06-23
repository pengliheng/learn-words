<template lang="pug">
  .dashboard
    .nav 
      el-button(type="success" @click="visable.addWord = true") Add Vocabulary
    el-table(stripe :data="vocabulary" border)
      el-table-column(sortable prop="name" label="Vocabulary Name.")
        template(slot-scope="scope")
          el-input(v-if="currentEditLineId === scope.row._id" v-model="scope.row.name" size="mini")
          span(v-else) {{scope.row.name}}
      el-table-column(sortable prop="author" label="Vocabulary Author.")
        template(slot-scope="scope")
          el-input(v-if="currentEditLineId === scope.row._id" v-model="scope.row.author" size="mini")
          span(v-else) {{scope.row.author}}
      el-table-column(sortable prop="createAt" label="CreateAt")
        template(slot-scope="scope")
          span {{scope.row.createAt | parseDate}}
      el-table-column(prop="updateAt" sortable label="UpdateAt")
        template(slot-scope="scope")
          span {{scope.row.updateAt | parseDate}}
      el-table-column(label="Action" width="160" fixed="right")
        template(slot-scope="scope")
          el-button(@click="handleUpdateBook(scope.row)" v-if="currentEditLineId === scope.row._id" size="mini" type="success") Save
          el-button(@click="currentEditLineId=scope.row._id" v-else size="mini" type="primary") Edit
          el-button(@click="handleDeleteBook(scope.row._id)" size="mini" type="danger") Delete
    el-dialog(title="Add Word" :visible.sync="visable.addWord")
      el-form(:model="form" label-position="top" :rules="rules" ref="form")
        el-form-item(label="Activity name" prop="name")
          el-input(v-model="form.name")
      span.dialog-footer(slot="footer")
        el-button(@click="visable.addWord = false") Cancel
        el-button(type="primary" @click="handleCreateVocabulary") Confirm
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  name: 'dashboard',
  computed: {
    ...mapGetters([
      'vocabulary'
    ])
  },
  filters: {
    parseDate(date) {
      return (
        new Date(date).toLocaleDateString() +
        " " +
        new Date(date).toLocaleTimeString()
      );
    }
  },
  data() {
    return {
      currentEditLineId: String(Math.random()),
      letter: '',
      visable: {
        addWord: false
      },
      form: {
        name: '',
      },
      rules: {
        name: [
          { required: true, message: 'Please input Activity name', trigger: 'blur' },
        ],
      },
    }
  },
  mounted() {
    this.$store.dispatch('vocabulary/get')
  },
  methods: {
    handleCreateVocabulary() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.$store.dispatch('vocabulary/create', this.form)
          this.visable.addWord = false
          this.form = {
            name: '',
          }
        }
      });
    },
    async handleUpdateBook(vocabulary) {
      await this.$store.dispatch('vocabulary/update', vocabulary)
      this.currentEditLineId = "";
    },
    async handleDeleteBook(id) {
      await this.$store.dispatch('vocabulary/delete', id)
      this.currentEditLineId = "";
    }
  }
}
</script>

<style lang="less" scoped>
.dashboard {
  height: 100%;
  padding: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  .nav {
    width: 100%;
    display: flex;
    margin-bottom: 10px;
    padding-bottom: 10px;
    justify-content: flex-end;
    // border-bottom: 1px dashed #ccc;
  }
}
</style>