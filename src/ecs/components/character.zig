const std = @import("std");
const allocator = std.heap.page_allocator;
const rl = @import("raylib");
pub const Character = struct {
    //Entity ID
    character_id: u32 = 0,
    hp: u32,
    class_id: u32,
    //Could be other components
    x: i32,
    y: i32,
    //TODO: Replace with img/animation etc...
    color: rl.Color,
};
