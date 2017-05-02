exports = this
current = {}
exports.loadTimeDimension = (map) ->
  console.log('LOAD!!')
  # start of TimeDimension manual instantiation
  timeDimension = new (L.TimeDimension)(period: 'PT1D')
  # helper to share the timeDimension object between all layers
  map.timeDimension = timeDimension
  # otherwise you have to set the 'timeDimension' option on all layers.
  player = new (L.TimeDimension.Player)({
    transitionTime: 100
    loop: false
    startOver: true
  }, timeDimension)
  timeDimensionControlOptions =
    player: player
    timeDimension: timeDimension
    position: 'bottomleft'
    autoPlay: true
    minSpeed: 1
    speedStep: 0.5
    maxSpeed: 15
    timeSliderDragUpdate: true
  timeDimensionControl = new (L.Control.TimeDimension)(timeDimensionControlOptions)
  map.addControl timeDimensionControl
