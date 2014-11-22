Template.stats.helpers
    pointsTotal: ->
        numeral(Meteor.user().pointsTotal ? 0).format()

    showRanking: ->
        Session.get 'show-ranking'

    recentRounds: ->
        Rounds.find {}, sort: startTime: -1

    majorityGlyph: ->
        switch @majority
            when 'rock'
                '˚'
            when 'paper'
                'ˉ'
            when 'scissors'
                '^'

    streak: ->
        streak = Meteor.user().streak ? 0
        rounds: streak
        points: streakPoints streak

    showStreakButtons: ->
        @rounds and (not Plays.findOne(round: Rounds.current()?._id)?) and not Session.get 'streak-risk-ok'

    currentRound: ->
        Rounds.current()

    overdue: ->
        clockDep.depend()
        @endTime < new Date()

    remainingTime: ->
        clockDep.depend()
        numeral(Math.round (@endTime - new Date()) / 1000).format('00:00')

Template.stats.events
    'click #show-ranking': ->
        Session.set 'show-ranking', true

    'click #redeem-streak': ->
        Meteor.call 'redeem'

    'click #risk-streak': ->
        Session.set 'streak-risk-ok', true
