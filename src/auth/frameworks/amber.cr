require "amber"

module Auth::Pipe
  class Unauthorized < Amber::Exceptions::Base
    def initialize(message : String?)
      @status_code = 401
      super(message || "Unauthorized.")
    end
  end

  class Authenticate < Amber::Pipe::Base
    def initialize(@manager : Auth::Manager, @guard : Symbol)
    end

    def call(context)
      if @manager.authenticate(@guard, context).nil?
        raise Unauthorized.new
      end

      call_next(context)
    end
  end
end
