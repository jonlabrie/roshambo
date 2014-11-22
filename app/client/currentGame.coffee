Template.currentGame.helpers
    myPlay: ->
        round = Rounds.current()
        play = Plays.findOne(round: round?._id)
        switch
            when play?
                play
            when Session.get 'streak-risk-ok'
                {}
            when (Meteor.user().streak ? 0) is 0
                {}
            else
                null

    # so much for DRY :-/ the current version of jade-meteor doesn't allow
    # passing arguments in helpers called inside attributes
    rockClass: ->
        if @choice is 'rock'
            'selected'
        else if @choice?
            'not-selected'

    paperClass: ->
        if @choice is 'paper'
            'selected'
        else if @choice?
            'not-selected'

    scissorsClass: ->
        if @choice is 'scissors'
            'selected'
        else if @choice?
            'not-selected'

Template.currentGame.events
    'click .button': (event, ti) ->
        unless @choice?
            if confirm 'Your choice can\'t be changed once entered. Are you sure?'
                Meteor.call 'play', event.currentTarget.id
            Session.set 'streak-risk-ok', null
