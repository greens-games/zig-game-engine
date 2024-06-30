const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("ziggl");
const errs = @import("../error/error.zig");

pub fn init_glfw(width: u32, height: u32) glfw.Window {
    glfw.setErrorCallback(errs.errorCallback);
    if (!glfw.init(.{})) {
        std.log.err("failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    }

    // Create our window
    const window = glfw.Window.create(width, height, "Hello, mach-glfw!", null, null, .{
        .context_version_major = 4,
        .context_version_minor = 6,
        .opengl_profile = .opengl_core_profile,
    }) orelse {
        std.log.err("failed to create GLFW window: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    };
    glfw.makeContextCurrent(window);
    // turn on VSync
    glfw.swapInterval(1);

    return window;
}

pub fn clean_up(window: glfw.Window) void {
    gl.makeProcTableCurrent(null);
    window.destroy();
    glfw.makeContextCurrent(null);
    glfw.terminate();
}
