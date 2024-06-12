const std = @import("std");

pub fn draw_triangle() !void {
    const vert_buff: []f32 = [_]f32{
        -0.5, -0.5, 0.0,
        0.5,  -0.5, 0.0,
        0.0,  0.5,  0.0,
    };

    _ = vert_buff;
}
