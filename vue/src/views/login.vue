<template lang="pug">
    el-row.login(type="flex" size="mini" justify="space-around")
        el-col(:span="8")
            el-form(ref="ruleForm" :model="form" :rules="rules")
                el-form-item(label="User Name" prop="name")
                    el-input(v-model="form.name" @keyup.enter.native="onSubmit")
                el-form-item(label="Password" prop="password")
                    el-input(v-model="form.password" @keyup.enter.native="onSubmit")
                el-form-item
                    el-button.el-button(type="primary" @click="onSubmit") Login Or Register
</template>

<script>
import axios from 'axios'
import Api from '@/Api.js'

export default {
    data() {
        return {
            rules: {
                name: [
                    { required: true, message: 'Please input name', trigger: 'change' },
                ],
                password: [
                    { required: true, message: 'Please select Password', trigger: 'change' }
                ],
            },
            form: {
                name: '',
                password: ''
            }
        }
    },
    methods: {
        onSubmit() {
            this.$refs.ruleForm.validate(async(valid) => {
                if (valid) {
                    const signData = await Api.SignIn(this.form)
                    const {errorCode, message} = signData
                    if (signData.errorCode === 1) {
                        // not have account
                        const registerData = await Api.SignUp(this.form)
                        if (registerData.errorCode === 0) {
                            this.$message({
                                message: registerData.message,
                                type: 'success'
                            })
                            this.$router.push('/')
                        }
                    } else if (signData.errorCode === 2) {
                        // password not right
                        this.$message({
                            message: signData.message,
                            type: 'error'
                        })
                    } else if (signData.errorCode === 0) {
                        // success login
                        this.$message({
                            message: signData.message,
                            type: 'success'
                        })
                        this.form = {
                            name: '',
                            password: ''
                        }
                        this.$router.push('/')
                    }
                }
            });
        }
    }
}
</script>
<style lang="less" scoped>
.login {
    margin-top: 20vh;
    .el-button {
        width: 100%;
    }
}
</style>