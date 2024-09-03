const std = @import("std");
const ArrayList = std.ArrayList;
const gl = @import("ziggl");
const glfw = @import("mach-glfw");
const shader_loader = @import("../../shaders/shader_loader.zig");
const input = @import("../../event/input.zig");

const rl = @import("raylib");

//probably get moved out
const errs = @import("../../error/error.zig");
const setup = @import("../../init/setup.zig");
const Events = @import("../../event/event.zig");
const World = @import("world.zig").World;
const Renderer = @import("../../renderer/renderer.zig").RaylibRenderer;

//FROM EXAMPLE GAME
const InitSystem = @import("../../example_game/systems/init_system.zig");
const CharacterSystems = @import("../../example_game/systems/character_systems.zig");
const Characters = @import("../../example_game/components/character.zig");
const TileEventSystem = @import("../../example_game/events/tile_events.zig");
const InputSystem = @import("../../example_game/systems/input_systems.zig");

//Systems
var gl_procs: gl.ProcTable = undefined;
pub const Game = struct {
    //systems: SOme list of a struct to contain system information
    systems: ArrayList(*anyopaque) = ArrayList(*anyopaque).init(std.heap.page_allocator),
    world: World = .{},
    //We will call the update function of all systems or something
    window: glfw.Window = undefined,
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
        rl.setTargetFPS(60);
        var world: World = .{};
        var tile_event_system: TileEventSystem = .{};
        var tile_event_producer: TileEventSystem.TileClickEventProducer = .{};
        tile_event_producer.init() catch @panic("Failed to add to producer");
        //Run setup systems
        {
            //Init Map
            InitSystem.spawnTeam(&world);
            InitSystem.spawnTiles(&world);
        }

        // Main game loop
        while (!rl.windowShouldClose()) {
            rl.beginDrawing();
            defer rl.endDrawing();
            //run systems
            {
                InputSystem.handleMouseInput(world, &tile_event_producer);
                tile_event_system.update();
                CharacterSystems.detectHover(world.characters);
                CharacterSystems.moveCharacter(world.characters);
            }
            //run rendering
            {
                Renderer.drawGrid();
                Renderer.drawTeam(&world);
            }
            rl.clearBackground(rl.Color.white);
        }
    }

    fn raylibCleanUp(self: *Game) void {
        _ = self;
        rl.closeWindow();
    }
    fn openGLSetup(self: *Game) void {
        const w_width: u32 = 640;
        const w_height: u32 = 480;
        self.window = setup.init_glfw(w_width, w_height);
        if (!gl_procs.init(glfw.getProcAddress)) {
            std.log.err("failed to load OpenGL functions", .{});
            std.process.exit(1);
        }
        gl.makeProcTableCurrent(&gl_procs);

        //gl.Enable(gl.DEBUG_OUTPUT);
        gl.DebugMessageCallback(gl_message_callback, null);

        //Shader stuff:
        self.program = shader_loader.create_program_from_file() catch @panic("failed to create shader program");
        gl.UseProgram(self.program);

        self.window.setKeyCallback(input.hot_reload);
        self.window.setMouseButtonCallback(input.mouse_callback);
    }

    fn openGLRun(self: *Game) void {
        var last_frame_time: f64 = 0.0;
        while (!self.window.shouldClose()) {
            // Update the viewport to reflect any changes to the self.window's size.
            const curr_time: f64 = glfw.getTime();
            const delta_time = curr_time - last_frame_time;
            _ = delta_time;
            last_frame_time = curr_time;
            //we need to run each system in some way
            self.window.swapBuffers();
            glfw.pollEvents();
        }
    }

    pub fn openGLCleanUp(self: *Game) void {
        gl.UseProgram(0);
        gl.DeleteProgram(self.program);
        setup.clean_up(self.window);
    }
};

pub fn systemAddOn(system_ptr: *anyopaque, comptime T: type) type {
    return struct {
        impl: *T = system_ptr,
    };
}
fn gl_message_callback(source: gl.@"enum", gl_type: gl.@"enum", id: gl.uint, severity: gl.@"enum", length: gl.sizei, message: [*:0]const u8, userParam: ?*const anyopaque) callconv(.C) void {
    _ = source;
    _ = gl_type;
    _ = id;
    _ = severity;
    _ = length;
    _ = userParam;

    std.debug.print("OpenGL error: .{s}\n", .{message});
}
