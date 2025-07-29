const std = @import("std");
const ArrayList = std.ArrayList;

const rl = @cImport({
    @cInclude("raylib.h");
});

//probably get moved out
const setup = @import("../../init/setup.zig");
const World = @import("world.zig").World;
const Renderer = @import("../../renderer/renderer.zig").RaylibRenderer;
const Timer = @import("../core/timer.zig").Timer;

//FROM EXAMPLE GAME
const InitSystem = @import("../../example_game/systems/init_system.zig");
const CharacterSystems = @import("../../example_game/systems/character_systems.zig");
const Characters = @import("../../example_game/components/character.zig");
const TileEventSystem = @import("../../example_game/events/tile_events.zig");
const InputSystem = @import("../../example_game/systems/input_systems.zig");

//Systems
pub const Game = struct {
    //systems: SOme list of a struct to contain system information
    systems: ArrayList(*anyopaque) = ArrayList(*anyopaque).init(std.heap.page_allocator),
    world: World = .{},
    //We will call the update function of all systems or something
    program: c_uint = undefined,
    renderer: ChosenRenderer = .raylib,

    //Bad memory management
    pub const ChosenRenderer = enum {
        open_gl,
        raylib,
    };

    pub fn setUp(self: *Game, renderer: ChosenRenderer) *Game {
        self.renderer = renderer;
        //comptime this?
        switch (self.renderer) {
            .open_gl => {
                self.openGLSetup();
            },
            .raylib => {
                self.raylibSetup();
            },
        }
        //we need to add systems somewhere
        return self;
    }

    pub fn run(self: *Game) void {
        //Input by consumer
        //
        switch (self.renderer) {
            .open_gl => {
                self.openGLRun();
            },
            .raylib => {
                self.raylibRun();
            },
        }
    }

    pub fn cleanUp(self: *Game) void {
        switch (self.renderer) {
            .open_gl => {
                self.openGLCleanUp();
            },
            .raylib => {
                self.raylibCleanUp();
            },
        }
    }

    pub fn addSystem(self: *Game, system: *anyopaque, system_type: anytype) void {
        _ = system_type;
        self.systems.append(system) catch |e| std.debug.panic("Failed to add  system: {?}\n", .{e});
    }

    pub fn eventSystemAddOn(self: *Game) *Game {
        return self;
    }

    //This stuff may end up being moved to their own file stuff

    fn raylibSetup(self: *Game) void {
        _ = self;
        setup.initRaylib(640, 480);
    }

    fn raylibRun(self: *Game) void {
        _ = self;
        rl.SetTargetFPS(60);
        var world: World = .{};
        //var tile_event_system: TileEventSystem = .{};
        var tile_event_producer: TileEventSystem.TileClickEventProducer = .{};
        var tile_event_consumer: TileEventSystem.TileClickEventConsumer = .{};
        tile_event_producer.init() catch @panic("Failed to add to producer");
        tile_event_consumer.init() catch @panic("Failed to add to consumer");
        var last_frame_time: f64 = 0.0;
        //Run setup systems
        {
            //Init Map
            InitSystem.spawnTeam(&world);
            InitSystem.spawnTiles();
            World.printTiles();
        }
        const timer: Timer = Timer.init(5.0, true);
        // I think we want to run some systems slower (i.e moving)
        while (!rl.WindowShouldClose()) {
            const curr_time: f64 = rl.GetTime();
            const delta_time = curr_time - last_frame_time;
            _ = delta_time; // autofix
            last_frame_time = curr_time;
            World.game_time = last_frame_time;
            rl.BeginDrawing();
            defer rl.EndDrawing();

            //TIMER TESTING
            {
                if (timer.isLooping and !timer.isRunning) {
                    //timer.start();
                }
            }
            //run systems
            //TODO: This will be controlled by game ticks
            {
                InputSystem.handleMouseInput(&tile_event_producer);
                TileEventSystem.update();
                CharacterSystems.detectHover(world.characters);
                CharacterSystems.updateTargetPos(world.characters_multi, &tile_event_consumer);
                CharacterSystems.moveUnit(world.characters_multi);
                CharacterSystems.resourceInteraction(world.characters_multi);
            }
            //render layer 1
            {
                Renderer.drawMap();
            }
            //render layer 2
            {
                Renderer.drawGrid();
                Renderer.drawTeam(&world);
            }
            rl.ClearBackground(rl.GRAY);
        }

        std.debug.print("last_frame_time: {d}; \n", .{last_frame_time});
    }

    fn raylibCleanUp(self: *Game) void {
        rl.CloseWindow();
        self.world.cleanUp();
    }
    fn openGLSetup(self: *Game) void {
        _ = self; // autofix
    }

    fn openGLRun(self: *Game) void {
        _ = self; // autofix
    }

    pub fn openGLCleanUp(self: *Game) void {
        _ = self; // autofix
    }
};

pub fn systemAddOn(system_ptr: *anyopaque, comptime T: type) type {
    return struct {
        impl: *T = system_ptr,
    };
}
//fn gl_message_callback(source: gl.@"enum", gl_type: gl.@"enum", id: gl.uint, severity: gl.@"enum", length: gl.sizei, message: [*:0]const u8, userParam: ?*const anyopaque) callconv(.C) void {
//    _ = source;
//    _ = gl_type;
//    _ = id;
//    _ = severity;
//    _ = length;
//    _ = userParam;

//    std.debug.print("OpenGL error: .{s}\n", .{message});
//}
