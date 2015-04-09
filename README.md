NOTE: Moving over to TODO.org for todos

# TODO
* Write mixin (?) or utils for converting ruby objects into scheme datatypes and vice versa (hint: use alists)
* Set up noob-friendly aliases for using a-lists.
* Extract app into module in lib
* Spec and Implement Transformer Register init
* Spec and Implement logical deletion (DELETE verb handler)
* Spec and Implement PATCH, PUT, OPTIONS, HEAD?
* Spec and Implement GET context contents
* Create scheduler entity
* Refactor, testing backfill
* How do we get the contents of a context?


## TODO Less important
* Can you get _index entity? What about _config entity?
* PUT and PATCH, HEAD and OPTIONS
* Error out if asked to create a context with a name thats already taken by a file
* What is metadata going to look like?
* Flush and sync index on shutdown - Grape I guess...

# DONE
* Implement passthrough transformer
* Set up transformer registry
* Create pseudo-endpoint to see transformer registry
* Handle errors during transformer register initialization
* Extract each verb handler into its own file
* Make sure data is persisted when entity is persisted
* Make sure data is retrieved via Entity::find
* Set up test env and harness for specs - clean DB between runs/specs
* Load config from file - multiple envs
* Create super-basic Entity#contents
* Write thor task to upload transformers
* Set up basic transformer class with Heist
* Establish interface for storage adapter
* write contexts_to_create_for_request helper
* Recursively create contexts when persisting an entity
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

