#!/usr/bin/env ruby

require 'find'
require 'pry'
require 'thor'
require 'rest_client'



class Mag < Thor

  desc "fuck thor", "fuck you"
  def serverUrl
    "http://localhost:9292/"
  end

  desc "fuck thor", "fuck u 2"
  def make_context(index_key)
    RestClient.post(serverUrl + index_key, "magister-is-context" => true)
  end

  desc "fuck thor", "fuck u 3"
  def upload_file(index_key, file_path)
    RestClient.post(serverUrl + index_key, "_magister_file" => File.new(file_path, "r"))
  end


  @host = 'localhost'
  @port = 9292

  desc "say_hi", "Say hello"
  def say_hi
    puts "Hello there :3"
  end

  desc "transformer", "Upload a transformer to the root transformer folder"
  def transformer(path, name)
    destination_index_path = "/_/transformers"
    puts "Uploading transformer " + path + "as " + name
    res = []
    Find.find(path) do |this_path|
      truncated_path = this_path.gsub(path, "") 
      that_path = destination_index_path + "/" + name
      final_destination_index_key = that_path + (truncated_path.length ? "/" + truncated_path : "")
      puts this_path + " => " + final_destination_index_key
      res << {index_key: final_destination_index_key, path: this_path}
    end
    # Iterate over res and push the files/contexts to the store
    res.each do |file_hash|

      stat = File.stat file_hash[:path]
      begin
        if stat.ftype == "directory"
          make_context(file_hash[:index_key])
        else
          data = File.read(file_hash[:path])
          upload_file(file_hash[:index_key],data)
        end
      rescue Exception => e
        puts e
      end
    end
  end
end
