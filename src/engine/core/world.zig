const std = @import("std");
const ArrayList = std.ArrayList;
const MultiArrayList = std.MultiArrayList;
const allocator = std.heap.page_allocator;
const Sprites = @import("../../example_game/components/sprite.zig");
const Characters = @import("../../example_game/components/character.zig");
const Tile = @import("../../example_game/components/tile.zig").Tile;
const TileType = @import("../../example_game/components/tile.zig").TileType;
const TileClickEvent = @import("../../example_game/components/tile_events.zig").TileClickEvent;
const Color = @import("raylib").Color;
const Vector2 = @import("types.zig").Vector2;
const Constants = @import("../core/constants.zig");

/// Kepps track of the current world state
pub const World = struct {
    sprites: ArrayList(Sprites.GeometricSprite) = ArrayList(Sprites.GeometricSprite).init(allocator),
    characters: ArrayList(Characters.Character) = ArrayList(Characters.Character).init(allocator),
    characters_multi: MultiArrayList(Characters.Character) = .{},
    al_tiles: ArrayList(Tile) = ArrayList(Tile).init(allocator),

    //Static Vars: Are they good or are they bad who knows? Answer: Smarter people than me
    pub var tiles: [100][]TileType = undefined;

    pub fn spawn_character(self: *World, character: Characters.Character) void {

        //std.debug.print("Spawning character with colour: {?}\n", .{character.color});
        self.characters.append(character) catch @panic("Failed to add character");
        self.characters_multi.append(allocator, character) catch @panic("Failed to add to multi chars");
    }

    pub fn cleanUp(self: *World) void {
        self.characters.deinit();
        self.sprites.deinit();
        for (tiles[0..]) |tile_slice| {
            allocator.free(tile_slice);
        }
        std.debug.print("DONE CLEANING UP THE WORLD!!!", .{});
    }
};

test "test Tiles" {
    World.tiles[0] = try std.testing.allocator.alloc(TileType, 1);
    World.tiles[0].ptr[0] = TileType.GROUD;
    defer std.testing.allocator.free(World.tiles[0]);

    try std.testing.expect(World.tiles[0][0] == .GROUD);
}
