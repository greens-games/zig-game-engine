const std = @import("std");
const gl = @import("ziggl");
const glfw = @import("mach-glfw");
const shader_loader = @import("../shaders/shader_loader.zig");
const input = @import("../event/input.zig");

const primitives = @import("../renderer/primitives.zig");
const VertexBuffer = @import("../renderer/vertex_buffer.zig").VertexBuffer;
const IndexBuffer = @import("../renderer/index_buffer.zig").IndexBuffer;
const VertexBufferElement = @import("../renderer/vertex_buffer_layout.zig").VertexBufferElement;
const VertexBufferLayout = @import("../renderer/vertex_buffer_layout.zig").VertexBufferLayout;
const VertexArray = @import("../renderer/vertex_array.zig").VertexArray;
const Renderer = @import("../renderer/renderer.zig").Renderer;
const vblayout = @import("../renderer/vertex_buffer_layout.zig");

//JUST FOR FUN
const colour_fun = @import("../for_fun/colour_fun.zig");
const ColourStuff = @import("../for_fun/colour_fun.zig").ColourStuff;
///Data
fn data() void {

    //GRAPHICS
    const positions: [4]primitives.Position = [_]primitives.Position{
        .{ .x = 0.5, .y = 0.5 },
        .{ .x = 0.5, .y = -0.5 },
        .{ .x = -0.5, .y = -0.5 },
        .{ .x = -0.5, .y = 0.5 },
    };
    _ = positions;

    const indices: [6]c_uint = [_]c_uint{ 0, 1, 2, 2, 3, 0 };

    const positions2: [4]primitives.Position = [_]primitives.Position{
        .{ .x = 1.0, .y = 1.0 },
        .{ .x = 1.0, .y = 0.75 },
        .{ .x = 0.0, .y = 0.75 },
        .{ .x = 0.0, .y = 1.0 },
    };
    _ = positions2;

    //CREATE INDEX BUFF
    var ibo: IndexBuffer = IndexBuffer{ .count = 6 };
    ibo.init(&indices);
}

fn drawing(window: glfw.Window, positions: []primitives.Position, ibo: IndexBuffer, program: gl.uint, time_step: f64, positions2: []primitives.Position) void {
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
    vbl.add(&vbe, primitives.Position) catch @panic("failed to add vbe");
    defer vbl.deinit();

    //CREATE VERTEX ARRAY
    var va: VertexArray = VertexArray{};
    va.init();
    va.add_buffer(vert_buff1, vbl);
    // Clear the self.window.
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
    vbl2.add(&vbe2, primitives.Position) catch @panic("failed to add vbe");
    defer vbl2.deinit();

    //CREATE VERTEX ARRAY
    var va2: VertexArray = VertexArray{};
    va2.init();
    va2.add_buffer(vert_buff2, vbl2);

    Renderer.draw(va2, ibo, program);

    //Some stuff
    //
    const colour_loc: c_int = gl.GetUniformLocation(program, "u_colour");

    const colour_stuff: ColourStuff = ColourStuff{
        .r = 0.02,
        .g = 0.04,
        .b = 0.01,
        .r_change = 0.02,
        .g_change = 0.01,
        .b_change = 0.03,
    };
    colour_fun.colour_magic(colour_loc, &colour_stuff);
}
