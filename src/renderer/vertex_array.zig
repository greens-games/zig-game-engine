const gl = @import("ziggl");
const testing = @import("std").testing;
const std = @import("std");
const VertexBuffer = @import("vertex_buffer.zig").VertexBuffer;
const VertexBufferLayout = @import("vertex_buffer_layout.zig").VertexBufferLayout;
const VertexBufferElement = @import("vertex_buffer_layout.zig").VertexBufferElement;

pub const VertexArray = struct {
    vertex_id: c_uint = undefined,

    pub fn init(self: *VertexArray) void {
        gl.GenVertexArrays(1, @ptrCast(&self.vertex_id));
        gl.BindVertexArray(self.vertex_id);
    }

    pub fn add_buffer(self: VertexArray, vb: VertexBuffer, vbl: VertexBufferLayout) void {
        self.bind();
        vb.bind();
        var offset: c_uint = 0;
        for (vbl.elements.items, 0..vbl.elements.items.len) |element, i| {
            const casted_i: c_uint = @intCast(i);
            gl.EnableVertexAttribArray(casted_i);
            gl.VertexAttribPointer(casted_i, element.size, element.type, element.normalize, vbl.stride, offset);
            offset += @intCast(element.size * element.element_size);
        }
    }

    pub fn bind(self: VertexArray) void {
        gl.BindVertexArray(self.vertex_id);
    }
};

test "Creating vertex array" {}
