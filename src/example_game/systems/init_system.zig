const std = @import("std");
const allocator = std.heap.page_allocator;
const World = @import("../../engine/core/world.zig").World;
const Characters = @import("../components/character.zig");
const Color = @import("raylib").Color;
const rl = @import("raylib");
const Vector2 = @import("../../engine/core/types.zig").Vector2;

pub fn spawnTeam(world: *World) void {
    //std.debug.print("Spawning character at x: {?}, y: {?}\n", .{ first_member.x, first_member.y });
    const character: Characters.Character = .{
        .position = .{ .x = 0, .y = 0 },
        .hp = 10,
        .class_id = 0,
        //We can set the colour based on the class_id as well
        .color = rl.Color.blue,
    };
    //const character: *Characters.Character = Characters.Character.init(0, 0, 0, 10);
    world.spawn_character(character);
}

test "move units" {}
