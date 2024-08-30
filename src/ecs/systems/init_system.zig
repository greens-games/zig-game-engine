const std = @import("std");
const allocator = std.heap.page_allocator;
const World = @import("../../core/world.zig").World;
const Characters = @import("../components/character.zig");
const Color = @import("raylib").Color;
const rl = @import("raylib");

pub fn spawn_team(world: *World) void {
    //std.debug.print("Spawning character at x: {?}, y: {?}\n", .{ first_member.x, first_member.y });
    const character: *Characters.Character = Characters.Character.init(0, 0, 0, 10);
    world.spawn_character(character);

    const character2: *Characters.Character = Characters.Character.init(0, 32, 32, 10);
    world.spawn_character(character2);
}

pub fn draw_team(world: *World) void {
    for (world.characters.items) |character| {
        rl.drawRectangle(character.x, character.y, 16, 16, character.color);
    }
}

test "move units" {}
