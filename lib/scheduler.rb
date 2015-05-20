require 'singleton'
require 'rest-client'

module Magister

  class Scheduler
    include Singleton
    include Helpers

    def initialize
      puts "Loading scheduler contents"
      scheduler_entity = Entity.find("/_scheduler")

      if scheduler_entity
        scheduler_contents = scheduler_entity.contents
      else
        Entity.new({context: [],
                    name: "_scheduler",
                    is_context: true}, nil).persist_recursively
      end

      @scheduler = Rufus::Scheduler.new

      if scheduler_contents
        scheduler_contents.each do |index_key|
          ent = Entity.find(index_key)
          parsed = parse_schedule_item(ent.data)
          
          puts "Processing scheduler item: " + parsed.to_s

          # Set up the repeating jobs
          @scheduler.every map_schedule_item_frequency(parsed) do
            index_key = ent.index_key
            puts "Running schedule item " + index_key
            RestClient.send(parsed["method"].downcase.to_sym,
                            "#{Config.options["host"]}:#{Config.options["port"]}#{parsed["index_key"]}",
                            {})            
          end
        end
      end

      @scheduler.every '30s' do
        Magister.sync_index_to_store
      end
    end

    #################
    # Helpers
    #################
    
    # map a schedule entry to a string which can be fed into the scheduler instance
    def map_schedule_item_frequency parsed_item
      parsed_item["number"].to_s + map_schedule_item_unit(parsed_item["unit"])
    end
    
    def map_schedule_item_unit unit_string
      case unit_string.downcase
      when 'seconds'
        's'
      when 'minutes'
        'm'
      when 'hours'
        'h'
      when 'days'
        'd'
      else
        'h' # Default to hours
      end
    end

    def parse_schedule_item entity_data
      parse_schedule_item_from_json entity_data
    end

    def parse_schedule_item_from_json entity_data
      x = JSON.parse(entity_data)
      {"unit" => x[0], "number" => x[1], "method" => x[2], "index_key" => x[3]}
    end

    def parse_schedule_item_from_sexp entity_data
      # TODO
    end
  end
end
