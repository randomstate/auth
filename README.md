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

Auth.define_user_class MyUserClass

# 2) List which strategies are supported. This sets up the auth manager class so that it can dynamically add and remove strategies by name. It *MUST* be called.

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

### Quick Start with Amber Framework

## Development

### Implementing Custom Strategies

## Contributing

1. Fork it ( https://github.com/[your-github-name]/auth/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Connor Imrie - creator, maintainer
