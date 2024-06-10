const std = @import("std");
const glfw = @cImport(@cInclude("/home/matt/dev/glfw/include/GLFW/glfw3.h"));
const gl = @cImport(@cInclude("/home/matt/dev/glad/include/glad/gl.h"));

pub fn exit_callback(window: ?*glfw.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
    _ = scancode;
    _ = mods;
    if (key == glfw.GLFW_KEY_ESCAPE) {
        if (action == glfw.GLFW_PRESS) {
            glfw.glfwSetWindowShouldClose(window, glfw.GLFW_TRUE);
        }
    }
}
