# auth

A framework-agnostic strategy-based approach to authentication.

Features:
- Common strategies to rapidly implement common authentication workflows (WIP)
- Easy-to-provide conversion between strategy users (such as a Firebase User) and your app user model
- Default session storage and (ability for) retrieval
- Create custom strategies with no required knowledge of app use-case

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  auth:
    github: randomstate/auth
```

## Usage

```crystal
require "auth"
require "auth_firebase_jwt" # or your favourite strategy implementation for this shard

## Define required context for your app

# 1) Enable type-safe support for your User class. This generates the appropriate strategy base classes to support your model. It *MUST* be called.
# 2) List which strategies are supported. This sets up the auth manager class so that it can dynamically add and remove strategies by name. It *MUST* be called.
Auth.define_user_class MyUserClass
Auth.can_use Auth::Strategies::Firebase::JWT # , MyOtherStrategy, YetAnotherStrategyClass

## Create an Auth::Manager instance
manager = Auth::Manager.new

## Register your strategies with the manager
firebase_jwt = Auth::Strategies::Firebase::JWT.new "project-1328"
manager.use :jwt, firebase_jwt

# Define how the strategy should convert the Firebase User to your own version
firebase_jwt.when_converting do | firebase_user |
  user = MyUser.new # most likely you will fetch/upsert it from/in the database 

  user.email = firebase_user.email #etc
  user # return your user instance
end


## Elsewhere in your app (most likely in a middleware)
user = manager.authenticate(:jwt, context) # context : HTTP::Server::Context

if user.nil?
  # not authenticated
else 
  # authenticated `MyUser` object
end
```

This pipe will now guard any routes in the pipeline. It will raise an `Auth::Pipe::Unauthorized` exception if the user failed to authenticate. By default this will return a response with "Unauthorized." and a status code of 401.

Inside your controller, you can now access the authenticated user like so:
```crystal
class MyController < ApplicationController

  def index
    authenticated_user = @context.user # typeof(authenticated_user) == (MyUser | Nil)
  end

end
```

### Quick Start with Amber Framework

Follow the instructions (detailed above):
- Call `Auth.define_user_class`
- Call `Auth.can_use` with your strategies as parameters
- Create an `Auth::Manager` instance
- Register your strategies with the manager
- Define how your strategy should convert to your custom user model

Then add this to your `config/routes.cr` file in the pipes section for the relevant route:
```crystal
Auth::Pipe::Authenticate.new(manager, :strategy_name) # strategy_name is the symbol referencing your strategy, as defined when you registered your strategies with the manager
```

## Development

### Implementing Custom Strategies

[[ TODO ]]

## Contributing

1. Fork it ( https://github.com/randomstate/auth/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [cimrie](https://github.com/cimrie) Connor Imrie - creator, maintainer
