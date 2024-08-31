const std = @import("std");
const gl = @import("ziggl");
const VertexArray = @import("vertex_array.zig").VertexArray;
const IndexBuffer = @import("index_buffer.zig").IndexBuffer;
const shader_loader = @import("../shaders/shader_loader.zig");

const World = @import("../core/world.zig").World;
const Characters = @import("../ecs/components/character.zig");
const Color = @import("raylib").Color;
const rl = @import("raylib");

pub const Renderer = struct {
    pub fn draw(vao: VertexArray, ibo: IndexBuffer, shader: c_uint) void {
        gl.UseProgram(shader);
        //CREATE VERTEX ARRAY
        vao.bind();
        //CREATE INDEX BUFF
        ibo.bind();

        gl.DrawElements(gl.TRIANGLES, ibo.count, gl.UNSIGNED_INT, ibo.buff_id);
    }

    pub fn clear() void {
        gl.Clear(gl.COLOR_BUFFER_BIT);
    }
};

pub const RaylibRenderer = struct {
    pub fn draw_team(world: *World) void {
        for (world.characters.items) |character| {
            rl.drawRectangle(character.x, character.y, 16, 16, character.color);
        }
    }
};
