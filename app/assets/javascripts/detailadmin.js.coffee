$ ->
  # navbar notification popups
  $(".notification-dropdown").each (index, el) ->
    $el = $(el)
    $dialog = $el.find(".pop-dialog")
    $trigger = $el.find(".trigger")
    
    $dialog.click (e) ->
        e.stopPropagation()

    $dialog.find(".close-icon").click (e) ->
      e.preventDefault()
      $dialog.removeClass("is-visible")
      $trigger.removeClass("active")

    $("body").click ->
      $dialog.removeClass("is-visible")
      $trigger.removeClass("active")

    $trigger.click (e) ->
      e.preventDefault()
      e.stopPropagation()
      
      # hide all other pop-dialogs
      $(".notification-dropdown .pop-dialog").removeClass("is-visible")
      $(".notification-dropdown .trigger").removeClass("active")

      $dialog.toggleClass("is-visible")
      if ($dialog.hasClass("is-visible"))
        $(this).addClass("active")
      else
        $(this).removeClass("active")

  # sidebar menu arrow pointer
  path = window.location.href
  $("#dashboard-menu a").each ->
    href = $(this).attr("href").replace("?", "\\?")
    if(path.match(href))
      $item = $(this).parent()
      if($item.parent().hasClass('submenu'))
        $item.find("a").toggleClass("active")
        $item = $item.parent().parent()
        $item.find(".submenu").css("display", "block")
      $item.toggleClass("active")
      $item.prepend("<div class='pointer'><div class='arrow'></div><div class='arrow_border'></div></div>")

  # sidebar menu dropdown toggle
  $("#dashboard-menu .dropdown-toggle").click (e) ->
    e.preventDefault()
    $item = $(this).parent()
    $item.toggleClass("active")
    if ($item.hasClass("active"))
      $item.find(".submenu").slideDown("fast")
    else
      $item.find(".submenu").slideUp("fast")

  # mobile side-menu slide toggler
  $menu = $("#sidebar-nav")
  $("body").click ->
    if ($(this).hasClass("menu"))
      $(this).removeClass("menu")
  $menu.click (e) ->
    e.stopPropagation()
  $("#menu-toggler").click (e) ->
    e.stopPropagation()
    $("body").toggleClass("menu")
  $(window).resize ->
    $(this).width() > 769 && $("body.menu").removeClass("menu")