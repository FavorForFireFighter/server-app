exports = this
current = {}
exports.loadTimeDimension = (map) ->
  console.log('LOAD!!')
  # start of TimeDimension manual instantiation
  timeDimension = new (L.TimeDimension)({
    timeInterval: "2017-04-27/2017-05-04",
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
  windLayer = L.timeDimension.layer.windMap({}, map)
  windLayer.addTo(map);

# define fire heatmapLayer
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
    console.log(_getFullDate(time))
    $.getJSON '/data/fire/' + _getFullDate(time) + '.json', ((data) ->
      delete this._currentTimeData.data;
      this._currentTimeData.data = [];
      this._currentTimeData.data = data
      this._currentLoadedTime = time;
      if (this._timeDimension && time == this._timeDimension.getCurrentTime() && !this._timeDimension.isLoading())
        this._update();
      this.fire('timeload', {
        time: time
      });
    ).bind(this)
})

_getFullDate = (time) ->
  date = new Date(time)
  year = date.getFullYear()
  month = (1 + date.getMonth()).toString()
  if (month.length == 1)
    month = '0' + month
  day = date.getDate().toString()
  if (day.length == 1)
    day = '0' + day
  return year + '-' + month + '-' + day
# define Wind Map Layer
L.TimeDimension.Layer.WindMap = L.TimeDimension.Layer.extend({
  initialize: (options, map) ->
    layer = createWindLayerInto(map)
    L.TimeDimension.Layer.prototype.initialize.call(this, layer, options)
    this._currentTimeData = {
      data: []
    }
  onAdd: (map) ->
    console.log('onAdd:Wind')
    L.TimeDimension.Layer.prototype.onAdd.call(this, map)
    #map.addLayer(this._baseLayer);
    if (this._timeDimension)
      this._getDataForTime(this._timeDimension.getCurrentTime());

  _onNewTimeLoading: (ev) -> this._getDataForTime(ev.time);

  isReady: (time) ->
    return (this._currentLoadedTime == time);

  #_update: () ->
    #this._baseLayer.setData(this._currentTimeData);
  #  return true;

  _getDataForTime: (time) ->
    console.log('loaded(Wind): ' + time)
    this._baseLayer.loadData('/data/fire/' + _getFullDate(time) + '.json', '/data/wind.json')
})
L.timeDimension.layer.fireHeatMap = (options) ->
  return new L.TimeDimension.Layer.FIREHeatMap(options);
L.timeDimension.layer.windMap = (options, map) ->
  return new L.TimeDimension.Layer.WindMap(options, map);
