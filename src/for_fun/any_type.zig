const std = @import("std");
pub fn return_x(entity: anytype) i32 {
    return entity.x;
}

const TestStruct1 = struct {
    x: i32,
};

const TestStruct2 = struct {
    y: i32,
};

test {
    const thing1: TestStruct1 = .{ .x = 1 };
    try std.testing.expect(return_x(thing1) == 1);

    //This fails because TestStruct2 doesn't have a 'x' property and return_x blindly tries to access x for 'anytype'
    //const thing2: TestStruct2 = .{ .y = 1 };
    //try std.testing.expect(return_x(thing2) == 1);
}
