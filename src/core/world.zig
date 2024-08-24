const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const Sprites = @import("../ecs/components/sprite.zig");
const Characters = @import("../ecs/components/character.zig");

/// Kepps track of the current world state
pub const World = struct {
    sprites: ArrayList(*Sprites.GeometricSprite) = ArrayList(*Sprites.GeometricSprite).init(allocator),
    characters: ArrayList(*Characters.Character) = ArrayList(*Characters.Character).init(allocator),

    pub fn spawn_character(self: *World, character: Characters.Character) u32 {
        self.characters.append(character) catch @panic("Failed to add character");
        return self.characters.items.len - 1;
    }
};
