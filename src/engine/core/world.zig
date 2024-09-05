const std = @import("std");
const ArrayList = std.ArrayList;
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
    al_tiles: ArrayList(Tile) = ArrayList(Tile).init(allocator),
    tiles: [100][100]TileType = undefined,

    pub fn spawn_character(self: *World, character: Characters.Character) void {

        //std.debug.print("Spawning character with colour: {?}\n", .{character.color});
        self.characters.append(character) catch @panic("Failed to add character");
        std.debug.print("Spawning character with colour after adding: {?}\n", .{self.characters.items[0].color});
    }

    pub fn cleanUp(self: *World) void {
        self.characters.deinit();
        self.sprites.deinit();
        self.tiles.deinit();
    }
};

test "test Tiles" {
    var world: World = .{};

    world.tiles[0][0] = TileType.GROUD;

    try std.testing.expect(world.tiles[0][0].tile_type == .GROUD);
}
