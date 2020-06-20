import Api from '@/Api.js'

export default {
    state: () => ({
        name: '',
        token: ''
    }),
  mutations: {
    login (state) {
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
  }
}