---
---

$.fn.initContent = ->
  $('select').material_select()
  $('.materialboxed').materialbox()
  $("#poll-q6-wrapper").hide()
  $("#poll-q5").change( ->
    if $(this).val() >= 2
      $("#poll-q6-wrapper").show()
    else
      $("#poll-q6-wrapper").hide()
  )
