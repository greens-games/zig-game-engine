const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const Sprites = @import("../ecs/components/sprite.zig");
const Characters = @import("../ecs/components/character.zig");
const Tile = @import("../ecs/components/tile.zig").Tile;
const Color = @import("raylib").Color;
const Vector2 = @import("types.zig").Vector2;

/// Kepps track of the current world state
pub const World = struct {
    sprites: ArrayList(Sprites.GeometricSprite) = ArrayList(Sprites.GeometricSprite).init(allocator),
    characters: ArrayList(Characters.Character) = ArrayList(Characters.Character).init(allocator),
    tiles: ArrayList(Tile) = ArrayList(Tile).init(allocator),

    pub fn spawn_character(self: *World, character: Characters.Character) void {

        //std.debug.print("Spawning character with colour: {?}\n", .{character.color});
        self.characters.append(character) catch @panic("Failed to add character");
        std.debug.print("Spawning character with colour after adding: {?}\n", .{self.characters.items[0].color});
    }

    //pub fn gridToWorldCoords(row: i32, col: i32) Vector2 {}

    pub fn cleanUp(self: *World) void {
        self.characters.deinit();
        self.sprites.deinit();
        self.tiles.deinit();
    }
};
