# TODO
* Move index functionality into index class
* Write context_exists method on index
* write highest_extant_context_for_key
* write contexts_to_create_for_request helper
* Recursively create contexts when persisting an entity
* Error out if asked to create a context with a name thats already taken by a file
* Establish interface for storage adapter
* Implement logical deletion

## TODO Less important

* What is metadata going to look like?

# DONE
* Move Store and Index classes into their own damn files
* Create 'find' method for Entity, for use in get handler

# HTTP Calls

## multipart uploads

http --form POST localhost:9292/kill/la/kill/ryuuko _magister_file@ryuuko_template
