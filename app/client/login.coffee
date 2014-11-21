loginFormState = -> Session.get('login-state') ? 'login'

Template.login.helpers
    stateIs: (state) -> state is loginFormState()

    message: ->
        message = Session.get('login-message') ? switch loginFormState()
            when 'register'
                '''This seems to be a new account. Please confirm your password, and
                   provide an email address in case you need to recover your password.'''
            when 'fail'
                '''Incorrect password. You can try again, or, if you registered with
                   your email address, ask for a reset email.'''

    buttonText: ->
        switch loginFormState()
            when 'login'
                'Log in'
            when 'register'
                'Sign up'
            when 'fail'
                'Try again'

Template.login.events
    'click #login-button': (event, ti) ->
        username = ti.$('#login-user').val()
        password = ti.$('#login-pass').val()
        Session.set 'login-message', null
        switch loginFormState()
            when 'login', 'fail'
                Meteor.loginWithPassword {username: username}, password, (error) ->
                    if error?
                        switch error.reason
                            when 'User not found'
                                Session.set 'login-state', 'register'
                            when 'Incorrect password'
                                Session.set 'login-state', 'fail'
                            else
                                console.log error
                                Session.set 'login-message', 'something went wrong, sorry :-('
                    else
                        Session.set 'login-message', null
                        Session.set 'login-state', null
            when 'register'
                email = ti.$('#login-email').val()
                password2 = ti.$('#login-pass2').val()
                switch
                    when password isnt password2
                        Session.set 'login-message', 'passwords differ'
                        ti.$('#login-pass, #login-pass2').addClass 'error'
                    else
                        Accounts.createUser
                            username: username
                            email: email
                            password: password
                        , (error) ->
                            if error?
                                console.log error
                                Session.set 'login-message', 'something went wrong, sorry :-('
                            else
                                Session.set 'login-message', null
                                Session.set 'login-state', null

    'click #login-reset': ->
        alert 'not yet implemented'
