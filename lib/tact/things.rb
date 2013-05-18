module Tact
  class Things
    attr_reader :inbox

    def initialize(app)
      @inbox = List.new(app, 'Inbox')
    end

    private

    class List
      include Enumerable

      def initialize(app, name)
        @list = app.lists[name]
      end

      def <<(task)
        @list.to_dos.end.make(
          :new => :to_do,
          :with_properties => {
            :name => task
          }
        )
      end

      def each(&block)
        @list.to_dos.name.get.each(&block)
      end
    end
  end
end
