![alt text](https://github.com/fossegutten/FuzzyStoryEditor/blob/master/icon.png "Icon")

# Fuzzy Story Editor

## Free standalone event / dialog editor using visual scripting

### Current Version : Beta 2

Create stories for your game, with connecting nodes together in the visual editor. Node type examples: branched dialogs, random branching, checkpoints and more.

The nodes can have only one output from each slot/branch. There is only one input slot to every node, which can have many inputs. 
The idea behind the application is to create a story in a visual editor, then saving the data to a resource or JSON file. You can then use the data file inside your game, but you need to code the logic to read the data yourself. There is an example story player which I am mostly using for testing, but this might be removed later.
Native support for Godot Engine, by using the resource files directly. JSON exporting adds support for other game engines.

Made in godot engine 3.2.2. Just open the project in Godot Engine and press F5 to run it. 
I might compile and release on github and/or itch.io after beta stage. I might also change the naming of stuff in the future, this is just an early version.
Feel free to open issues with bug reports and feature requests. However, I would like to keep the different node types to a minimum, to keep the codebase smaller. Node types are still a work in progress.

![alt text](https://github.com/fossegutten/FuzzyStoryEditor/blob/master/screenshot.PNG "Screenshot")

### Features and TODO:
- [x] Save / load from custom godot engine resource files.
- [x] Export to JSON.
- [x] Custom nodes: Branched dialog, random branch, checkpoint, jump, function calling.
- [ ] (WIP) Condition / expression nodes that can branch based on true/false return value
- [x] Node duplication.
- [x] Save/load node templates to/from config.
- [ ] Save/load phrases/text to/from config.
- [ ] (WIP) Example story player and story resource. This is mostly used by me, for testing stories.

### Credits / Inspirations

- https://github.com/EXPWorlds - Dave the Dev has released a great Godot Engine addon to create stories, with youtube tutorials. Check it out, his project is more mature than mine, and probably a better choice for most people. He inspired me with some of the features.
