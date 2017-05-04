(function() {
  var addToRouteInformation, addToSelector, checkDuplicateLine, current, disabled, exports, getMapCenter, hasError, initMarker, markerMoved, reloadLineName, resetRouteInformationInputs, resetSelector, setListenersOfRouteInformationInputs, setMarker, setMarkerByCurrentPosition;

  exports = this;

  current = {};

  $(function() {
    var location_updated_at;
    if ($('#bus_stop_new_map').is(':visible')) {
      console.log('***************called********************');
      current.map = create_leaflet_map('bus_stop_new_map');
      initMarker();
      setMarker();
      loadTimeDimension(map);
      $('#bus_stop_prefecture_id').on('change', function(e) {
        var $prefecture_location, id;
        id = $(e.currentTarget).val();
        $prefecture_location = $('#prefecture_location_' + id);
        setMarker($prefecture_location.data('latitude'), $prefecture_location.data('longitude'));
        getMapCenter();
        $('#location_updated_at').val("false");
        return $('#no_location_updated').removeClass("hide");
      });
      $('#get_current_position').on('click', function(e) {
        e.preventDefault();
        if (navigator.geolocation) {
          setMarkerByCurrentPosition();
        } else {
          alert("現在地を取得できませんでした");
        }
      });
      $('.route_delete').on('click', function(e) {
        $(e.currentTarget).parent().remove();
      });
      $('.line_name_reload').on('click', reloadLineName);
      setListenersOfRouteInformationInputs();
    }
    location_updated_at = $('#location_updated_at').val();
    if (location_updated_at === "false" || exports.isBlank(location_updated_at)) {
      $('#no_location_updated').removeClass("hide");
    }
    $('#new_bus_stop').on('submit', function() {
      getMapCenter();
    });
  });

  setMarker = function(lat, lng) {
    var marker;
    if (exports.isBlank(lat) || exports.isBlank(lng)) {
      lat = $('#latitude').val();
      lng = $('#longitude').val();
    }
    if (exports.isBlank(lat) || exports.isBlank(lng)) {
      lat = 19.690435317911682;
      lng = 100.81561088562013;
    }
    if (current.marker) {
      current.marker.setLatLng([lat, lng]);
    } else {
      marker = L.marker([lat, lng], {
        icon: selectIcon(null),
        draggable: true
      }).addTo(current.map);
      marker.on('dragend', function(e) {
        getMapCenter();
        markerMoved();
      });
      current.marker = marker;
    }
    getMapCenter();
    current.map.setView([lat, lng], current.map.getMaxZoom());
  };

  initMarker = function() {
    var lat, lng, marker;
    lat = 19.690435317911682;
    lng = 100.81561088562013;
    marker = L.marker([lat, lng], {
      icon: selectIcon(null),
      draggable: true
    }).addTo(current.map);
    marker.on('dragend', function(e) {
      getMapCenter();
      markerMoved();
    });
    current.marker = marker;
    current.map.setView([lat, lng], 15);
  };

  setMarkerByCurrentPosition = function(err) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(pos) {
        var crd, latitude, longitude;
        crd = pos.coords;
        if (crd) {
          longitude = crd.longitude;
          latitude = crd.latitude;
          setMarker(latitude, longitude);
          markerMoved();
        }
      }, function() {
        alert("現在地を取得できませんでした");
        return setMarker(35.681109, 139.766865);
      });
    } else {
      err();
    }
  };

  getMapCenter = function() {
    var center;
    center = current.marker.getLatLng();
    console.log(center);
    $('#latitude').val(center.lat);
    $('#longitude').val(center.lng);
  };

  markerMoved = function() {
    $('#location_updated_at').val('true');
    $('#no_location_updated').addClass("hide");
  };

  disabled = function($dom, disabled) {
    $dom.prop('disabled', disabled);
  };

  addToSelector = function($selector, key, val) {
    var _val, option;
    _val = val || $selector.children().length * -1;
    option = $('<option>').text(key).val(_val);
    $selector.append(option);
    if (_val < 0) {
      $selector.val(_val).trigger('change');
    }
  };

  addToRouteInformation = function(company, company_id, line, line_id) {
    var delete_button, line_name, link_to_edit_line, link_to_show_line, reload_button, tr;
    tr = $('<tr>');
    delete_button = $('<td>').append($('<span>').addClass("glyphicon glyphicon-remove").attr("aria-hidden", true)).addClass("route_delete");
    delete_button.on('click', function(e) {
      $(e.currentTarget).parent().remove();
    });
    tr.append(delete_button);
    tr.append($('<td>').text(company));
    reload_button = $('<button>').addClass("btn btn-default line_name_reload").text("路線名再取得").data('route-id', line_id).on('click', reloadLineName);
    line_name = $('<span>').text(line).attr('id', 'line_name_' + line_id);
    tr.append($('<td>').append([line_name, reload_button]));
    link_to_show_line = $('<a>').addClass("btn btn-default").text("路線情報").attr({
      href: "/bus_route_information/" + line_id,
      target: "_blank"
    });
    link_to_edit_line = $('<a>').addClass("btn btn-primary").text("路線名編集").attr({
      href: "/bus_route_information/" + line_id + "/edit",
      target: "_blank"
    });
    tr.append($('<td>').append([link_to_show_line, link_to_edit_line]).addClass('table_actions'));
    tr.append($('<input>').val(line_id).attr({
      name: 'bus_route_information[id][]',
      type: 'hidden'
    }));
    $('#route_informations').append(tr);
  };

  resetRouteInformationInputs = function() {
    $('#route_information_inputs').find('input').each(function(index, dom) {
      var $dom;
      $dom = $(dom);
      return $dom.val("");
    });
    $('#route_information_inputs').find('.has-error').each(function(index, dom) {
      return $(dom).removeClass('has-error');
    });
    $('[name=bus_type_id]').each(function(index, dom) {
      return disabled($(dom), true);
    });
    resetSelector($('#bus_operation_company_id'));
    resetSelector($('#bus_route_information_id'));
  };

  resetSelector = function($selector) {
    var prompt;
    prompt = $selector.children(':first');
    $selector.empty().append(prompt);
    $selector.val("");
    $selector.trigger("change");
  };

  hasError = function($input, val) {
    if (val === "" || val === null) {
      $input.parents('.form-group').addClass("has-error");
      return true;
    } else {
      $input.parents('.form-group').removeClass("has-error");
      return false;
    }
  };

  reloadLineName = function(e) {
    var ajax, id;
    e.preventDefault();
    id = $(e.currentTarget).data('route-id');
    ajax = $.ajax({
      url: "/api/bus_routes/line",
      data: {
        line_id: id
      },
      dataType: 'json',
      method: 'get'
    });
    ajax.done(function(data) {
      $('#line_name_' + data.id).text(data.name);
    });
    ajax.fail(function() {
      alert("路線名を取得できませんでした");
    });
  };

  setListenersOfRouteInformationInputs = function() {
    var $addRoute_information_inputs, $bus_operation_company_selector, $bus_route_information_selector;
    $addRoute_information_inputs = $('#route_information_inputs');
    $bus_operation_company_selector = $('#bus_operation_company_id');
    $bus_route_information_selector = $('#bus_route_information_id');
    $('#add_route_information').on('click', function(e) {
      $addRoute_information_inputs.removeClass('hide');
    });
    $('#add_route_cancel').on('click', function(e) {
      e.preventDefault();
      $addRoute_information_inputs.addClass('hide');
      resetRouteInformationInputs();
    });
    $('#add_route').on('click', function(e) {
      var ajax, company_id, company_name, data, line_id, line_name, type_id;
      e.preventDefault();
      company_id = $bus_operation_company_selector.val();
      company_name = $bus_operation_company_selector.find(':selected').text();
      line_id = $bus_route_information_selector.val();
      line_name = $bus_route_information_selector.find(':selected').text();
      if (!hasError($bus_operation_company_selector, company_id) && !hasError($bus_route_information_selector, line_id)) {
        if (company_id < 0 || line_id < 0) {
          type_id = $('[name=bus_type_id]:checked').val();
          data = {
            company_id: company_id,
            company_name: company_name,
            line_id: line_id,
            line_name: line_name,
            type_id: type_id
          };
          ajax = $.ajax({
            url: "/api/bus_routes/register",
            data: data,
            method: 'post'
          });
          ajax.done(function(result) {
            if (result.success) {
              addToRouteInformation(company_name, result.company_id, line_name, result.line_id);
              $bus_operation_company_selector.find(':selected').val(result.company_id);
              $bus_route_information_selector.find(':selected').val(result.line_id);
              $('[name=bus_type_id]').each(function(index, dom) {
                return disabled($(dom), true);
              });
              return $addRoute_information_inputs.addClass('hide');
            } else {
              return alert("バス運営会社または路線の追加を行えませんでした");
            }
          });
          ajax.fail(function() {
            return alert("バス運営会社または路線の追加を行えませんでした");
          });
        } else {
          if (checkDuplicateLine(line_id)) {
            alert("すでに登録されています");
          } else {
            addToRouteInformation(company_name, company_id, line_name, line_id);
            $addRoute_information_inputs.addClass('hide');
          }
        }
      }
      $('#route_information_inputs').find('.has-error').each(function(index, dom) {
        return $(dom).removeClass('has-error');
      });
    });
    $('#search_company').on('click', function(e) {
      var $input, ajax, company;
      e.preventDefault();
      $input = $('#search_company_name');
      company = $input.val();
      if (!hasError($input, company)) {
        ajax = $.ajax({
          url: "/api/bus_routes/companies",
          data: {
            name: company
          }
        });
        ajax.done(function(data) {
          var i, len, val;
          resetSelector($bus_operation_company_selector);
          resetSelector($bus_route_information_selector);
          for (i = 0, len = data.length; i < len; i++) {
            val = data[i];
            addToSelector($bus_operation_company_selector, val.name, val.id);
          }
        });
        ajax.fail(function(data) {
          resetSelector($bus_operation_company_selector);
          resetSelector($bus_route_information_selector);
        });
      }
    });
    $('#add_company').on('click', function(e) {
      var $input, company;
      e.preventDefault();
      $input = $('#bus_operation_company_name');
      company = $input.val();
      if (!hasError($input, company)) {
        addToSelector($bus_operation_company_selector, company);
      }
    });
    $('#add_line').on('click', function(e) {
      var $input, line;
      e.preventDefault();
      $input = $('#bus_route_line_name');
      line = $input.val();
      if (!hasError($input, line)) {
        addToSelector($bus_route_information_selector, line);
      }
    });
    $bus_operation_company_selector.on('change', function(e) {
      var ajax, val;
      val = $(e.currentTarget).val();
      if (val > 0) {
        ajax = $.ajax({
          url: "/api/bus_routes/lines",
          data: {
            company_id: val
          }
        });
        ajax.done(function(data) {
          var i, len;
          for (i = 0, len = data.length; i < len; i++) {
            val = data[i];
            addToSelector($bus_route_information_selector, val.name, val.id);
          }
        });
      }
      resetSelector($bus_route_information_selector);
    });
    $bus_route_information_selector.on('change', function(e) {
      var val;
      val = $(e.currentTarget).val();
      $('[name=bus_type_id]').each(function(index, dom) {
        return disabled($(dom), val === "" || val > 0);
      });
    });
  };

  checkDuplicateLine = function(line_id) {
    var is_duplicate;
    is_duplicate = false;
    $("[name='bus_route_information[id][]']").each(function(index, dom) {
      if (dom.value === line_id && !is_duplicate) {
        return is_duplicate = true;
      }
    });
    return is_duplicate;
  };

}).call(this);
