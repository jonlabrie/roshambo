Meteor.subscribe 'ranking'

Template.ranking.helpers
    topScores: ->
        Meteor.users.find pointsTotal: $gt: 0,
            sort: pointsTotal: -1
            limit: 10

    topStreaks: ->
        Meteor.users.find longestStreak: $gt: 0,
            sort: longestStreak: -1
            limit: 10

Template.ranking.events
    'click #ranking': ->
        Session.set 'show-ranking', null
