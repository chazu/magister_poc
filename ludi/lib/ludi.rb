#!/usr/bin/env ruby
module Ludi
require 'find'
require 'highline'
require 'rest-client'

  def transformer
    local_copy = ask("Relative path to transformer directory?")
    remote_context = ask("Destination path on server? Blank for root...")
    remote_name = ask("Name for remote copy of transformer?")

    # Remove terminating "/" from destination if present
    if remote_context[-1] == "/"
      remote_context[-1] = ""
    end

    
  end

  def self.start
    transformer
  end

end

Ludi.start
