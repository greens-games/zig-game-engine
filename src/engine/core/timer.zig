const std = @import("std");
const Thread = std.Thread;
const World = @import("world.zig").World;
pub const Timer = struct {

    //Start
    //Duration
    duration: f64,
    //continuous
    isLooping: bool,
    //Current Timer
    curr_time: f64,
    initial_time: f64,
    isRunning: bool,

    //Functions
    //
    pub fn init(dur: f64, cont: bool) Timer {
        return .{
            .duration = dur,
            .isLooping = cont,
            .curr_time = 0,
            .initial_time = World.game_time,
            .isRunning = false,
        };
    }

    pub fn start(self: *Timer) void {
        //start timing
        self.isRunning = true;
        self.initial_time = World.game_time;
        //We are getting a seg fault on this threading stuff
        //Remove for now maybe change to it later
        //        const timer_thread: Thread = Thread.spawn(.{}, tick, .{self}) catch @panic("Failed to start timer thread\n"); timer_thread.detach();

    }

    pub fn tick(self: *Timer) void {
        if (!self.isRunning) {
            self.start();
        }

        if (self.curr_time < self.duration) {
            const game_time: f64 = World.game_time;
            self.curr_time = game_time - self.initial_time;
        }

        if (self.curr_time >= self.duration) {
            self.end();
        }
    }

    fn end(self: *Timer) void {
        std.debug.print("Timer ended at: {d}\n", .{self.curr_time});
        self.isRunning = false;
        self.reset();
    }

    fn reset(self: *Timer) void {
        self.curr_time = 0;
        self.initial_time = World.game_time;
    }
};
