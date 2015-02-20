# InvalidAuthenticityToken 対策
$.ajaxPrefilter (options, original_options, xhr )->
  token = $('meta[name="csrf-token"]').attr('content')
  xhr.setRequestHeader('X-CSRF-Token', token) if token
