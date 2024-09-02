const std = @import("std");
const allocator = std.heap.page_allocator;
const rl = @import("raylib");
const Vector2 = @import("../../engine/core/types.zig").Vector2;
pub const Character = struct {
    //Entity ID
    character_id: u32 = 0,
    //Character stats component
    hp: u32,
    class_id: u32,
    //Transform component
    position: Vector2,
    //SPrite component
    //TODO: Replace with img/animation etc...
    color: rl.Color,
};
