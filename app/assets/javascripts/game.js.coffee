$ ->
    $("#wikipedia-area a").click (e) ->
        if( !$(this).attr('href').match('#'))
            e.preventDefault()
            $("#poster input[name=game_id]").val $(this).data('game_id')
            $("#poster input[name=article]").val $(this).data('article')
            $("#poster").submit()