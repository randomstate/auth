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
    property use_sessions = true

    def authenticate(name, context)
      user = @strategies[name].authenticate(context)
      login(user, context) unless user.nil?
    end

    def login(user, context)
      context.user = user

      if @use_sessions
        set_session_for_user(user, context)
      end

      user
    end

    def logout(context)
      context.user = nil
    end

    private def set_session_for_user(user, context)
      proc = @serialize
      if !proc.nil?
        context.response.cookies["auth"] = proc.call(user)
      else
        raise SerializationError.new "`when_serializing` block must supply a Proc(#{typeof(user)}, String). It must be set on Auth::Manager if using user sessions."
      end
    end

    def get_user_from_session(context)
      proc = @deserialize
      if !proc.nil?
        value = context.request.cookies["auth"].value
        proc.call(value)
      else
        raise DeserializationError.new "`when_deserializing` must supply a Proc to convert a serialized representation to your user class. It must be set on Auth::Manager if using user sessions."
      end
    end
  end
end
