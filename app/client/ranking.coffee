Meteor.subscribe 'ranking'

class StopIteration
    # ripped off from python -- as there's no easier way to interrupt
    # cursor.forEach()

includePlayer = (cursor) ->
    # We need to actually run the cursor and go through the results in order
    # to figure out the user's rank.
    id = Meteor.userId()
    rank = -1
    results = []
    try
        cursor.forEach (user, i) ->
            if user._id is id
                rank = user.rank = i + 1
                if i >= 10
                    # just found the user, and top 10 already in
                    results.pop
                    results.push user
                    throw new StopIteration
                else
                    # found the user, but in top 10
                    results.push user
            else if i < 10
                # in top 10 (but not the user)
                results.push user
            else if rank > -1
                # past the top 10, and the user was in there already
                throw new StopIteration
    catch e
        if e not instanceof StopIteration
            throw e
    results

Template.ranking.helpers
    topScores: ->
        includePlayer Meteor.users.find pointsTotal: $gt: 0,
            sort: pointsTotal: -1

    topStreaks: ->
        includePlayer Meteor.users.find longestStreak: $gt: 0,
            sort: longestStreak: -1

    rowClass: ->
        if @_id is Meteor.userId()
            'you'

    formatScore: ->
        numeral(@pointsTotal).format()

Template.ranking.events
    'click #ranking': ->
        Session.set 'show-ranking', null
