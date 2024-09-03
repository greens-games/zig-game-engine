const std = @import("std");
const allocator = std.heap.page_allocator;
const World = @import("../../engine/core/world.zig").World;
const Characters = @import("../components/character.zig");
const Color = @import("raylib").Color;
const rl = @import("raylib");
const Vector2 = @import("../../engine/core/types.zig").Vector2;
const Constants = @import("../../engine/core/constants.zig");

//example game stuff
const Tile = @import("../components/tile.zig").Tile;
const TileType = @import("../components/tile.zig").TileType;
const GridUtils = @import("../grid/grid_utils.zig");

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

//TODO: Improve to spawn tiles from a file to create  a map also remove raylib stuff
pub fn spawnTiles(world: *World) void {
    var r: i32 = 0;
    while (r <= rl.getScreenHeight()) {
        var c: i32 = 0;
        while (c <= rl.getScreenWidth()) {
            const tile_rc = GridUtils.worldToGridCoords(c, r);
            const tile: Tile = .{ .row = tile_rc.y, .col = tile_rc.x, .tile_type = TileType.GROUD };
            world.tiles.append(tile) catch @panic("Failed to add type");
            c += Constants.CELL_W;
        }
        r += Constants.CELL_H;
    }
}

test "move units" {}
