exec = require('child_process').exec
BaseSource = require('./base').BaseSource

class CoordinatesSource extends BaseSource
  url: 'http://carto.strasmap.eu/store/data/module/parking_position.xml'
  lambertToGPS: (item, cb) ->
    cmd = "echo '#{item.x} #{item.y}' | /app/vendor/proj/bin/cs2cs -f '%.6f' +init=epsg:27561 +to +init=epsg:4326"
    console.log cmd
    exec cmd, (err, coordinates) =>
      console.log coordinates
      [lng, lat] = coordinates.split(/\s+/).splice(0,2)
      item.latitude = parseFloat lat
      item.longitude = parseFloat lng
      delete item.x
      delete item.y
      cb(null, item)
  transformations: ->
    arr = super()
    arr.push @lambertToGPS
    return arr
  rootPath: (d, cb) -> cb(null, d.root.p)
  itemPath: (i, cb) -> cb(null, i.$)

exports.CoordinatesSource = CoordinatesSource
