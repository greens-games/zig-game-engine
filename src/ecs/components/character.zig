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

    //Allocate a ptr on the heap rather than stack (Any entity/Component in the scene needs to heap allocated)
    pub fn init(class_id: u32, x: i32, y: i32, hp: u32) *Character {
        const char_ptr: *Character = allocator.create(Character) catch @panic("Failed to allocate character");

        char_ptr.* = .{
            .class_id = class_id,
            .x = x,
            .y = y,
            .hp = hp,
            //We can set the colour based on the class_id as well
            .color = rl.Color.blue,
        };

        return char_ptr;
    }
};
