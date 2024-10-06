const std = @import("std");
const gl = @import("ziggl");
const VertexArray = @import("vertex_array.zig").VertexArray;
const IndexBuffer = @import("index_buffer.zig").IndexBuffer;
const shader_loader = @import("../shaders/shader_loader.zig");

const World = @import("../engine/core/world.zig").World;
const Color = @import("raylib").Color;
const rl = @import("raylib");
const Constants = @import("../engine/core/constants.zig");

///OpenGL renderer
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

//TODO: This whole renderer will need a rewrite to be more generic
pub const RaylibRenderer = struct {
    //Squares draw origin in top left
    pub fn drawTeam(world: *World) void {
        for (world.characters.items) |character| {
            rl.drawRectangle(character.position.x, character.position.y, Constants.CELL_W, Constants.CELL_H, character.color);
        }
    }

    pub fn drawTargetPos(world: World) void {
        for (world.characters_multi.slice().items(.target_pos)) |target| {
            if (target.x >= 0 and target.y >= 0) {
                rl.drawRectangle(target.x, target.y, Constants.CELL_W, Constants.CELL_H, Color.green);
            }
        }
    }

    pub fn drawGrid() void {
        var r: i32 = 0;
        while (r <= rl.getScreenHeight()) {
            var c: i32 = 0;
            while (c <= rl.getScreenWidth()) {
                rl.drawRectangleLines(c, r, Constants.CELL_W, Constants.CELL_H, Color.black);
                c += Constants.CELL_W;
            }
            r += Constants.CELL_H;
        }
    }

    pub fn drawSquare(x: i32, y: i32, color: rl.Color) void {
        rl.drawRectangle(x, y, Constants.CELL_W, Constants.CELL_H, color);
    }
};
