const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("ziggl");
const shader_loader = @import("../shaders/shader_loader.zig");
const Events = @import("event.zig");

///Key callback
pub fn hot_reload(window: glfw.Window, key: glfw.Key, scancode: i32, action: glfw.Action, mods: glfw.Mods) void {
    _ = window;
    std.debug.print("Key: {?}; ScanCode: {?}; Action: {?}; Mods: {?}\n", .{ key, scancode, action, mods });

    if (key == glfw.Key.r) {
        if (action == glfw.Action.press) {
            gl.UseProgram(0);
            const program = shader_loader.create_program_from_file() catch 0;
            gl.UseProgram(program);
        }
    }
}

///Mouse input callback
///Does not appear to use Repeat Action so holding mouse might be interesting
pub fn mouse_callback(window: glfw.Window, button: glfw.MouseButton, action: glfw.Action, mods: glfw.Mods) void {
    _ = window;
    //When a mouse button is pressed
    //We create a mouse input event

    //set the values of the event struct to what was pressed
    std.debug.print("Button: {?}; Action: {?}; Mods: {?}\n", .{ button, action, mods });
}
