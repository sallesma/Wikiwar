$ ->
    $("#wikipedia-area a").click (e) ->
        if( !$(this).attr('href').match('#'))
            e.preventDefault()
            $("#poster input[name=game_id]").val $(this).data('game_id')
            $("#poster input[name=article]").val $(this).data('article')
            $("#poster").submit()

    setInterval ->
        created_at = $("#timer-int").html()
        now = Date.now()/1000
        $("#timer").html(Math.round(now - created_at))
    ,1000
