exports = this
current = {}
exports.loadTimeDimension = (map) ->
  console.log('LOAD!!')
  # start of TimeDimension manual instantiation
  timeDimension = new (L.TimeDimension)({
    timeInterval: "2017-04-01/2017-05-04",
    period: 'P1D'
  })
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
    autoPlay: false
    minSpeed: 1
    speedStep: 0.5
    maxSpeed: 15
    timeSliderDragUpdate: true
  timeDimensionControl = new (L.Control.TimeDimension)(timeDimensionControlOptions)
  map.addControl timeDimensionControl
  # add fire layer
  fireLayer = L.timeDimension.layer.fireHeatMap()
  fireLayer.addTo(map);
  # add window layer
  #windowLayer = L.timeDimension.layer.windowMap()
  #windowLayer.addTo(map);

L.TimeDimension.Layer.FIREHeatMap = L.TimeDimension.Layer.extend({
  initialize: (options) ->
    layer = newHeatmapLayerInto()
    L.TimeDimension.Layer.prototype.initialize.call(this, layer, options)
    this._currentTimeData = {
      data: []
    }
  onAdd: (map) ->
    console.log('onAdd')
    L.TimeDimension.Layer.prototype.onAdd.call(this, map)
    map.addLayer(this._baseLayer);
    if (this._timeDimension)
      this._getDataForTime(this._timeDimension.getCurrentTime());

  _onNewTimeLoading: (ev) ->
    this._getDataForTime(ev.time);

  isReady: (time) ->
    return (this._currentLoadedTime == time);

  _update: () ->
    this._baseLayer.setData(this._currentTimeData);
    return true;

  _getDataForTime: (time) ->
    console.log('loaded : ' + time)
    $.getJSON '/data/fire.json', ((data) ->
      delete this._currentTimeData.data;
      this._currentTimeData.data = [];
      this._currentTimeData.data = data
      console.log(this._currentTimeData)
      this._currentLoadedTime = time;
      if (this._timeDimension && time == this._timeDimension.getCurrentTime() && !this._timeDimension.isLoading())
        this._update();
      this.fire('timeload', {
        time: time
      });
    ).bind(this)
})
L.timeDimension.layer.fireHeatMap = (options) ->
  return new L.TimeDimension.Layer.FIREHeatMap(options);
