# RailsApiAuth

[![Build Status](https://travis-ci.org/simplabs/rails_api_auth.svg)](https://travis-ci.org/simplabs/rails_api_auth)

Rails API Auth is a lightweight Rails Engine that __implements the _"Resource
Owner Password Credentials Grant"_ OAuth 2.0 flow
([RFC 6749](http://tools.ietf.org/html/rfc6749#section-4.3)) as well as
Facebook authentication for API projects__.

It uses __Bearer tokens__ ([RFC 6750](http://tools.ietf.org/html/rfc6750)) to
authorize requests coming in from clients.

## Installation

To install the engine simply add

```ruby
gem 'rails_api_auth'
```

to the application's `Gemfile` and run `bundle install`.

__Rails API Auth also adds a migration__ to the application so run

```bash
rake db:migrate
```

as well to migrate the database.

## Usage

__Rails API Auth stores a user's credentials as well as the tokens in a `Login`
model__ so that this data remains separated from the application's `User` model
(or `Account` or whatever the application chose to store profile data in).

After installing the engine you can add the relation from your user model to
the `Login` model:

```ruby
class User < ActiveRecord::Base

  has_one :login # this could be has_many as well of course

end
```

When creating a new `User` in the host application, make sure to create a
related `Login` as well, e.g.:

```ruby
class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save && user.create_login(login_params)
      head 200
    else
      head 422 # you'd actually want to return validation errors here
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end

    def login_params
      params.require(:user).permit(:identification, :password, :password_confirmation)
    end

end
```

__The engine adds 2 routes to the application__ that implement the endpoints
for acquiring and revoking Bearer tokens:

```
token  POST /token(.:format)  oauth2#create
revoke POST /revoke(.:format) oauth2#destroy
```

These endpoints are fully implemented in the engine and will issue or revoke
Bearer tokens.

In order to authorize incoming requests the engine provides the
__`authenticate!` helper that can be used in controllers__ to make sure the
request includes a valid Bearer token in the `Authorization` header (e.g.
`Authorization: Bearer d5086ac8457b9db02a13`):

```ruby
class AuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  before_action :authenticate!

  def index
    render json: { success: true }
  end

end

```

If no valid Bearer token is provided the client will see a 401 response.

The engine also provides the `current_login` helper method that will return the
`Login` model authorized with the sent Bearer token.

You can also invoke `authenticate!` with a block to perform additional checks
on the current login, e.g. making sure the login's associated account has a
certain role:

```ruby
class AuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  before_action :authenticate_admin!

  def index
    render json: { success: true }
  end

  private

    def authenticate_admin!
      authenticate! do
        current_login.account.admin?
      end
    end

end

```

## Configuration

The Engine can be configured by simply setting some attributes on its main
module:

```ruby
RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account # this will set up the belongs_to relation from the Login model to the Account model automatically (of course if your application uses a User model this would be :user)

  raa.facebook_app_id       = '<your Facebook app id>'
  raa.facebook_app_secret   = '<your Facebook app secret>'
  raa.facebook_graph_url    = 'https://graph.facebook.com'
  raa.facebook_redirect_uri = '<your Facebook app redirect uri>'
end

```

## License

Rails API Auth is developed by and &copy;
[simplabs GmbH](http://simplabs.com) and contributors. It is released under the
[MIT License](https://github.com/simplabs/ember-simple-auth/blob/master/LICENSE).
