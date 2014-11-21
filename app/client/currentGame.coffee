Template.currentGame.helpers
    myPlay: ->
        round = Rounds.findOne()
        Plays.findOne(round: round?._id) ? {}

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
