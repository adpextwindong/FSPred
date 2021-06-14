# FSPred

![FSPred](res/fspred.png)

Experimental library for representing file system patterns because I hate writing this stuff manually.

For now its geared towards top down exploration of a file system hiearchy (ideally zip files too in the future) in a scripting setting. Once I nail down the design more I'll be figuring out representing actions.

## TODO

- Interpretter for checking predicates against the file system.
- Name binding/capture
- Parser for a yaml file or something.
- Maybe converting FSPattern to a GADT or figuring out a way to annotate for Levinstein distance of fpaths
- Some kind of representation for transformations
