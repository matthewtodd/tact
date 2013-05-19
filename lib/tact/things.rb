module Tact
  class Things
    def initialize(app)
      @app = app
    end

    def inbox
      List.new(@app, 'Inbox')
    end

    class List
      include Enumerable

      def initialize(app, name)
        @app  = app
        @name = name
      end

      def <<(task)
        list.to_dos.end.make(
          :new => :to_do,
          :with_properties => {
            :name => task
          }
        )
      end

      def each
        list.to_dos.name.get.each { |name| yield name }
      end

      private

      def list
        @list ||= @app.lists[@name]
      end
    end
  end
end
