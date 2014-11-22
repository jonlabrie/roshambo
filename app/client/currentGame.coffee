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

Template.playButton.helpers
    buttonClass: ->
        play = Template.parentData 1
        button = @toString()
        switch
            when button is Session.get 'pending-choice'
                'confirm-selection'
            when play.choice is button
                'selected'
            when play.choice?
                'not-selected'

    text: ->
        button = @toString()
        if button is Session.get 'pending-choice'
            'Confirm?'
        else
            switch button
                when 'rock'
                    '˚'
                when 'paper'
                    'ˉ'
                when 'scissors'
                    '^'

Template.currentGame.events
    'click .button': (event, ti) ->
        choice = event.currentTarget.id
        switch
            when @choice?
                # player already played this turn: do nothing
                false
            when choice is Session.get 'pending-choice'
                Meteor.call 'play', choice
                Session.set 'streak-risk-ok', null
                Session.set 'pending-choice', null
            else
                Session.set 'pending-choice', choice
