# Magister And You

Magister is a personal knowledgebase designed around the following core principles:

### Powerful Tools for Power Users

Magister is designed to give users a powerful set of tools for customizing the way they ingest, sort and consume data, with minimal restrictions. Care should be taken by those creating applications in Magister so that they are easily grasped by other users who may wish to customize or reuse them; however the Magister toolset was not designed to be usable by those unwilling or unable to learn the tools themselves.

See also: Programming languages are the most powerful user interfaces, some things should be designed to be difficult

### Composability

Magister's tools encourage reuse and modularity within the problem domain magister is intended to solve: retrieval, storage and presentation of data. Magister applications can be used to apply common types of processing to data, and can therefore be leveraged easily by other applications.

### Bootstrapped

Magister is designed to be as self-contained as possible. An attempt has been made to provide as much of the core Magister functionality using Magister itself, which brings us to...

### Simple Architecture & Convention Over Configuration

We've also attempted to keep Magister simple from a conceptual perspective, with as few primitives as possible and as little conceptual overhead as possible. By establishing conventions for the use of the Magister toolset, the simplicity of its design is leveraged.

Good conventions are those which:

* Are easy to understand
* Are not overly constrictive of the user
* Lead to modularity, reusability

## Terminology/Concepts

### Entities, Contexts and Transformers

Magister organizes all data in the form of a tree, much like a conventional filesystem. Every node in this tree is known as an ***entity***. Those entities which contain other entities (roughly analogous to directories in a filesystem) are called **contexts**. All of the data stored by one's own Magister installation is referred to as the **store**.

Interactions with Magister are carried out primarily via a RESTful HTTP API. This API consists of operations on Entity resources.

Extensibility and customization in Magister is achieved through the creation and configuration of ***transformers***. A transformer is an entity or set of entities which contain logic for processing API requests as well as any data required for operation. Transformers can do anything from serving a static website to visualizing geo-tagged data or displaying a collection of recipes.

### Entity Conventions

#### Index Keys

Each entity in the store is identified by an ***index key*** - this is a string describing the position of the entity in the store. Index keys are roughly analogous to file paths in a normal filesystem. For example, the index_key "/personal/recipes/savory_pies/stargazy_pie" might indicate the location of a file containing my recipe for [Stargazy Pie](https://en.wikipedia.org/wiki/Stargazy_pie). Or it might not, it's a secret.

Index keys always start with a slash ("/") and never end with a slash. By convention, entity names are written in snake_case.

#### Entity Names

Each entity has a name. In the above case of my Stargazy Pie recipe, the name of the entity is "stargazy_pie". The context which holds that entity also has a name: "savory_pies". Even the root context "/" has a name. Its name is "/".

Although generally speaking users will want to choose meaningful names for their entities, it is possible to choose random or otherwise non-human-readable names for entities. For example, an entity can be created with a name corresponding to the SHA-1 hash of its contents, or with a name corresponding to a UUID chosen at random at the time of its creation.

### Transformer Syntax and Operation

(insert stuff here about how transformers work).

See (another page) for more information about conventions for writing and configuring transformers.

 - Domain - When speaking about a transformer, the section of the store's tree which the transformer has access to. By default it is the context of the transformer and all nodes below it in the tree.
 - Environment - When speaking about a transformer, a variable injected into the transformer's operation which provides access to external resources including the data store, any file caches and other utilities of use.
 - Antecedent - When speaking about a transformer, the computational resources which can be leveraged by the transformer which reside higher up in the store's tree. Defaults to all contexts which precede the context of the transformer being executed. This is in contrast to the domain, which contains all data below the context of the transformer.

### The Scheduler

In order to facilitate automated activities such as the retrieval of data from the internet, Magister contains a special Entity - the scheduler - which regularly makes requests to other parts of the store. The job of the scheduler is basically to emit event triggers so that your RSS feeds are read regularly, or that your gmail inbox is synced with Magister.



## Configuring your installation

Create a file in your home directory called .magister.yml: 

    ---
    foo
    bar
    baz

