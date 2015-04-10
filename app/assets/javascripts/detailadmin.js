$(function () {

  // navbar notification popups
  $(".notification-dropdown").each(function (index, el) {
    var $el = $(el);
    var $dialog = $el.find(".pop-dialog");
    var $trigger = $el.find(".trigger");
    
    $dialog.click(function (e) {
        e.stopPropagation()
    });
    $dialog.find(".close-icon").click(function (e) {
      e.preventDefault();
      $dialog.removeClass("is-visible");
      $trigger.removeClass("active");
    });
    $("body").click(function () {
      $dialog.removeClass("is-visible");
      $trigger.removeClass("active");
    });

    $trigger.click(function (e) {
      e.preventDefault();
      e.stopPropagation();
      
      // hide all other pop-dialogs
      $(".notification-dropdown .pop-dialog").removeClass("is-visible");
      $(".notification-dropdown .trigger").removeClass("active")

      $dialog.toggleClass("is-visible");
      if ($dialog.hasClass("is-visible")) {
        $(this).addClass("active");
      } else {
        $(this).removeClass("active");
      }
    });
  });

  //sidebar menu arrow pointer
  path = window.location.href;
  $("#dashboard-menu a").each(function(){
    href = $(this).attr("href").replace("?", "\\?")
    if(path.match(href)) {
      $item = $(this).parent();
      if($item.parent().hasClass('submenu')) {
        $item.find("a").toggleClass("active");
        $item = $item.parent().parent();
        $item.find(".submenu").css("display", "block");
      }
      $item.toggleClass("active");
      $item.prepend("<div class='pointer'><div class='arrow'></div><div class='arrow_border'></div></div>");
    }
  });

  // sidebar menu dropdown toggle
  $("#dashboard-menu .dropdown-toggle").click(function (e) {
    e.preventDefault();
    var $item = $(this).parent();
    $item.toggleClass("active");
    if ($item.hasClass("active")) {
      $item.find(".submenu").slideDown("fast");
    } else {
      $item.find(".submenu").slideUp("fast");
    }
  });

  // mobile side-menu slide toggler
  var $menu = $("#sidebar-nav");
  $("body").click(function () {
    if ($(this).hasClass("menu")) {
      $(this).removeClass("menu");
    }
  });
  $menu.click(function(e) {
    e.stopPropagation();
  });
  $("#menu-toggler").click(function (e) {
    e.stopPropagation();
    $("body").toggleClass("menu");
  });
  $(window).resize(function() { 
    $(this).width() > 769 && $("body.menu").removeClass("menu")
  })
});