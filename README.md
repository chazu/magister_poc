# TODO

* write highest_extant_context_for_key
* write contexts_to_create_for_request helper
* Recursively create contexts when persisting an entity
* Error out if asked to create a context with a name thats already taken by a file
* Establish interface for storage adapter
* Implement logical deletion

## TODO Less important

* What is metadata going to look like?

# DONE
* Write context_exists method on index (helper, actually)
* Move index functionality into index class
* Move Store and Index classes into their own damn files
* Create 'find' method for Entity, for use in get handler

# HTTP Calls

## multipart uploads

http --form POST localhost:9292/kill/la/kill/ryuuko _magister_file@ryuuko_template

## NOTES

### Index Key Spec

* Index keys always start with a slash
* Index keys for contexts don't have a terminal slash on non-POST requests, terminal slashes are removed before lookup occurs.

