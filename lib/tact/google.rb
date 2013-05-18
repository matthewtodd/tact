module Tact
  class Google
    attr_reader :inbox

    # I'll depend on an API client.
    #
    # Set client.authorization = YAML or flow.authorize
    #
    # Make the calls:
    # client.execute(api_method: '', parameters: {})
    #
    # The wiring should do almost all of this for me.
    # But configuration persistence is useful.
    # I'm inclined to defer it to the bin script for now.
    def initialize(api)
      @inbox = List.new(api, 'Inbox')
    end

    private

    class List
      include Enumerable

      def initialize(api, name)
        @api  = api
        @name = name
      end

      def clear
        each_task do |task|
          delete_task task
        end
      end

      def each
        each_task do |task|
          yield task.fetch('title')
        end
      end

      private


      def delete_task(task)
        execute 'tasks.tasks.delete',
          'tasklist' => tasklist_id,
          'task'     => task.fetch('id')
      end

      def each_task(&block)
        call('tasks.tasks.list', 'tasklist' => tasklist_id).each(&block)
      end

      def tasklist_id
        @tasklist_id ||= begin
          tasklists = call('tasks.tasklists.list')
          inbox = tasklists.detect { |list| list.fetch('title') == @name }
          inbox.fetch('id')
        end
      end

      def execute(api_method, parameters={})
        @api.execute(
          :api_method => api_method,
          :parameters => parameters
        )
      end

      def call(api_method, parameters={})
        execute(api_method, parameters).data.fetch('items')
      end
    end
  end
end
