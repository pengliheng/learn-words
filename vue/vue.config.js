const path = require('path')
const host = '0.0.0.0'
const port = 80

module.exports = {
  lintOnSave: false,
//   publicPath: `http://${host}:${port}/`,

  devServer: {
    port,
    host,
    hotOnly: true,
    disableHostCheck: true,
    clientLogLevel: 'warning',
    inline: true,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
      'Access-Control-Allow-Headers': 'X-Requested-With, content-type, Authorization'
    },
  }
}