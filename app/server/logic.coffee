ROUND_LENGTH = 60 # seconds
MIN_PLAYERS = 3

Meteor.publish 'rounds', ->
    # only the latest
    Rounds.find {},
        sort: startTime: -1
        limit: 5

Meteor.publish 'plays', ->
    Plays.find user: @userId

Meteor.publish 'user-stats', ->
    Meteor.users.find @userId,
        fields:
            pointsTotal: 1
            streak: 1

Meteor.methods
    play: (choice) ->
        round = Rounds.findOne {},
            sort: startTime: -1
        if Plays.find(user: Meteor.userId(), round: round._id).count()
            throw new Meteor.Error 403, 'Already played this round'
        Plays.insert
            user: Meteor.userId()
            round: round._id
            choice: choice

    redeem: ->
        streak = Meteor.user().streak ? 0
        Meteor.users.update Meteor.userId(),
            $set: streak: 0
            $inc: pointsTotal: streakPoints streak

checkRoundEnded = ->
    round = Rounds.findOne {},
        sort: startTime: -1

    unless round?
        return newRound()

    plays = Plays.find round: round._id
    if round.endTime < new Date() and plays.count() >= MIN_PLAYERS
        counts =
            rock: Plays.find(round: round._id, choice: 'rock').count()
            paper: Plays.find(round: round._id, choice: 'paper').count()
            scissors: Plays.find(round: round._id, choice: 'scissors').count()

        switch
            when counts.rock > counts.paper and counts.rock > counts.scissors
                endRound round, 'rock', 'paper', 'scissors'
            when counts.paper > counts.rock and counts.paper > counts.scissors
                endRound round, 'paper', 'scissors', 'rock'
            when counts.scissors > counts.paper and counts.scissors > counts.rock
                endRound round, 'scissors', 'rock', 'paper'
            else
                console.log 'round tied, waiting'
                Meteor.setTimeout checkRoundEnded, 1000
    else
        Meteor.setTimeout checkRoundEnded, 1000

endRound = (round, draw, win, loss) ->
    console.log "Ending round #{round._id}"

    newRound()

    Rounds.update round._id, $set:
        endTime: new Date()
        majority: draw

    Plays.update round: round._id, choice: draw,
        $set: result: 'draw'
    , multi: true
    Plays.update round: round._id, choice: win,
        $set: result: 'win'
    , multi: true
    Plays.update round: round._id, choice: loss,
        $set: result: 'loss'
    , multi: true
    Plays.find(round: round._id, choice: loss).forEach (play) ->
        Meteor.users.update play.user, $set: streak: 0
    Plays.find(round: round._id, choice: win).forEach (play) ->
        Meteor.users.update play.user, $inc: streak: 1

newRound = ->
    startTime = moment()
    endTime = startTime.clone().add ROUND_LENGTH, 'seconds'
    last = Rounds.findOne {},
        sort: startTime: -1
    if last?
        id = Number(last._id) + 1
    else
        id = 1
    _id = id.toString()
    # probably the laziest way to do this
    while _id.length < 9
        _id = '0' + _id
    console.log "Starting round #{_id}"
    Rounds.insert
        _id: _id
        startTime: startTime.toDate()
        endTime: endTime.toDate()
    Meteor.setTimeout checkRoundEnded, ROUND_LENGTH * 1000

Meteor.startup checkRoundEnded
