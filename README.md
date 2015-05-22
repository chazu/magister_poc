Magister is a personal knowledgebase/data store focused on extensibility
and minimally complicated conceptual design. For detailed info on the
design see MANUAL.md

# HTTP Calls
## multipart uploads

http --form POST localhost:9292/kill/la/kill/ryuuko _magister_file@ryuuko_template

## NOTES
### Index Key Spec

* Index keys always start with a slash
* Index keys for contexts don't have a terminal slash on non-POST requests, terminal slashes are removed before lookup occurs.

