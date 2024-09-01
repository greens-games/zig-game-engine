const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const Sprites = @import("../ecs/components/sprite.zig");
const Characters = @import("../ecs/components/character.zig");
const Tile = @import("../ecs/components/tile.zig").Tile;
const Color = @import("raylib").Color;
const Vector2 = @import("types.zig").Vector2;
const Constants = @import("../core/constants.zig");

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

    pub fn gridToWorldCoords(self: World, col: i32, row: i32) Vector2 {
        _ = self;
        const ret_vec: Vector2 = .{ .x = col * Constants.CELL_W, .y = row * Constants.CELL_H };
        return ret_vec;
    }

    pub fn worldToGridCoords(self: World, x: i32, y: i32) Vector2 {
        _ = self;
        const ret_vec: Vector2 = .{ .x = @divFloor(x, Constants.CELL_W), .y = @divFloor(y, Constants.CELL_H) };
        return ret_vec;
    }

    pub fn cleanUp(self: *World) void {
        self.characters.deinit();
        self.sprites.deinit();
        self.tiles.deinit();
    }
};

test "Grid to world coords" {
    const world: World = .{};
    const vec1 = world.gridToWorldCoords(0, 0);
    const vec2 = world.gridToWorldCoords(2, 1);

    try std.testing.expect(vec1.x == 0);
    try std.testing.expect(vec1.y == 0);

    try std.testing.expect(vec2.y == 16);
    try std.testing.expect(vec2.x == 32);
}

test "World to grid coords" {
    const world: World = .{};
    const vec1 = world.worldToGridCoords(1, 1);
    const vec2 = world.worldToGridCoords(33, 16);

    try std.testing.expect(vec1.x == 0);
    try std.testing.expect(vec1.y == 0);

    try std.testing.expect(vec2.y == 1);
    try std.testing.expect(vec2.x == 2);
}
