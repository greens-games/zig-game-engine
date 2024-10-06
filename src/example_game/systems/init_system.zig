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
    //while (r <= rl.getScreenHeight()) {
    while (r <= 480) {
        var c: i32 = 0;
        //while (c <= rl.getScreenWidth()) {
        while (c <= 640) {
            const tile_rc = GridUtils.worldToGridCoords(c, r);
            //TODO: Move this elsewhere later
            world.tiles[@intCast(tile_rc.y)] = allocator.alloc(TileType, 10) catch @panic("Failed to allocate memory for tiles");
            world.tiles[@intCast(tile_rc.y)][@intCast(tile_rc.x)] = TileType.GROUD;
            c += Constants.CELL_W;
        }
        r += Constants.CELL_H;
    }
}

test "spawning tiles" {
    var world: World = .{};
    var r: usize = 0;
    var c: usize = 0;
    spawnTiles(&world);
    for (world.tiles[0..]) |row| {
        for (row[0..]) |tile| {
            std.debug.print("POS: ({?}, {?})\n", .{ c, r });
            std.debug.print("TILE: {?}\n", .{tile});
            c += 1;
        }
        r += 1;
    }
}
