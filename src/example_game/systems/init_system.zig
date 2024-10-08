const std = @import("std");
const allocator = std.heap.page_allocator;
const World = @import("../../engine/core/world.zig").World;
const Characters = @import("../components/character.zig");
const Color = @import("raylib").Color;
const rl = @import("raylib");
const Vector2 = @import("../../engine/core/types.zig").Vector2;
const assert = @import("../../engine/error/assert.zig").assert;

//example game stuff
const Tile = @import("../components/tile.zig").Tile;
const TileType = @import("../components/tile.zig").TileType;
const GridUtils = @import("../grid/grid_utils.zig");
const Constants = @import("../utils/constants.zig");

pub fn spawnTeam(world: *World) void {
    const character: Characters.Character = .{
        .position = .{ .x = 0, .y = 0 },
        .hp = 10,
        .class_id = 0,
        //We can set the colour based on the class_id as well
        .color = rl.Color.blue,
    };
    world.spawn_character(character);
}

//TODO: Improve to spawn tiles from a file to create  a map also remove raylib stuff
pub fn spawnTiles() void {
    var r: i32 = 0;
    while (r < Constants.GRID_H) {
        var c: i32 = 0;
        World.tiles[@intCast(r)] = allocator.alloc(TileType, Constants.GRID_W) catch @panic("Failed to allocate memory for tiles");
        while (c < Constants.GRID_W) {
            //TODO: Move this elsewhere later
            World.tiles[@intCast(r)][@intCast(c)] = TileType.GROUD;
            c += 1;
        }
        r += 1;
    }
}

test "spawning tiles" {
    spawnTiles();
    try std.testing.expect(World.tiles[1][0] == .GROUD);
}
