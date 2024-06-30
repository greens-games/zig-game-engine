const std = @import("std");
const glfw = @import("mach-glfw");

/// Default GLFW error handling callback
pub fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void {
    std.log.err("glfw: {}: {s}\n", .{ error_code, description });
}

pub fn something() !void {
    std.debug.print("something\n", .{});
}
