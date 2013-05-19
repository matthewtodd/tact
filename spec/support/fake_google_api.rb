require 'ostruct'
require 'securerandom'

class FakeGoogleApi
  def initialize
    @tasklists = {}
  end

  def setup(tasklists)
    tasklists.each do |title, items|
      @tasklists[random_id] = OpenStruct.new(
        :title => title,
        :items => items.map do |title|
          OpenStruct.new(
            :id => random_id,
            :title => title
          )
        end
      )
    end
  end

  def execute(request)
    api_method = request.fetch(:api_method)
    parameters = request.fetch(:parameters, {})

    data = case api_method
           when 'tasks.tasklists.list'
             tasklists
           when 'tasks.tasks.list'
             tasks parameters.fetch('tasklist')
           when 'tasks.tasks.delete'
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
    {
      'items' => @tasklists.map do |id, tasklist|
        {
          'id'    => id,
          'title' => tasklist.title
        }
      end
    }
  end

  def tasks(tasklist_id)
    tasklist = @tasklists.fetch(tasklist_id)

    {
      'items' => tasklist.items.map do |item|
        {
          'id'    => item.id,
          'title' => item.title
        }
      end
    }
  end

  def delete(tasklist_id, task_id)
    tasklist = @tasklists.fetch(tasklist_id)

    tasklist.items.delete_if { |item| item.id == task_id }

    {}
  end
end
