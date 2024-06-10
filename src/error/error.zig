const std = @import("std");

pub fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    _ = description;
    std.debug.print("Error: {}\n", .{err});
}
