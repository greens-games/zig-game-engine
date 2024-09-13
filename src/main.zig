const std = @import("std");

//main is our module source
//Anything we want a consumer to be able to use should be imported into main and marked pub
//Engine Specific
pub const Game = @import("engine/core/game.zig").Game;
pub const World = @import("engine/core/world.zig");
const Entity = @import("engine/ecs/entity.zig");
const Events = @import("event/event.zig");
const any_type = @import("for_fun/any_type.zig");
const rl_render = @import("renderer/raylib_renderer.zig");
const System = @import("engine/ecs/system.zig");
const BFSearch = @import("engine/pathfinding/breadth_first.zig");
const AStar = @import("engine/pathfinding/astar.zig");

//Game Specific
const TileEvents = @import("example_game/events/tile_events.zig");

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

test "test some list stuff" {
    const Something = struct {
        x: i32 = 0,
        y: i32 = 0,
    };

    var list = std.ArrayList(Something).init(std.testing.allocator);
    defer list.deinit();

    const something1: Something = .{};
    try list.append(something1);
    try std.testing.expect(list.items.len == 1);
    try std.testing.expect(list.items[0].x == 0);
    list.items[0].x += 1;
    try std.testing.expect(list.items[0].x == 1);
}

test "all" {
    std.testing.refAllDecls(Entity);
    std.testing.refAllDecls(Events);
    std.testing.refAllDecls(World);
    std.testing.refAllDecls(TileEvents);
    std.testing.refAllDecls(BFSearch);
    std.testing.refAllDecls(AStar);
}
