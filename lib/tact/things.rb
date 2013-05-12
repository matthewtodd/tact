module Tact
  class Things
    attr_reader :inbox

    def initialize
      @inbox = List.new
    end

    private

    class List
      include Enumerable

      def initialize
        @contents = []
      end

      def <<(task)
        @contents << task
      end

      def each(&block)
        @contents.each(&block)
      end
    end
  end
end
