const std = @import("std");
pub fn assert(cond: bool, msg: []const u8) void {
    if (!cond) @panic(msg);
}
