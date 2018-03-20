module Auth
  abstract class Strategy(T)
  end

  macro define_user_class(user_class)
    module Auth
      abstract class Strategy(T)
        getter to_user_converter : Proc(T, {{ user_class }}) | Nil

        def when_converting(&block : T -> {{ user_class }}) : self
          @to_user_converter = block
          self
        end

        abstract def attempt(context : HTTP::Server::Context) : (T | Nil)
        def authenticate(context : HTTP::Server::Context) : {{ user_class }} | Nil
          result = attempt context
          converter = @to_user_converter

          raise "Converter is nil. You must provide a proc to convert #{T} to #{{{user_class}}} to use the strategy #{self.class}. E.g.
          `strategy.when_converting do | strategy_user |
            # typeof(strategy_user) == #{T}
            return {{ user_class }}.new
          end
          `" unless !converter.nil?

          converter.call(result) unless result.nil?
        end
      end
    end

    class HTTP::Server
      class Context
        property user : ({{ user_class }} | Nil)
      end
    end
  end
end
