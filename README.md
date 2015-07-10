## RailsApiAuth

Rails API Auth is a Rails Engine that implements the "Resource Owner Password Credentials Grant" OAuth 2.0 flow as well as Facebook authentication for API projects.

It is a companion library to the [ember-simple-auth](http://ember-simple-auth.com) authentication addon for [Ember](http://emberjs.com), a front-end framework. 

But it can also be used with any other front-end systems following the oAuth2 spec.

You can install and run this [demo application](https://github.com/simplabs/rails_api_auth-demo) to see how it works in practice (hosted version coming soon).

To install on your project:

```
# Gemfile
gem 'rails_auth_api'
```

Run `bundle install` and then `rake db:migrate`.

After installation, if you run `rake routes`, you'll see the following generated routes requesting and revoking access tokens:

```
 token POST /token(.:format)         oauth2#create
revoke POST /revoke(.:format)        oauth2#destroy
```

You'll also have two helpers availabe, `authenticate!` to protect your actions on a before filter:

```
before_action :authenticate!
```

and `current_login` to access the login model object that will be created after successful login.

This gem is in its very early versions, more documentation to come very soon!

This project rocks and uses MIT-LICENSE.
