const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("ziggl");
const shader_loader = @import("../shaders/shader_loader.zig");

pub fn hot_reload(window: glfw.Window, key: glfw.Key, scancode: i32, action: glfw.Action, mods: glfw.Mods) void {
    _ = window;
    _ = scancode;
    _ = mods;
    if (key == glfw.Key.r) {
        if (action == glfw.Action.press) {
            gl.UseProgram(0);
            const program = shader_loader.create_program_from_file() catch 0;
            gl.UseProgram(program);
        }
    }
}
