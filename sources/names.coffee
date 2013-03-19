BaseSource = require('./base').BaseSource

class NamesSource extends BaseSource
  url: 'http://jadyn.strasbourg.eu/jadyn/config.xml'
  keyMapping:
    'Ident': 'id'
    'Nom': 'name'
    'NomCourt': 'short_name'
    'NbPDM': 'NbPDM'
  rootPath: (d, cb) -> cb(null, d.configuration.TableDesParcsDeStationnement[0].PRK)
  itemPath: (i, cb) -> cb(null, i.$)

exports.NamesSource = NamesSource
