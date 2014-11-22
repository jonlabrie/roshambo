@Rounds = new Meteor.Collection 'rounds'

Rounds.current = ->
    Rounds.findOne {}, sort: startTime: -1
