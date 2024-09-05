### Current TODO
- Move player to target each frame
- implement A*
- Change the tiles list in World to multi D array/slice?
    + This would allow for easier indexing when grabbing a single tile, and make A* better
    + Either way we need an easy way to index into our tiles

### Main features
- Hot reloading
    + strip out game logic to a DLL perhaps keep it separate from the exe
    + you can then reload the DLL every frame or when you push a key
    + Can then compile everything into a single exe when not developing
- ECS
- Track world state

