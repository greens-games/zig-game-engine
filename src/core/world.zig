const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const Sprites = @import("../ecs/components/sprite.zig");
const Characters = @import("../ecs/components/character.zig");
const Color = @import("raylib").Color;

/// Kepps track of the current world state
pub const World = struct {
    sprites: ArrayList(*Sprites.GeometricSprite) = ArrayList(*Sprites.GeometricSprite).init(allocator),
    characters: ArrayList(*Characters.Character) = ArrayList(*Characters.Character).init(allocator),

    pub fn spawn_character(self: *World, character: *Characters.Character) void {

        //std.debug.print("Spawning character with colour: {?}\n", .{character.color});
        self.characters.append(character) catch @panic("Failed to add character");
        std.debug.print("Spawning character with colour after adding: {?}\n", .{self.characters.items[0].color});
    }
};
