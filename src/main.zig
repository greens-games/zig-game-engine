const std = @import("std");

//main is our module source
//Anything we want a consumer to be able to use should be imported into main and marked pub
pub const Game = @import("core/game.zig").Game;
pub const World = @import("core/world.zig");
const Entity = @import("ecs/entity.zig");
const Events = @import("event/event.zig");
const any_type = @import("for_fun/any_type.zig");
const rl_render = @import("renderer/raylib_renderer.zig");
const System = @import("ecs/system.zig");
const InitSystem = @import("ecs/systems/init_system.zig");

//glfw is for input
//gl is for drawing
pub fn main() !void {
    //try run_ascii_game();
    var game: Game = .{};
    game.setUp(Game.ChosenRenderer.raylib).run();
    defer game.cleanUp();
    //try rl_render.raylib_entry();
}

fn run_ascii_game() !void {}

fn alter_x(x: *i32) void {
    x.* += @as(i32, 1);
}

test "testing fuinction param" {
    var x: i32 = 1;
    alter_x(&x);
    try std.testing.expectEqual(2, x);
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "all" {
    std.testing.refAllDecls(any_type);
    std.testing.refAllDecls(Entity);
    std.testing.refAllDecls(Events);
    std.testing.refAllDecls(InitSystem);
}
