Template.stats.helpers
    pointsTotal: ->
        Meteor.user().pointsTotal ? 0

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
        offset = Math.round (@endTime - new Date()) / 1000
        min = Math.floor offset / 60
        if min < 10
            min = '0' + min
        sec = offset % 60
        if sec < 10
            sec = '0' + sec
        "#{min}:#{sec}"

Template.stats.events
    'click #show-ranking': ->
        Session.set 'show-ranking', true
        
    'click #redeem-streak': ->
        Meteor.call 'redeem'

    'click #risk-streak': ->
        Session.set 'streak-risk-ok', true
