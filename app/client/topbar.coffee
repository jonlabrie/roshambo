Accounts.ui.config
    passwordSignupFields: 'USERNAME_AND_OPTIONAL_EMAIL'

Template.topbar.helpers
    connectionStatus: Meteor.status

    retryTimeOffset: ->
        moment(@retryTime).fromNow()
