async = require 'async'
parseString = require('xml2js').parseString
request = require 'request'
mapWaterfall = require('../map_waterfall').mapWaterfall

class BaseSource
  constructor: ->
  integerAttributes: []
  floatAttributes: []
  keyMapping: {}
  rootPath: null
  itemPath: null
  transformations: ->
    @defaultTransformations()
  _transformations: ->
   arr = @transformations()
   arr.push @parseNumberAttributes
   arr.push @parseId
   return arr
  defaultTransformations: ->
    [
      @itemPath
      @applyKeyMapping
    ]
  fetch: (cb) ->
    request
      url: @url
      (e, r, result) =>
        @parse result, cb
  parseNumberAttributes: (item, cb) =>
    @integerAttributes.forEach (attr) -> item[attr] = parseInt(item[attr])
    @floatAttributes.forEach (attr) -> item[attr] = parseFloat(item[attr])
    cb(null, item)
  parseId: (item, cb) ->
    item.id = parseInt item.id
    cb(null, item)
  applyKeyMapping: (item, cb) =>
    async.reduce(
      Object.keys(@keyMapping)
      item
      (newItem, key, kb) =>
        if newItem.hasOwnProperty key
          newItem[@keyMapping[key]] = newItem[key]
          delete newItem[key]
        kb(null, newItem)
      (err, newItem) -> cb(err, newItem)
    )
  parse: (data, cb) ->
    parseString data, (err, data) =>
      @rootPath data, (err, items) =>
        mapWaterfall items, @_transformations(), (err, items) ->
          cb(err, items)
exports.BaseSource = BaseSource
