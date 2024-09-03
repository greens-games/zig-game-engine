const TileType = @import("../components/tile.zig").TileType;
pub const TileClickEvent = struct {
    row: i32,
    col: i32,
    tile_type: TileType,
};
