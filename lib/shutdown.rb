def at_exit
  puts "Flushing index to disk..."
  Magister::Config.index.flush
  puts "Synchronizing index to store..."
  Magister::Config.index.sync_index_to_store
  puts "Shutting down."
end
