import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import {BrowserRouter, Route, Redirect} from 'react-router-dom'
import Cookie from 'universal-cookie'

// Route Components
import Generic from './home/main.jsx'

const cookie = new Cookie()

export default class Router extends Component{
  constructor(props){
    super(props);
    this.state = {
      auth: false
    }
  }
  render(){
    return(
      <div>
        <BrowserRouter>
          <div>
            <Route exact path="/" component={Generic} />
            <Route exact path="/dashboard" render={(props) => (
              cookie.get("cookie_name") ? (
                <Generic {...props} />
              ) : (
                <Redirect to="/"/>
              )
            )}/>
          </div>
        </BrowserRouter>
      </div>
    )
  }
}
