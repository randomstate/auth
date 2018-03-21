module Auth
  class Never < Strategy(Nil)
    def attempt(context : HTTP::Server::Context) : (Nil)
      nil
    end
  end
end
