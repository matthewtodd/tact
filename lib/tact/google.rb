module Tact
  class Google
    def initialize(client)
      @client = Client.new(client)
    end

    def inbox
      Tasklist.new(@client, 'Inbox')
    end

    class Tasklist
      include Enumerable

      def initialize(client, title)
        @client = client
        @title  = title
      end

      def clear
        tasks.each { |task| delete task }
      end

      def each
        tasks.each { |task| yield task.title }
      end

      private

      def tasklists
        @client.tasklists.data.items
      end

      def tasks
        @client.tasks(tasklist.id).data.items
      end

      def delete(task)
        @client.delete(tasklist.id, task.id)
      end

      def tasklist
        @tasklist ||= tasklists.find { |t| t.title == @title }
      end
    end

    private

    class Client
      def initialize(client)
        @client = client
      end

      def tasklists
        execute api.tasklists.list
      end

      def tasks(tasklist_id)
        execute api.tasks.list, 'tasklist' => tasklist_id
      end

      def delete(tasklist_id, task_id)
        execute api.tasks.delete, 'tasklist' => tasklist_id, 'task' => task_id
      end

      private

      def execute(api_method, parameters={})
        @client.execute :api_method => api_method, :parameters => parameters
      end

      def api
        @api ||= @client.discovered_api('tasks')
      end
    end
  end
end
