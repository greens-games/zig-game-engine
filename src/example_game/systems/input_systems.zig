const std = @import("std");
const World = @import("../../engine/core/world.zig").World;
const Vector2 = @import("../../engine/core/types.zig").Vector2;

const TileClickEvent = @import("../components/tile_events.zig").TileClickEvent;
const GridUtils = @import("../grid/grid_utils.zig");
const TileEventSystem = @import("../events/tile_events.zig");
const TileType = @import("../components/tile.zig").TileType;
//TODO: Abstract out the mouse stuff later
const rl = @cImport({
    @cInclude("raylib.h");
});
///Track the mouse and handle different click scnearios
pub fn handleMouseInput(tile_event_producer: *TileEventSystem.TileClickEventProducer) void {
    const mouse_pos: Vector2 = .{
        .x = rl.GetMouseX(),
        .y = rl.GetMouseY(),
    };

    //Check if left-clicked
    if (rl.IsMouseButtonPressed(rl.MOUSE_BUTTON_LEFT)) {
        const mouse_rc: Vector2 = GridUtils.worldToGridCoords(mouse_pos.x, mouse_pos.y);
        //what did we click on?
        // TODO: We could check if the position of the mouse collided with anything
        // For now let's assume it's a tile
        //Create a tile click event
        const tile_type: TileType = World.tiles[@intCast(mouse_rc.y)][@intCast(mouse_rc.x)];
        const event: TileClickEvent = .{ .row = mouse_rc.y, .col = mouse_rc.x, .tile_type = tile_type };
        tile_event_producer.write(event) catch @panic("Failed to add tile event to tile events");
    }
}
