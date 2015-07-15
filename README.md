# RailsApiAuth

Rails API Auth is a Rails Engine that __implements the _"Resource Owner
Password Credentials Grant"_ OAuth 2.0 flow
([RFC 6749](http://tools.ietf.org/html/rfc6749#section-4.3)) as well as
Facebook authentication for API projects__.

It uses __Bearer tokens__ ([RFC 6750](http://tools.ietf.org/html/rfc6750)) to
authorize requests coming in from clients.

## Installation

To install the engine simply add

```ruby
gem 'rails_auth_api'
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

__The engine adds 2 routes to the application__ that implement the endpoints
for acquiring and revoking Bearer tokens:

```
token  POST /token(.:format)         oauth2#create
revoke POST /revoke(.:format)        oauth2#destroy
```

These endpoints are fully implemented in the engine and will issue or revoke
Bearer tokens.

In order to authorize incoming requests the engine provides the
__`authenticate!` helper that can be used in controllers__ to make sure the
request includes a valid Bearer token in the `Authorization` header:

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

## License

Rails API Auth is developed by and &copy;
[simplabs GmbH](http://simplabs.com) and contributors. It is released under the
[MIT License](https://github.com/simplabs/ember-simple-auth/blob/master/LICENSE).
