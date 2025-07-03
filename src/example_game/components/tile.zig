const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});
pub const Tile = struct {
    row: i32,
    col: i32,
    tile_type: TileType,
    sprite: rl.Color,
};

pub const TileType = enum {
    GROUD,
    PLAYERCHARACTER,
    ENEMY,
    RESOURCE,
};
