require "./spec_helper"

Auth.define_user_class User

always = Always.new(AlwaysUser.new)
never = Never.new

Auth.can_use Always, Never

manager = Auth::Manager.new({
  :always => always,
  :never  => never,
})

require "./helpers/*"
require "http"

include Auth

describe Auth do
  it "can register a strategy by name" do
    # manager = Auth::Manager(User).new
    # manager.use("always", strategy = Always.new)

    # manager.strategies.size.should eq 1
    # manager.strategies[0].should eq strategy
  end

  it "sets user on request context when successful" do
    user = User.new
    strategy = Always.new(AlwaysUser.new)
    strategy.when_converting do |always|
      user
    end

    req = HTTP::Request.new("GET", "/")
    resp = HTTP::Server::Response.new(IO::Memory.new)

    context = HTTP::Server::Context.new(req, resp)

    strategy_user = strategy.authenticate(context).should eq user
  end

  it "only allows one strategy per name" do
    # Strategy.register :always, Always.new
  end

  it "allows a model type to be supplied so that all guard -> domain conversions are type safe" do
  end
end
