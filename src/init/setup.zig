const std = @import("std");

const rl = @import("raylib");

pub fn init_glfw(width: u32, height: u32) void {
    _ = height; // autofix
    _ = width; // autofix
}

pub fn initRaylib(width: i32, height: i32) void {
    rl.initWindow(width, height, "Green's Engine");
}

pub fn raylibCleanUp() void {
    defer rl.closeWindow();
}
