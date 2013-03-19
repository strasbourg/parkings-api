NamesSource = require('./sources/names').NamesSource
CoordinatesSource = require('./sources/coordinates').CoordinatesSource
AvailabilitySource = require('./sources/availability').AvailabilitySource

exports.sources = [
  new NamesSource()
  new CoordinatesSource()
  new AvailabilitySource()
]
