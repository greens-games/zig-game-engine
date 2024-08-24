Zig version - 0.13.0-dev.351+64ef45eb0

ZLS commit - 7473b5492e0ec79d6ace48415ec8dc6cd657ac76

### IDEA
- Build a game + game engine
- engine doesn't need to be fully general purpose just needs the features as needed for the game
- Engine should be modular so we can choose what we want
- Implement some version of ECS

### NOTES
- Use Raylib for renderer + input to start
- avoid some abstraction and generic is good but avoid overuse

### Must haves
- hassel free networking
- hot reloading
- smooth ai implementation

### Development approach
- Build a game in a data oriented way (Design philosophy of ECS)
- Build parts of the engine as needed
- Stop worrying about implementations and what others are doing
- Focus on solving problems
- I can't solve problems I don't know exist yet
- I can't determine exact implementation until I have something to solve
- What other people have done is good to look at when you get really stuck
- Implement first Abstract later
