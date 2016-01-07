---
---

$ ->
  $(".navlink").click ->
    $('#sidenav-overlay').trigger('click')
    clicked = $(this)
    $(".active-nav").removeClass("active-nav")
    clicked.addClass("active-nav")
    loadAjax = $.ajax("content/#{ clicked.attr("ajax") || "about" }.html")
    cardCount = $("#content>.card").length
    $("#content>.card").each (index)->
      card = $(this)
      card.css("z-index", 50+cardCount-index)
      setTimeout( ->
        card.animate({left: window.innerWidth}, 500, complete= ->
          card.remove()
          unless $("#content>.card").length
            loadAjax.done (data)->
              $("#content").html(data)
              $("#content>.card").each (index_new)->
                $(this).hide()
                card_new = $(this)
                setTimeout( ->
                  card_new.show("slide", direction: "left", 500)
                , 250*index_new)
        )
      , 100*index)
  $(".button-collapse").sideNav(menuWidth: 300)
