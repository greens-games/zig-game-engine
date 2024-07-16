const std = @import("std");
const gl = @import("ziggl");
const glfw = @import("mach-glfw");
const shader_loader = @import("../shaders/shader_loader.zig");
const input = @import("../event/input.zig");

//probably get moved out
const errs = @import("../error/error.zig");
const setup = @import("../init/setup.zig");
const primitives = @import("../renderer/primitives.zig");
const VertexBuffer = @import("../renderer/vertex_buffer.zig").VertexBuffer;
const IndexBuffer = @import("../renderer/index_buffer.zig").IndexBuffer;
const VertexBufferElement = @import("../renderer/vertex_buffer_layout.zig").VertexBufferElement;
const VertexBufferLayout = @import("../renderer/vertex_buffer_layout.zig").VertexBufferLayout;
const VertexArray = @import("../renderer/vertex_array.zig").VertexArray;
const Renderer = @import("../renderer/renderer.zig").Renderer;
const vblayout = @import("../renderer/vertex_buffer_layout.zig");
const Events = @import("../event/event.zig");

//JUST FOR FUN
const colour_fun = @import("../for_fun/colour_fun.zig");
const ColourStuff = @import("../for_fun/colour_fun.zig").ColourStuff;

var gl_procs: gl.ProcTable = undefined;
pub const Game = struct {
    window: glfw.Window = undefined,
    program: c_uint = undefined,

    pub fn setUp(self: *Game) *Game {
        const w_width: u32 = 640;
        const w_height: u32 = 480;
        self.window = setup.init_glfw(w_width, w_height);
        if (!gl_procs.init(glfw.getProcAddress)) {
            std.log.err("failed to load OpenGL functions", .{});
            std.process.exit(1);
        }
        gl.makeProcTableCurrent(&gl_procs);

        //gl.Enable(gl.DEBUG_OUTPUT);
        gl.DebugMessageCallback(gl_message_callback, null);

        //Shader stuff:
        self.program = shader_loader.create_program_from_file() catch @panic("failed to create shader program");
        gl.UseProgram(self.program);

        self.window.setKeyCallback(input.hot_reload);
        self.window.setMouseButtonCallback(input.mouse_callback);
        return self;
    }

    pub fn run(self: *Game) void {
        //Input by consumer
        var last_frame_time: f64 = 0.0;
        while (!self.window.shouldClose()) {
            // Update the viewport to reflect any changes to the self.window's size.
            const curr_time: f64 = glfw.getTime();
            const delta_time = curr_time - last_frame_time;
            _ = delta_time;
            last_frame_time = curr_time;
            self.window.swapBuffers();
            glfw.pollEvents();
        }
    }

    pub fn cleanUp(self: *Game) void {
        gl.UseProgram(0);
        gl.DeleteProgram(self.program);
        setup.clean_up(self.window);
    }
};

fn gl_message_callback(source: gl.@"enum", gl_type: gl.@"enum", id: gl.uint, severity: gl.@"enum", length: gl.sizei, message: [*:0]const u8, userParam: ?*const anyopaque) callconv(.C) void {
    _ = source;
    _ = gl_type;
    _ = id;
    _ = severity;
    _ = length;
    _ = userParam;

    std.debug.print("OpenGL error: .{s}\n", .{message});
}
