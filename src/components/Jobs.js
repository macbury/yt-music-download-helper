import React from 'react'
import axios from 'axios'

export default class Jobs extends React.Component {
  state = {
    size: 0
  }

  componentDidMount() {
    this.fetchJobCount()
  }

  fetchJobCount = async () => {
    const { data: { size } } = await axios.get('api/jobs')
    this.setState({ size })
    setTimeout(this.fetchJobCount, 1000)
  }

  render() {
    const { size } = this.state
    if (size === 0) {
      return null
    }
    return (
      <div className="alert alert-primary" role="alert">
        Videos left: {size}
      </div>
    )
  }
}