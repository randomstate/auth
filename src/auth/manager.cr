module Auth
  macro can_use(*strategies)
    module Auth
      class Manager
        property strategies = Hash(Symbol, Union({% for strategy, index in strategies %}{{ strategy }}{% if index != ((strategies.size) - 1) %}|{% end %}{% end %})).new

        def initialize(@strategies)
        end
      end
    end
  end
end
