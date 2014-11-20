Meteor.subscribe 'rounds'
Meteor.subscribe 'plays'
Meteor.subscribe 'user-stats'

@clockDep = new Tracker.Dependency()

Meteor.setInterval ->
    clockDep.changed()
, 1000
