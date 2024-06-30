const std = @import("std");
const Position = @import("primitives.zig").Position;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
///Element for our Vertex Array layours
///size = values from 1-4 is number of values in current element (i.e x,y = 2; r,g,b,a = 4)
///type = gl types (i.e gl.FLOAT)
///normalize = gl bool (i.e gl.FALSE) this just normalizes value or not
///element_size = infered once added to Layout by passing in the type of the element (Can't use type as struct)
pub const VertexBufferElement = struct {
    size: c_int,
    type: c_uint,
    normalize: u8,
    element_size: c_int = 0,
};

pub const VertexBufferLayout = struct {
    elements: std.ArrayList(VertexBufferElement),
    stride: c_int = 0,

    pub fn init(allocator: Allocator) VertexBufferLayout {
        const list = ArrayList(VertexBufferElement).init(allocator);
        return .{ .elements = list };
    }

    pub fn deinit(self: *VertexBufferLayout) void {
        self.elements.deinit();
    }

    pub fn add(self: *VertexBufferLayout, element_to_add: *VertexBufferElement, comptime type_of_element: type) !void {
        element_to_add.element_size = @sizeOf(type_of_element);
        try self.elements.append(element_to_add.*);
        self.stride += @sizeOf(type_of_element);
    }
};

pub fn TestBufferElement(comptime T: type) type {
    return struct {
        x: T,
    };
}

const testing = std.testing;
test "Testing struct stuff" {
    const something: usize = @sizeOf(f32);
    try testing.expect(something == 4);
}
