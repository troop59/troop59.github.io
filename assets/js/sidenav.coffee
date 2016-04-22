---
---

$ ->
  title = document.title

  registerClick = ()->
    $(".navlink").each ->
      $(this).attr("href", "##{$(this).attr("ajax")}")
    $(".navlink").click ->
      $('#sidenav-overlay').trigger('click')
      return if $(this).hasClass("active-nav")
      clicked = $(this)
      $(".active-nav").removeClass("active-nav")
      clicked.addClass("active-nav")
      #document.title = "#{clicked.text()} | #{title}"
      #document.title = title if clicked.attr("ajax") == "/list.html"
      loadAjax = $.ajax(clicked.attr("ajax"))
      cardCount = $("#content>.card,#content>.cf>.card").length
      $("#content>.card,#content>.cf>.card").each (index)->
        card = $(this)
        card.css("z-index", 50+cardCount-index)
        h = {left: window.innerWidth}
        if clicked.attr('id')=='go-back'
          h = {right: window.innerWidth}
        card.animate(h, 500, complete= ->
          setTimeout( ->
            card.remove()
            cardCount--
            if cardCount==0
              loadAjax.done (data)->
                $("#content").html(data)
                document.title = "#{$(".card:first").attr('title')} | #{title}"
                document.title = title if window.location.hash == "#/list"
                cardCount = $("#content>.card,#content>.cf>.card").length
                $("#content>.card,#content>.cf>.card").each (index_new)->
                  $(this).hide()
                  card_new = $(this)
                  setTimeout( ->
                    d = "left"
                    if clicked.attr('id')=='go-back'
                      d = "right"
                    card_new.show("slide", direction: "left", 500)
                    cardCount--
                    if cardCount==0
                      $(document).initContent()
                      registerClick()
                  , 250*index_new)
          , 50)
        )
  $(".button-collapse").sideNav(menuWidth: 300)

  if window.location.hash.length > 1
    loc = window.location.hash.substring(1)
    $("#content").load(loc, complete = ->
      $(document).initContent()
      registerClick()
      document.title = "#{$(".card:first").attr('title')} | #{title}"
      document.title = title if window.location.hash == "#/list"
    )
  else
    registerClick()
    $(document).initContent()
