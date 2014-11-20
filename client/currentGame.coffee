Template.currentGame.helpers
    myPlay: ->
        round = Rounds.findOne()
        Plays.findOne(round: round?._id) ? {}

    # so much for DRY :-/ the current version of jade-meteor doesn't allow
    # passing arguments in helpers called inside attributes
    rockClass: ->
        if @choice is 'rock'
            'selected'

    paperClass: ->
        if @choice is 'paper'
            'selected'

    scissorsClass: ->
        if @choice is 'scissors'
            'selected'

Template.currentGame.events
    'click .button': (event, ti) ->
        Meteor.call 'play', event.currentTarget.id
