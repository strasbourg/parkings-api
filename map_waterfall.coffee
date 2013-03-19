async = require 'async'

exports.mapWaterfall = (arr, fns, kkb) -> async.reduce(
  fns
  (i, cb) -> cb(null, i)
  (f, g, cb) ->
    cb(
      null
      (i, kb) ->
        f i, (err, j) ->
          g j, kb
    )
  (err, fn) ->
    async.map(
      arr
      fn
      (err, results) ->
        kkb(err, results)
    )
)
