### Current TODO
- Change Entities (i.e Character) into MultiArrayList and treat each prop as a "component"
    + We would have a struct like
- Move player to target each frame

### Main features
- Hot reloading
    + strip out game logic to a DLL perhaps keep it separate from the exe
    + you can then reload the DLL every frame or when you push a key
    + Can then compile everything into a single exe when not developing
- ECS
- Track world state

