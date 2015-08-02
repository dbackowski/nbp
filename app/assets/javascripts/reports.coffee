# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@url_params = () ->
  params = location.search.replace('?','')
  params = params.split('&')

  url_params = {}

  for param in params
    [key, value] = param.split('=')

    if key
      url_params[key] = value.replace(/\+/g," ")

  url_params

$(document).on 'change', '#reports-code', ->
  params = url_params()
  params['code'] = this.value

  $.ajax
    url: location.href.split('?')[0]
    data: decodeURIComponent($.param(params))
    dataType: 'script'

    beforeSend: () ->
      $('body').addClass("loading")

    success: () ->
      if history.pushState
        url = this.url.replace(new RegExp("\&\_=[0-9]+", "g"), '')
        window.history.pushState(null, null, url)

    complete: () ->
      $('body').removeClass("loading")

$(document).on 'change', '#reports-type', ->
  params = url_params()
  params['type'] = this.value

  $.ajax
    url: location.href.split('?')[0]
    data: decodeURIComponent($.param(params))
    dataType: 'script'

    beforeSend: () ->
      $('body').addClass("loading")

    success: () ->
      if history.pushState
        url = this.url.replace(new RegExp("\&\_=[0-9]+", "g"), '')
        window.history.pushState(null, null, url)

    complete: () ->
      $('body').removeClass("loading")

$(document).on 'change', '#reports-year', ->
  params = url_params()
  params['year'] = this.value

  $.ajax
    url: location.href.split('?')[0]
    data: decodeURIComponent($.param(params))
    dataType: 'script'

    beforeSend: () ->
      $('body').addClass("loading")

    success: () ->
      if history.pushState
        url = this.url.replace(new RegExp("\&\_=[0-9]+", "g"), '')
        window.history.pushState(null, null, url)

    complete: () ->
      $('body').removeClass("loading")
