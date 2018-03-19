module Auth
  # Dummy user class to display conversion between 'AlwaysUser' and 'User'
  class AlwaysUser
  end

  class Always < Strategy(AlwaysUser)
    def initialize(@user : AlwaysUser)
    end

    def attempt(context : HTTP::Server::Context) : (AlwaysUser | Nil)
      @user
    end
  end
end
