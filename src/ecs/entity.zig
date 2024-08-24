const std = @import("std");
///A component is just a pointer to some struct of data
///We will use *anyopaque for a lot of these I believe
pub const Entity = struct {
    //This will be auto generated
    entity_id: u32,
    //WHat if we had an array that is just memory addresses for our components
    components: std.ArrayList(*anyopaque) = std.ArrayList(*anyopaque).init(std.heap.page_allocator),

    pub fn add_component(self: *Entity, component: *anyopaque) !void {
        try self.components.append(component);
    }
};

test "component pointer" {
    const TestComponent = struct {
        x: f32,
        y: f32,
    };
    var entity: Entity = .{ .entity_id = 1 };
    var test_comp: TestComponent = .{ .x = 1.0, .y = 1.0 };

    try entity.add_component(&test_comp);
    const curr_comp: *TestComponent = @ptrCast(@alignCast(entity.components.pop()));
    try std.testing.expect(curr_comp.x == test_comp.x);
    //try entity.add_component(test_comp);
    try std.testing.expect(1 == 1);
}

const SomeStruct = struct {
    x: u32,

    pub fn addOne(self: *SomeStruct) void {
        self.x += 1;
    }
};
fn takesAnyType(some_ptr: *anyopaque, some_type: anytype) void {
    const given_struct: *some_type = @ptrCast(@alignCast(some_ptr));
    given_struct.addOne();
}
test "anytype testing" {
    var test1: SomeStruct = .{ .x = 1 };
    takesAnyType(&test1, SomeStruct);
    try std.testing.expect(test1.x == 2);
}
