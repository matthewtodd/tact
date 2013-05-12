module Tact
  class Application
    def initialize(google, things)
      @google = google
      @things = things
    end

    def run
      google = @google.inbox
      things = @things.inbox

      google.each do |task|
        things << task
      end

      google.clear
    end
  end
end
