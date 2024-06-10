const std = @import("std");
const glfw = @cImport(@cInclude("/home/matt/dev/glfw/include/GLFW/glfw3.h"));
const gl = @cImport(@cInclude("/home/matt/dev/glad/include/glad/gl.h"));
const errs = @import("error/error.zig");
const input = @import("event/input.zig");
const print = std.debug.print;

pub fn main() !void {
    const temp = glfw.glfwInit();

    if (temp == 0) {
        return std.debug.print("Failed to initialize GLFW\n", .{});
    }
    print("Creating window", .{});
    const window = glfw.glfwCreateWindow(640, 480, "Yo", null, null);
    _ = glfw.glfwSetErrorCallback(errs.errorCallback) orelse null;
    glfw.glfwMakeContextCurrent(window);

    _ = gl.gladLoadGL(glfw.glfwGetProcAddress);

    if (window == null) {
        return print("Failed to create window\n", .{});
    }
    defer glfw.glfwDestroyWindow(window);

    _ = glfw.glfwSetKeyCallback(window, input.exit_callback);

    while (glfw.glfwWindowShouldClose(window) == 0) {
        glfw.glfwPollEvents();
    }

    print("We made it to the end\n", .{});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
