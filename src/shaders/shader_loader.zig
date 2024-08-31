const gl = @import("ziggl");
const std = @import("std");

fn create_program(vert_shader_source: []const u8, frag_shader_source: []const u8) !gl.uint {
    const vert_shader = gl.CreateShader(gl.VERTEX_SHADER);
    defer gl.DeleteShader(vert_shader);
    gl.ShaderSource(vert_shader, 1, &[1][*]const u8{@ptrCast(vert_shader_source)}, &[1]c_int{@intCast(vert_shader_source.len)});
    gl.CompileShader(vert_shader);

    const frag_shader = gl.CreateShader(gl.FRAGMENT_SHADER);
    defer gl.DeleteShader(frag_shader);
    gl.ShaderSource(frag_shader, 1, &[1][*]const u8{@ptrCast(frag_shader_source)}, &[1]c_int{@intCast(frag_shader_source.len)});
    gl.CompileShader(frag_shader);

    const program = gl.CreateProgram();
    gl.AttachShader(program, vert_shader);
    gl.AttachShader(program, frag_shader);
    gl.LinkProgram(program);
    return program;
}

pub fn create_program_from_file() !gl.uint {
    //read in files for shader source
    //Linux
    //var f = try std.fs.openFileAbsolute("/home/matthewgreen/dev/game-engine-zig/src/shaders/basic_vertex.glsl", .{});
    var f = try std.fs.openFileAbsolute("/home/oem/dev/zig-game-engine/src/shaders/basic_vertex.glsl", .{});
    //Windows
    //var f = try std.fs.openFileAbsolute("C:/Development/zig-game-engine/src/shaders/basic_vertex.glsl", .{});
    defer f.close();
    var reader = std.fs.File.reader(f);
    var buf: [1024]u8 = undefined;

    const allocator = std.heap.page_allocator;

    var vert_source = std.ArrayList(u8).init(allocator);
    defer vert_source.deinit();

    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (std.mem.eql(u8, line, "#shader:vertex")) {
            continue;
        }
        if (std.mem.eql(u8, line, "#shader:fragment")) {
            break;
        }
        try vert_source.appendSlice(line);
        try vert_source.append('\n');
    }

    var frag_source = std.ArrayList(u8).init(allocator);
    defer frag_source.deinit();
    buf = undefined;

    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try frag_source.appendSlice(line);
        try frag_source.append('\n');
    }
    return create_program(@ptrCast(vert_source.items), @ptrCast(frag_source.items));
}

pub fn my_shader_strings() !gl.uint {
    const vertex_shader_source: []const u8 =
        \\#version 410 core
        \\
        \\
        \\in vec3 vp;
        \\
        \\void main() {
        \\      gl_Position = vec4(vp, 1.0);
        \\}
        \\
    ;
    const fragment_shader_source: []const u8 =
        \\#version 410 core
        \\
        \\out vec4 frag_colour;
        \\
        \\
        \\void main() {
        \\      frag_colour = vec4(0.5, 0.0, 0.5, 1.0);
        \\}
        \\
    ;

    return create_program(vertex_shader_source, fragment_shader_source);
}

test "test loading from files" {
    const glfw = @import("mach-glfw");
    const setup = @import("../init/setup.zig");
    var gl_procs: gl.ProcTable = undefined;

    const window: glfw.Window = setup.init_glfw();
    defer setup.clean_up(window);
    if (!gl_procs.init(glfw.getProcAddress)) {
        std.log.err("failed to load OpenGL functions", .{});
        std.process.exit(1);
    }
    gl.makeProcTableCurrent(&gl_procs);
    const program = try create_program_from_file();
    try std.testing.expect(program > 0);
}
