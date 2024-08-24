### Systems:
- Game holds a collection of systems
- These systems should be known at game compile-time (not engine compile time)
    + this means we could have the engine be a submodule that gets added to something rahter than being a separate module and still be able to utilize comptime
- What could these SYstems be:
    + They could be a struct
        - would have N props for each component and stuff
        - would have an update function that is called each frame
        - (MAYBE) would have an init function that's called when the struct is created to create any resources or pointers it needs
    + They could be a function
        - would be a single function with N number of paramters to be called every frame
        - This would be more difficult to implement than the struct variant
        - might be more memory efficient
