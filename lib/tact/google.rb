module Tact
  class Google
    attr_reader :inbox

    def initialize(api)
      @inbox = List.new(api, api.discovered_api('tasks'), 'Inbox')
    end

    private

    class List
      include Enumerable

      def initialize(client, api, name)
        @client = client
        @api = api
        @name = name
      end

      def clear
        each_task do |task|
          delete_task task
        end
      end

      def each
        each_task do |task|
          yield task.title
        end
      end

      private

      def delete_task(task)
        execute @api.tasks.delete,
          'tasklist' => tasklist_id,
          'task'     => task.id
      end

      def each_task(&block)
        call(@api.tasks.list, 'tasklist' => tasklist_id).each(&block)
      end

      def tasklist_id
        @tasklist_id ||= begin
          tasklists = call(@api.tasklists.list)
          inbox = tasklists.detect { |list| list.title == @name }
          inbox.id
        end
      end

      def execute(api_method, parameters={})
        @client.execute(
          :api_method => api_method,
          :parameters => parameters
        )
      end

      def call(api_method, parameters={})
        execute(api_method, parameters).data.items
      end
    end
  end
end
