const std = @import("std");
const World = @import("../../engine/core/world.zig").World;
const Vector2 = @import("../../engine/core/types.zig").Vector2;

const TileClickEvent = @import("../components/tile_events.zig").TileClickEvent;
const GridUtils = @import("../grid/grid_utils.zig");
const TileEventSystem = @import("../events/tile_events.zig");
//TODO: Abstract out the mouse stuff later
const rl = @import("raylib");
///Track the mouse and handle different click scnearios
pub fn handleMouseInput(world: World, tile_event_producer: *TileEventSystem.TileClickEventProducer) void {
    const mouse_pos: Vector2 = .{
        .x = rl.getMouseX(),
        .y = rl.getMouseY(),
    };

    //Check if left-clicked
    if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left)) {
        const mouse_rc: Vector2 = GridUtils.worldToGridCoords(mouse_pos.x, mouse_pos.y);
        //what did we click on?
        // TODO: We could check if the position of the mouse collided with anything
        // For now let's assume it's a tile
        for (world.al_tiles.items) |tile| {
            if (tile.col == mouse_rc.x and tile.row == mouse_rc.y) {
                //Create a tile click event
                const event: TileClickEvent = .{ .row = tile.row, .col = tile.col, .tile_type = tile.tile_type };
                tile_event_producer.write(event) catch @panic("Failed to add tile event to tile events");
                break;
            }
        }
    }
}
