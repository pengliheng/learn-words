/// <reference types="webpack-env" />
import * as React from "react"
import * as ReactDOM from "react-dom"
import { HashRouter, Route, Link } from 'react-router-dom'
import List from "./views/List"
import Detail from "./views/Detail"
import SignUp from "./views/SignUp"
import SignIn from "./views/SignIn"

if (module.hot) {
  module.hot.accept()
}

const App: React.FunctionComponent = () => (
  <HashRouter>
    <div>
      <nav>
        <ul>
          <li>
            <Link to="/">Dashboard</Link>
          </li>
          <li>
            <Link to="/detail">Review Words</Link>
          </li>
          <li>
            <Link to="/signIn">Sign in</Link>
          </li>
          <li>
            <Link to="/signUp">Sign up</Link>
          </li>
        </ul>
      </nav>
      <Route path="/" exact component={List} />
      <Route path="/detail" component={Detail} />
      <Route path="/signIn" component={SignIn} />
      <Route path="/signUp" component={SignUp} />
    </div>
  </HashRouter>
)

ReactDOM.render(
    <App />,
    document.querySelector("#root")
)