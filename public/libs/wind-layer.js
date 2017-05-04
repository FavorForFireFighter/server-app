function createWindLayerInto(map) {
  var svgLayer = d3.select(map.getPanes().overlayPane).append('svg');
  svgLayer.attr('class', 'leaflet-zoom-hide fill');
  var plotLayer = svgLayer.append('g');

  function putParticle(svgLayer, fire, wind) {

    var index = (90-Math.round(fire.lat))*360 + Math.round(fire.lng)
    var v = {
      x: wind[0].data[index] * 10,
      y: -wind[1].data[index] * 10
    };

    var size = 5;
    var firePos = map.latLngToLayerPoint(new L.LatLng(fire.lat, fire.lng));
    var x = d3.randomUniform(firePos.x-size, firePos.x+size);
    var y = d3.randomUniform(firePos.y-size, firePos.y+size);

    var circle = plotLayer.append("circle")
      .attr("cx", x)
      .attr("cy", y)
      .attr("r", 2)
      .attr("fill", "#ffb")
      .attr("stroke", "#fb9")
      .attr("class", "particle");

    var translate = "translate(" + Math.round(v.x) + "," + Math.round(v.y) + ")";

    circle.transition()
      .duration(d3.randomUniform(500, 1500))
      .ease(d3.easeLinear)
      .attr("transform", translate)
      .on('end', function () {
        d3.select(this).remove();
      });
  }
  var timers = []
  function clearTimer() {
    timers.forEach(function(timer) {
       clearInterval(timer);
    });
    timers = [];
  }

  function fitLayer() {
    var bounds = map.getBounds();
    var topLeft = map.latLngToLayerPoint(bounds.getNorthWest());
    var bottomRight = map.latLngToLayerPoint(bounds.getSouthEast());

    svgLayer.attr("width", bottomRight.x - topLeft.x)
      .attr("height", bottomRight.y - topLeft.y)
      .style("left", topLeft.x + "px")
      .style("top", topLeft.y + "px");

    plotLayer.attr('transform', 'translate('+ -topLeft.x + ',' + -topLeft.y + ')');
  }

  var reset = function() {}

  map.on("zoom", function() {
    reset();
  });

  map.on("moveend", function() {
    reset();
  });

  function loadData(fireData, windData) {

    var bounds = map.getBounds();
    var northWest = bounds.getNorthWest();
    var southEast = bounds.getSouthEast();

    reset = function() {
      clearTimer();
      fitLayer();
      loadData(fireData, windData);
    }

    $.getJSON(windData, function(wind) {
      $.getJSON(fireData, function(data) {
        data.forEach(function(fire) {
          if (northWest.lat < fire.lat || fire.lat < southEast.lat) {
            return;
          }
          if ( fire.lng < northWest.lng || southEast.lng < fire.lng) {
            return;
          }

          var interval = fire.value > 400 ? 1000 : fire.value > 300 ? 5000 - fire.value*10 : 2000

          timers.push(setInterval(
            function() {
              putParticle(svgLayer, fire, wind);
            },
            interval
          ));
        });
      });
    });
  };

  return {
    svgLayer: svgLayer,
    plotLayer: plotLayer,
    loadData: loadData
  }
}
