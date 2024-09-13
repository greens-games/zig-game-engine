const std = @import("std");
const Arraylist = std.ArrayList;
const rl = @import("raylib");
const Character = @import("../components/character.zig").Character;
const GridUtils = @import("../../example_game/grid/grid_utils.zig");
const Vector2 = @import("../../engine/core/types.zig").Vector2;
const TileEventConsumer = @import("../events/tile_events.zig").TileClickEventConsumer;
const TileClickEvent = @import("../components/tile_events.zig").TileClickEvent;

//TODO: Remove all instances of raylib from gameplay systems (we can use raylib stuff in input and render systems)
pub fn detectHover(characters: Arraylist(Character)) void {
    _ = characters;
}

pub fn moveCharacter(characters: Arraylist(Character)) void {
    if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left)) {
        const mouse_x = rl.getMouseX();
        const mouse_y = rl.getMouseY();
        for (characters.items) |*character| {
            const row_col: Vector2 = GridUtils.worldToGridCoords(mouse_x, mouse_y);
            const new_pos: Vector2 = GridUtils.gridToWorldCoords(row_col.x, row_col.y);
            character.position = new_pos;
        }
    }
}

pub fn updateTargetPos(characters: Arraylist(Character), tile_event_consumer: *TileEventConsumer) void {
    if (tile_event_consumer.events.items.len > 0) {
        //do something with the event
        const event: TileClickEvent = tile_event_consumer.events.orderedRemove(0);
        for (characters.items) |*character| {
            const new_pos: Vector2 = GridUtils.gridToWorldCoords(event.col, event.row);
            character.target_pos = new_pos;
        }
    }
}
