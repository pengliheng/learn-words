import * as express from 'express'
import * as webpack from 'webpack'
import * as path from 'path'
import * as logSymbols from 'log-symbols'
import * as webpackHotMiddleware from 'webpack-hot-middleware'
import * as webpackMiddleware from 'webpack-dev-middleware'
import config from "../webpack.config"

const port:string = process.env.PORT || "8080"
const app:express.Application = express()
const isDeveloping:boolean = process.env.NODE_ENV !== 'production'
const staticPath:string = 'dist'

if (isDeveloping) {
  const compiler:webpack.Compiler = webpack(config)
  app.use((req:express.Request, _:express.Response, next:express.NextFunction)=> {
    // tslint:disable-next-line
    console.log(logSymbols.info, `request: ${req.url}`)
    next()
  }).use(webpackMiddleware(compiler)).use(webpackHotMiddleware(compiler))
}
app.use(express.static(path.join(__dirname, staticPath)))

app.listen(Number(port), '0.0.0.0', () => {
  // tslint:disable-next-line
  console.log(logSymbols.success, `frontend listening on port ${port}!`)
})
