import React, { Component } from 'react'
import Axios from 'axios'
import config from '../global/config.json'

const API = config.api_url

export default class Generic extends Component{
  constructor(props){
    super(props)
    this.state = {}
  }
  render(){
    return(
      <div>
        Project is running!
      </div>
    )
  }
}
