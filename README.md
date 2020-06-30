![alt text](https://github.com/fossegutten/FuzzyStoryEditor/blob/master/icon.png "Icon")

# Fuzzy Story Editor

## Free standalone event / dialog editor using visual scripting

### Current Version : Beta 1

Made in godot engine 3.2.2. Just open the project in Godot Engine and press F5 to run it. 
I might compile and release on github and/or itch.io after beta stage. I might also change the naming of stuff in the future, this is just an early version.

Create stories for your game, with branched dialogs, random branching, checkpoints and more.
Native support for Godot Engine, by using the resource files directly. JSON exporting adds support for other game engines.

Feel free to open issues with bug reports and feature requests. I would like to keep the different node types to a minimum, to keep the codebase smaller.
The idea is that your story / dialog player should contain the logic, and story files only contain the data.

![alt text](https://github.com/fossegutten/FuzzyStoryEditor/blob/master/screenshot.PNG "Screenshot")

### Features and TODO:
- [x] Save / load from custom godot engine resource files.
- [x] Export to JSON.
- [x] Custom nodes: Branched dialog, random branch, checkpoint, jump
- [ ] (WIP) Condition / expression nodes that can branch based on true/false return value
- [ ] (WIP) Example story player and story resource. Can be used for testing stories.
- [ ] Node copying.
- [ ] Save phrases and node templates.

### Credits / Inspirations

- https://github.com/EXPWorlds - Dave the Dev has released a great Godot Engine addon to create stories, with youtube tutorials. Check it out, his project is more mature than mine, and probably a better choice for most people. He inspired me with some of the features.
