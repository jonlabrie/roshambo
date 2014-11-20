Meteor.subscribe 'rounds'
Meteor.subscribe 'plays'
@clockDep = new Tracker.Dependency()

Meteor.setInterval ->
    clockDep.changed()
, 1000
