const std = @import("std");
const Events = @import("../event/event.zig");
const Game = @import("../core/game.zig").Game;
///System will be a struct
///Update func gets called
///props of struct act like the function params
///User writes the update function
///Game calls the udpdate function
pub const ExampleSystem = struct {
    param1: i32,
    param2: u8,
    param_consumer: Events.MouseEventsConsumer = undefined,

    pub fn update() !void {}
};

test "Add System" {
    var game: *Game = .{};
    var example_system: ExampleSystem = .{ .param1 = 5, .param2 = 1 };
    game.addSystem(&example_system, @TypeOf(example_system));
    std.AutoHashMap(comptime K: type, comptime V: type)
}
