//mod is our module source
//Anything we want a consumer to be able to use should be imported into main and marked pub

///Thoughts on how things looks
/// Entity:
///     id: u32
///     List_of_components: Some collection of *anyopaque
///
/// Component:
///     Any struct with data passed as a pointer to spawn an entity
///
/// System:
///     Struct:
///         Components it wants
///         Components it doesn't want
///         member functions:
///             execute <- this is what the engine will call
///             all other functions will do used in the execute function
pub const game = @import("core/game.zig");
pub const world = @import("core/world.zig");
pub const entity = @import("ecs/entity.zig");
