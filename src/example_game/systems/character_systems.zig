const std = @import("std");
const Arraylist = std.ArrayList;
const MultiArraylist = std.MultiArrayList;
const rl = @import("raylib");
const Vector2 = @import("../../engine/core/types.zig").Vector2;
const AStar = @import("../../engine/pathfinding/astar.zig");
const Character = @import("../components/character.zig").Character;
const GridUtils = @import("../../example_game/grid/grid_utils.zig");
const TileEventConsumer = @import("../events/tile_events.zig").TileClickEventConsumer;
const TileClickEvent = @import("../components/tile_events.zig").TileClickEvent;
const World = @import("../../engine/core/world.zig").World;
const TileType = @import("../components/tile.zig").TileType;

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

pub fn updateTargetPos(characters: MultiArraylist(Character), tile_event_consumer: *TileEventConsumer) void {
    if (tile_event_consumer.events.items.len > 0) {
        //do something with the event
        const event: TileClickEvent = tile_event_consumer.events.orderedRemove(0);
        const char_slice = characters.slice();
        for (char_slice.items(.target_pos), char_slice.items(.position), char_slice.items(.path), char_slice.items(.curr_state)) |*target, pos, *path, *state| {
            const new_pos: Vector2 = .{ .x = event.col, .y = event.row };
            if (!new_pos.eql(target.*)) {
                //Check what the tile is we are moving to
                const selected_tile: TileType = World.tiles[@intCast(new_pos.y)][@intCast(new_pos.x)];
                switch (selected_tile) {
                    .RESOURCE => state.* = .HARVESTING,
                    .ENEMY => state.* = .ATTACKING,
                    else => state.* = .IDLE,
                }
                std.debug.print("SELECTED TILE {?} AT POS: ({?}, {?})\n", .{ selected_tile, new_pos.x, new_pos.y });
                if (selected_tile != .RESOURCE) {
                    target.* = new_pos;
                    path.* = AStar.aStar(pos, target.*);
                } else {
                    //find closest non-resource tile

                    //astar to this tile
                    //set state to Harvesting
                    state.* = .HARVESTING;
                }
            }
        }
    }
}

fn findClosestTile() Vector2 {
    return .{
        .x = 0,
        .y = 0,
    };
}

pub fn moveUnit(characters: MultiArraylist(Character)) void {

    //get the next location in move_path, set player's position to that location
    const char_slice = characters.slice();
    for (char_slice.items(.path), char_slice.items(.position)) |*move, *curr_position| {
        if (move.*.items.len > 0) {
            const new_pos: Vector2 = move.*.pop();
            curr_position.* = new_pos;
        }
    }
}

pub fn resourceInteraction(characters: MultiArraylist(Character)) void {
    //happens when player clicks on a resource
    _ = characters;
}
