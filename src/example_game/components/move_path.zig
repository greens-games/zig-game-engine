const std = @import("std");
const Arraylist = std.ArrayList;
const Vector2 = @import("../../engine/core/types.zig").Vector2;
pub const MovePath = struct {
    move_index: usize = 0,
    path: Arraylist(Vector2) = Arraylist(Vector2).init(std.heap.page_allocator),
};
