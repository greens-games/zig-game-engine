const std = @import("std");

//Deps
const glfw = @import("mach-glfw");
const gl = @import("ziggl");
const zigimg = @import("zigimg");

//My Stuff
const errs = @import("error/error.zig");
const input = @import("event/input.zig");
const setup = @import("init/setup.zig");
const shader_loader = @import("shaders/shader_loader.zig");
const primitives = @import("renderer/primitives.zig");
const VertexBuffer = @import("renderer/vertex_buffer.zig").VertexBuffer;
const IndexBuffer = @import("renderer/index_buffer.zig").IndexBuffer;
const VertexBufferElement = @import("renderer/vertex_buffer_layout.zig").VertexBufferElement;
const VertexBufferLayout = @import("renderer/vertex_buffer_layout.zig").VertexBufferLayout;
const VertexArray = @import("renderer/vertex_array.zig").VertexArray;
const Renderer = @import("renderer/renderer.zig").Renderer;
const vblayout = @import("renderer/vertex_buffer_layout.zig");

//JUST FOR FUN
const colour_fun = @import("for_fun/colour_fun.zig");
const ColourStuff = @import("for_fun/colour_fun.zig").ColourStuff;

var gl_procs: gl.ProcTable = undefined;

//glfw is for input
//gl is for drawing
pub fn main() !void {
    try run_opengl_game();
    try run_ascii_game();
}

fn run_ascii_game() !void {}

fn run_opengl_game() !void {
    const w_width: u32 = 640;
    const w_height: u32 = 480;
    const window: glfw.Window = setup.init_glfw(w_width, w_height);
    defer setup.clean_up(window);
    if (!gl_procs.init(glfw.getProcAddress)) {
        std.log.err("failed to load OpenGL functions", .{});
        std.process.exit(1);
    }
    gl.makeProcTableCurrent(&gl_procs);

    //gl.Enable(gl.DEBUG_OUTPUT);
    gl.DebugMessageCallback(gl_message_callback, null);

    //Shader stuff:
    const program = try shader_loader.create_program_from_file();
    gl.UseProgram(program);
    defer gl.UseProgram(0);
    defer gl.DeleteProgram(program);

    window.setKeyCallback(input.hot_reload);

    //GRAPHICS
    var positions: [4]primitives.Position = [_]primitives.Position{
        .{ .x = 0.5, .y = 0.5 },
        .{ .x = 0.5, .y = -0.5 },
        .{ .x = -0.5, .y = -0.5 },
        .{ .x = -0.5, .y = 0.5 },
    };

    const indices: [6]c_uint = [_]c_uint{ 0, 1, 2, 2, 3, 0 };

    const positions2: [4]primitives.Position = [_]primitives.Position{
        .{ .x = 1.0, .y = 1.0 },
        .{ .x = 1.0, .y = 0.75 },
        .{ .x = 0.0, .y = 0.75 },
        .{ .x = 0.0, .y = 1.0 },
    };

    //CREATE INDEX BUFF
    var ibo: IndexBuffer = IndexBuffer{ .count = 6 };
    ibo.init(&indices);

    const colour_loc: c_int = gl.GetUniformLocation(program, "u_colour");

    var colour_stuff: ColourStuff = ColourStuff{
        .r = 0.02,
        .g = 0.04,
        .b = 0.01,
        .r_change = 0.02,
        .g_change = 0.01,
        .b_change = 0.03,
    };
    var last_frame_time: f64 = 0.0;

    //Textures

    //GAME LOOP
    while (!window.shouldClose()) {
        // Update the viewport to reflect any changes to the window's size.
        const curr_time: f64 = glfw.getTime();
        const time_step = curr_time - last_frame_time;
        last_frame_time = curr_time;
        const fb_size = window.getFramebufferSize();
        gl.Viewport(0, 0, @intCast(fb_size.width), @intCast(fb_size.height));
        Renderer.clear();

        //SQUARE 1
        //CREATE VERTEX BUFFER
        var vert_buff1: VertexBuffer = VertexBuffer{};
        vert_buff1.init(&positions, @TypeOf(positions));

        //CREATE VERTEX BUFFER LAYOUT
        var vbl = VertexBufferLayout.init(std.heap.page_allocator);
        var vbe = VertexBufferElement{
            .size = 2,
            .type = gl.FLOAT,
            .normalize = gl.FALSE,
        };
        try vbl.add(&vbe, primitives.Position);
        defer vbl.deinit();

        //CREATE VERTEX ARRAY
        var va: VertexArray = VertexArray{};
        va.init();
        va.add_buffer(vert_buff1, vbl);
        // Clear the window.
        Renderer.draw(va, ibo, program);
        //Moves object right (Probably move this stuff to shader or something, definitely move it out to abstraction
        //Better to use matrix transformation
        positions[0].x += 0.1 * @as(f32, @floatCast(time_step));
        positions[1].x += 0.1 * @as(f32, @floatCast(time_step));
        positions[2].x += 0.1 * @as(f32, @floatCast(time_step));
        positions[3].x += 0.1 * @as(f32, @floatCast(time_step));

        // SQUARE 2
        //CREATE VERTEX BUFFER
        var vert_buff2: VertexBuffer = VertexBuffer{};
        vert_buff2.init(&positions2, @TypeOf(positions2));

        //CREATE VERTEX BUFFER LAYOUT
        var vbl2 = VertexBufferLayout.init(std.heap.page_allocator);
        var vbe2 = VertexBufferElement{
            .size = 2,
            .type = gl.FLOAT,
            .normalize = gl.FALSE,
        };
        try vbl2.add(&vbe2, primitives.Position);
        defer vbl2.deinit();

        //CREATE VERTEX ARRAY
        var va2: VertexArray = VertexArray{};
        va2.init();
        va2.add_buffer(vert_buff2, vbl2);

        Renderer.draw(va2, ibo, program);

        //Some stuff
        colour_fun.colour_magic(colour_loc, &colour_stuff);
        window.swapBuffers();
        glfw.pollEvents();
    }
}

fn gl_message_callback(source: gl.@"enum", gl_type: gl.@"enum", id: gl.uint, severity: gl.@"enum", length: gl.sizei, message: [*:0]const u8, userParam: ?*const anyopaque) callconv(.C) void {
    _ = source;
    _ = gl_type;
    _ = id;
    _ = severity;
    _ = length;
    _ = userParam;

    std.debug.print("OpenGL error: .{s}\n", .{message});
}

fn alter_x(x: *i32) void {
    x.* += @as(i32, 1);
}

test "testing fuinction param" {
    var x: i32 = 1;
    alter_x(&x);
    try std.testing.expectEqual(2, x);
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "all" {
    std.testing.refAllDecls(vblayout);
    std.testing.refAllDecls(VertexArray);
}
