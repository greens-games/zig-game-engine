const std = @import("std");
const Constants = @import("../../engine/core/constants.zig");
const Vector2 = @import("../../engine/core/types.zig").Vector2;
pub fn gridToWorldCoords(col: i32, row: i32) Vector2 {
    const ret_vec: Vector2 = .{ .x = col * Constants.CELL_W, .y = row * Constants.CELL_H };
    return ret_vec;
}

pub fn worldToGridCoords(x: i32, y: i32) Vector2 {
    const ret_vec: Vector2 = .{ .x = @divFloor(x, Constants.CELL_W), .y = @divFloor(y, Constants.CELL_H) };
    return ret_vec;
}

test "Grid to world coords" {
    const vec1 = gridToWorldCoords(0, 0);
    const vec2 = gridToWorldCoords(2, 1);

    try std.testing.expect(vec1.x == 0);
    try std.testing.expect(vec1.y == 0);

    try std.testing.expect(vec2.y == 32);
    try std.testing.expect(vec2.x == 64);
}

test "World to grid coords" {
    const vec1 = worldToGridCoords(1, 1);
    const vec2 = worldToGridCoords(65, 32);

    try std.testing.expect(vec1.x == 0);
    try std.testing.expect(vec1.y == 0);

    try std.testing.expect(vec2.y == 1);
    try std.testing.expect(vec2.x == 2);
}
