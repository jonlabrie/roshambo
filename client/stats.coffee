Template.stats.helpers
    currentRound: ->
        Rounds.findOne()

    overdue: ->
        clockDep.depend()
        @endTime < new Date()

    remainingTime: ->
        clockDep.depend()
        offset = Math.round (@endTime - new Date()) / 1000
        min = Math.floor offset / 60
        sec = offset % 60
        "#{min}:#{sec}"
