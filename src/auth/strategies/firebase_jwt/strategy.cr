include Auth

module Auth::Strategies::Firebase
  class JWT(User) < Strategy(User)
    def attempt(context : HTTP::Server::Context) : (User | Nil)
    end
  end
end
