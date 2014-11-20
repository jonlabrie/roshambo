ROUND_LENGTH = 60 # seconds
MIN_PLAYERS = 2

Meteor.publish 'rounds', ->
    # only the latest
    Rounds.find {},
        sort: started: -1
        limit: 1

Meteor.publish 'plays', ->
    Plays.find user: @userId

checkRoundEnded = ->
    round = Rounds.findOne {},
        sort: started: -1

    unless round?
        return newRound()

    plays = Plays.find round: round._id
    if round.endTime < new Date() and plays.count() >= MIN_PLAYERS
        endRound()
    else
        Meteor.setTimeout checkRoundEnded, 1000

endRound = ->
    console.log 'process round'
    newRound()

newRound = ->
    startTime = moment()
    endTime = startTime.clone().add ROUND_LENGTH, 'seconds'
    last = Rounds.findOne {},
        sort: started: -1
    if last?
        id = last._id + 1
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
