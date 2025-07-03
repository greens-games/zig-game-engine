const std = @import("std");

const rl = @cImport({
    @cInclude("raylib.h");
});

pub fn init_glfw(width: u32, height: u32) void {
    _ = height; // autofix
    _ = width; // autofix
}

pub fn initRaylib(width: i32, height: i32) void {
    rl.InitWindow(width, height, "Green's Engine");
}

pub fn raylibCleanUp() void {
    defer rl.CloseWindow();
}
