const std = @import("std");

//main is our module source
//Anything we want a consumer to be able to use should be imported into main and marked pub
//Engine Specific
pub const Game = @import("engine/core/game.zig").Game;
pub const World = @import("engine/core/world.zig");
const Entity = @import("engine/ecs/entity.zig");
const any_type = @import("for_fun/any_type.zig");
const rl_render = @import("renderer/raylib_renderer.zig");
const BFSearch = @import("engine/pathfinding/breadth_first.zig");
const AStar = @import("engine/pathfinding/astar.zig");
const InitSystem = @import("example_game/systems/init_system.zig");
const CharacterSystem = @import("example_game/systems/character_systems.zig");
const EventSystem = @import("engine/ecs/event_system.zig");

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

test "all" {
    //    std.testing.refAllDecls(Entity);
    //    std.testing.refAllDecls(Events);
    //std.testing.refAllDecls(World);
    //    std.testing.refAllDecls(InitSystem);
    //    std.testing.refAllDecls(CharacterSystem);
    //    std.testing.refAllDecls(TileEvents);
    //    std.testing.refAllDecls(BFSearch);
    //std.testing.refAllDecls(AStar);
    std.testing.refAllDecls(EventSystem);
}
