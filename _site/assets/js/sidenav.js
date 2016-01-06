(function() {
  $(function() {
    $(".navlink").click(function() {
      var cardCount, clicked, loadAjax;
      clicked = $(this);
      $(".active-nav").removeClass("active-nav");
      clicked.addClass("active-nav");
      loadAjax = $.ajax("/content/" + (clicked.attr("ajax") || "about") + ".html");
      cardCount = $("#content>.card").length;
      return $("#content>.card").each(function(index) {
        var card;
        card = $(this);
        card.css("z-index", 50 + cardCount - index);
        return setTimeout(function() {
          var complete;
          return card.animate({
            left: window.innerWidth
          }, 500, complete = function() {
            card.remove();
            if (!$("#content>.card").length) {
              return loadAjax.done(function(data) {
                $("#content").html(data);
                return $("#content>.card").each(function(index_new) {
                  var card_new;
                  $(this).hide();
                  card_new = $(this);
                  return setTimeout(function() {
                    return card_new.show("slide", {
                      direction: "left"
                    }, 500);
                  }, 250 * index_new);
                });
              });
            }
          });
        }, 100 * index);
      });
    });
    return $(".button-collapse").sideNav({
      menuWidth: 300
    });
  });

}).call(this);
