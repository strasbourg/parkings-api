express = require 'express'
async = require 'async'
dataSources = require('./data_sources').sources

app = express()

app.get '/', (req, res) -> res.redirect('/parkings')

app.get '/parkings', (req, res) ->
  async.parallel(
    dataSources.map (dataSource) ->
      (cb) -> dataSource.fetch.call dataSource, cb
    (err, results) ->
      # merge results into a single JSON
      hsh = {}
      results.forEach (result) ->
        Object.keys(result).forEach (id) ->
          hsh[id] ||= {}
          Object.keys(result[id]).forEach (attr) ->
            hsh[id][attr] = result[id][attr]
      res.json Object.keys(hsh).map (key) -> hsh[key]
  )

app.listen process.env.PORT || 3000
