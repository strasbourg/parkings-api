BaseSource = require('./base').BaseSource

class AvailabilitySource extends BaseSource
  url: 'http://jadyn.strasbourg.eu/jadyn/dynn.xml'
  keyMapping:
    'Ident': 'id'
    'Etat': 'state'
    'Total': 'total'
    'Libre': 'available'
    'InfoUsager': 'user_information'
  stripUserInformation: (item, cb) ->
    item.user_information = item.user_information.replace(/^\s+|\s+$/g, '')
    cb(null, item)
  integerAttributes: [
    'total'
    'available'
    'state'
  ]
  transformations: ->
    arr = super()
    arr.push @stripUserInformation
    return arr
  rootPath: (d, cb) -> cb(null, d.donnees.TableDonneesParking[0].PRK)
  itemPath: (i, cb) -> cb(null, i.$)

exports.AvailabilitySource = AvailabilitySource
