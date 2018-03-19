require "./spec_helper"
require "./helpers/*"
require "http"

include Auth

never = Never.new

describe Auth do
  it "can register a strategy by name" do
    manager = Auth::Manager.new
    always = Always.new(AlwaysUser.new)
    manager.use :always, always

    manager.strategies.size.should eq 1
    manager.strategies[:always].should eq always
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
