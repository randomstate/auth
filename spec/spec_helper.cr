require "spec"
require "../src/auth"

Auth.define_user_class User
Auth.can_use Always, Never
