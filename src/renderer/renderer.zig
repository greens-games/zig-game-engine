const std = @import("std");
const gl = @import("ziggl");
const VertexArray = @import("vertex_array.zig").VertexArray;
const IndexBuffer = @import("index_buffer.zig").IndexBuffer;
const shader_loader = @import("../shaders/shader_loader.zig");

const World = @import("../engine/core/world.zig").World;
const Color = @import("raylib").Color;
const rl = @import("raylib");
const Constants = @import("../engine/core/constants.zig");
const GridUtils = @import("../example_game/grid/grid_utils.zig");
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
        for (world.characters_multi.slice().items(.position)) |pos| {
            const toWorld = GridUtils.gridToWorldCoords(pos.x, pos.y);
            rl.drawRectangle(toWorld.x, toWorld.y, Constants.CELL_W, Constants.CELL_H, Color.blue);
        }
    }

    pub fn drawTargetPos(world: World) void {
        for (world.characters_multi.slice().items(.target_pos)) |target| {
            if (target.x >= 0 and target.y >= 0) {
                const toWorld = GridUtils.gridToWorldCoords(target.x, target.y);
                rl.drawRectangle(toWorld.x, toWorld.y, Constants.CELL_W, Constants.CELL_H, Color.green);
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

    //TODO: Something is backwards here or in spawnTiles in init_system
    pub fn drawMap() void {
        for (0..15) |r| {
            for (0..20) |c| {
                const color: Color = switch (World.tiles[r][c]) {
                    .RESOURCE => Color.gold,
                    .ENEMY => Color.red,
                    else => Color.dark_green,
                };
                const toWorld = GridUtils.gridToWorldCoords(@intCast(c), @intCast(r));
                drawSquare(toWorld.x, toWorld.y, color);
            }
        }
    }

    pub fn drawSquare(x: i32, y: i32, color: rl.Color) void {
        rl.drawRectangle(x, y, Constants.CELL_W, Constants.CELL_H, color);
    }
};
