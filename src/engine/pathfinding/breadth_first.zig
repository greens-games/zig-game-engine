const std = @import("std");
const Vector2 = @import("../core/types.zig").Vector2;

pub fn search(start_pos: Vector2, end_pos: Vector2) std.ArrayList(Vector2) {
    const moves: std.ArrayList(Vector2) = std.ArrayList(Vector2).init(std.heap.page_allocator);
    //and start_pos.y != start_pos.y
    while (!start_pos.eql(end_pos)) {
        break;
    }

    return moves;
}

test "Test breadth first search" {
    const start: Vector2 = .{ .y = 1, .x = 1 };
    const end: Vector2 = .{ .y = 10, .x = 10 };

    _ = search(start, end);
}
