const std = @import("std");
const Entity = @import("../ecs/entity.zig").Entity;

/// What does a world have?
///     entities
///     table for components to lookup
///     scene?
///
pub const World = struct {};
///Need to know:
/// What to spawn
/// Where to spawn
///
/// World.spawn(entity)
/// Takes in some entity, and an entity has n number of components attached
/// Adds this entity to the world and process any component data necessary for "spawning" like Position, texture, etc...
pub fn spawn(entity: Entity) void {
    _ = entity;
    return;
}
