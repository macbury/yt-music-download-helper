import React from 'react'
import SearchForm from './Form'

export default function Application() {
  return (
    <div className="row align-items-center h-100">
      <div className="col-12 mx-auto">
        <SearchForm />

        <iframe src="/api/sidekiq" style={{ width: '100%', height: '480px', border: '0px' }}></iframe>
      </div>
    </div>
  )
}