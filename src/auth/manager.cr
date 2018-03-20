module Auth
  macro can_use(*strategies)
    module Auth
      class Manager
        property strategies = Hash(Symbol, Union({% for strategy, index in strategies %}{{ strategy }}{% if index != ((strategies.size) - 1) %}|{% end %}{% end %})).new

        def initialize(strategies = nil)
          if strategies.nil?
            return
          end

          strategies.each do | name, strategy |
            @strategies[name] = strategy
          end
        end

        def use(name : Symbol, strategy)
          strategies[name] = strategy
        end
      end
    end
  end

  class Manager
    def authenticate(name, context)
      user = @strategies[name].authenticate(context)
      login(user, context)
    end

    def login(user, context)
      context.user = user
      user
    end

    def logout(context)
      context.user = nil
    end
  end
end
