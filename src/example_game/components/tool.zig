const Timer = @import("../../engine/core/timer.zig").Timer;
pub const ForestryTool = struct {
    harvest_cd: Timer,

    pub fn init(cd: f64) ForestryTool {
        return .{
            .harvest_cd = Timer.init(cd, true),
        };
    }
};
