---
---

$ ->
  title = document.title

  slideIn = (loadAjax)->
    loadAjax.done (data)->
      $("#content").html(data)
      document.title = "#{$(".card:first").attr('title')} | #{title}"
      document.title = title if window.location.hash == ""
      cardCount = $("#content>.card,#content>.cf>.card").length
      $("#content>.card,#content>.cf>.card").each (index_new)->
        $(this).hide()
        card_new = $(this)
        setTimeout( ->
          card_new.show("slide", direction: "left", 500)
          cardCount--
          if cardCount==0
            $(document).initContent()
            registerClick()
        , 250*index_new)

  slideOut = (h, loadAjax)->
    cardCount = $("#content>.card,#content>.cf>.card").length
    $("#content>.card,#content>.cf>.card").each (index)->
      card = $(this)
      card.css("z-index", 50+cardCount-index)
      card.animate(h, 500, complete= ->
        setTimeout( ->
          card.remove()
          cardCount--
          if cardCount==0
            slideIn(loadAjax)
        , 50)
      )

  goBack = ()->
    loc = window.location.hash.substring(1)
    loc = 'list' if loc == ''
    console.log(loc)
    loadAjax = $.ajax(loc)
    slideOut({right: window.innerWidth}, loadAjax)

  registerClick = ()->
    $("#go-back").click ->
      window.history.back()
    $("#home").click ->
      unless window.location.hash.substring(1)==''
        window.history.pushState({}, '', '/')
        loadAjax = $.ajax('list')
        slideOut({right: window.innerWidth}, loadAjax)
    $(".navlink").click ->
      $('#sidenav-overlay').trigger('click')
      clicked = $(this)
      window.history.pushState({}, '', "##{clicked.attr('ajax')}")
      loadAjax = $.ajax(clicked.attr("ajax"))
      slideOut({left: window.innerWidth}, loadAjax)
  $(".button-collapse").sideNav(menuWidth: 300)

  if window.location.hash.length > 1
    loc = window.location.hash.substring(1)
    $("#content").load(loc, complete = ->
      $(document).initContent()
      registerClick()
      document.title = "#{$(".card:first").attr('title')} | #{title}"
      document.title = title if window.location.hash == ""
    )
  else
    registerClick()
    $(document).initContent()

  window.onpopstate = goBack
