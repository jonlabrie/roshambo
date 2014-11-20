Template.currentGame.events
    'click .button': (event, ti) ->
        ti.$('.button').removeClass 'selected'
        $(event.currentTarget).addClass 'selected'
