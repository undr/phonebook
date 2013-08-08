# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ () ->
  $(document).on 'click', '#cancel-form-button', (event) ->
    $('#form-placeholder').html('')
    false

  $(document).on 'click', '#cancel-search-button', (event) ->
    $('#search-form input[name="query"]').val('')
    $('#search-form').submit()
    false

  $(document).on 'click', '#create-button', (event) ->
    $('#form-placeholder').html($('#create-form-template').html())
    false
  false
