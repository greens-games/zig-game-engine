const std = @import("std");

pub const Tile = struct {
    row: i32,
    col: i32,
    tile_type: TileType,
};

pub const TileType = enum {
    GROUD,
    PLAYERCHARACTER,
    ENEMY,
    RESOURCE,
};
