const std = @import("std");

pub fn something() !void {
    std.debug.print("something\n", .{});
}
