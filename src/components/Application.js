import React from 'react'
import SearchForm from './Form'
import Jobs from './Jobs'

export default function Application() {
  return (
    <div className="row align-items-center h-100">
      <div className="col-6 mx-auto">
        <SearchForm />
        <Jobs />
      </div>
    </div>
  )
}