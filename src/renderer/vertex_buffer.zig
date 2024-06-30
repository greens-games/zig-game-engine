const gl = @import("ziggl");
const std = @import("std");

pub const VertexBuffer = struct {
    buff_id: c_uint = undefined,

    pub fn init(self: *VertexBuffer, data: ?*const anyopaque, type_of: type) void {
        gl.GenBuffers(1, @ptrCast(&self.buff_id));
        gl.BindBuffer(gl.ARRAY_BUFFER, self.buff_id);
        //param 2 = @sizeof(@TypeOf(whatever_is_in_Array_Buffer)
        gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(type_of), data, gl.STATIC_DRAW);
    }

    pub fn deinit(self: VertexBuffer) void {
        gl.DeleteBuffers(1, @ptrCast(self));
    }

    pub fn bind(self: VertexBuffer) void {
        gl.BindBuffer(gl.ARRAY_BUFFER, self.buff_id);
    }

    pub fn unbind() void {
        gl.BindBuffer(gl.ARRAY_BUFFER, 0);
    }
};
