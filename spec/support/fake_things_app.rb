require 'ostruct'

class FakeThingsApp
  attr_reader :lists

  def initialize
    @lists = {
      'Inbox' => List.new
    }
  end

  private

  class List
    def initialize
      @items = []
    end

    def to_dos
      OpenStruct.new(
        :end => Maker.new(@items),
        :name => Getter.new(@items)
      )
    end
  end

  class Maker
    def initialize(items)
      @items = items
    end

    def make(args)
      @items << args.fetch(:with_properties).fetch(:name)
    end
  end

  class Getter
    def initialize(items)
      @items = items
    end

    def get
      @items
    end
  end
end
