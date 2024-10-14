const std = @import("std");
const rl = @import("raylib");

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
