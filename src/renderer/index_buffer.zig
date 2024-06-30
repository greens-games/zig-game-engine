const gl = @import("ziggl");
const std = @import("std");

pub const IndexBuffer = struct {
    buff_id: c_uint = undefined,
    count: c_int,

    pub fn init(self: *IndexBuffer, data: ?*const anyopaque) void {
        gl.GenBuffers(1, @ptrCast(&self.buff_id));
        gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, self.buff_id);
        //param 2 = @sizeof(@TypeOf(whatever_is_in_Array_Buffer)
        gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, self.count * @sizeOf(c_uint), data, gl.STATIC_DRAW);
    }

    pub fn deinit(self: IndexBuffer) void {
        gl.DeleteBuffers(1, @ptrCast(self));
    }

    pub fn bind(self: IndexBuffer) void {
        gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, self.buff_id);
    }

    pub fn unbind() void {
        gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0);
    }
};
