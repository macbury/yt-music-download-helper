import React from 'react'
import axios from 'axios'

export default class Form extends React.Component {
  state = {
    query: '',
    loading: false,
    error: null,
  }

  onFormSubmit = async (e) => {
    e.preventDefault()
    const { query } = this.state
    this.setState({ loading: true, error: null, success: null })
    
    const { data: { success, error } } = await axios.post('api/add', { query })

    this.setState({
      error,
      query: success ? '' : query,
      loading: false
    })
  }

  onQueryChange = (e) => {
    this.setState({
      query: e.target.value
    })

  }

  render() {
    const { query, loading } = this.state
    return (
      <form onSubmit={this.onFormSubmit}>
        <div className="form-group row">
          <div className="col-sm-12">
            <div className="input-group">
              <input 
                  className="form-control form-control-lg"
                  placeholder="https://www.youtube.com/watch?v=CvA0e8rJ8Y8&list=PLLGeo8gXhlUBlGStkRLPm-v3HOpwvy9KT"
                  disabled={loading}
                  type="text"
                  value={query} 
                  onChange={this.onQueryChange} />
              <div className="input-group-append">
                <button className="btn btn-primary" type="submit" disabled={loading}>
                  {loading && <span className="spinner-border spinner-border-sm"  />}
                  {!loading && 'Search'}
                </button>
              </div>
            </div>
          </div>
        </div>
      </form>
    )
  }
}