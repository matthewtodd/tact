require 'ostruct'
require 'securerandom'

class FakeGoogleApi
 TASKLISTS_LIST = 'tasks.tasklists.list'
 TASKS_LIST     = 'tasks.tasks.list'
 TASKS_DELETE   = 'tasks.tasks.delete'

  def initialize
    @tasklists = {}
  end

  def setup(tasklists)
    tasklists.each do |title, items|
      @tasklists[random_id] = OpenStruct.new(
        :title => title,
        :items => items.map { |title|
          OpenStruct.new(
            :id => random_id,
            :title => title
          )
        }
      )
    end
  end

  def discovered_api(name)
    OpenStruct.new(
      :tasklists => OpenStruct.new(
        :list => TASKLISTS_LIST
      ),
      :tasks => OpenStruct.new(
        :list   => TASKS_LIST,
        :delete => TASKS_DELETE
      )
    )
  end

  def execute(request)
    api_method = request.fetch(:api_method)
    parameters = request.fetch(:parameters, {})

    data = case api_method
           when TASKLISTS_LIST
             tasklists
           when TASKS_LIST
             tasks parameters.fetch('tasklist')
           when TASKS_DELETE
             delete parameters.fetch('tasklist'), parameters.fetch('task')
           else
             raise "Unsupported api_method #{api_method}."
           end

    OpenStruct.new(:data => data)
  end

  private

  def random_id
    SecureRandom.hex(16)
  end

  def tasklists
    OpenStruct.new(
      :items => @tasklists.map { |id, tasklist|
        OpenStruct.new(
          :id    => id,
          :title => tasklist.title
        )
      }
    )
  end

  def tasks(tasklist_id)
    OpenStruct.new(
      :items => @tasklists.fetch(tasklist_id).items.map { |item|
        OpenStruct.new(
          :id    => item.id,
          :title => item.title
        )
      }
    )
  end

  def delete(tasklist_id, task_id)
    @tasklists.fetch(tasklist_id).items.delete_if { |item|
      item.id == task_id
    }

    OpenStruct.new
  end
end
