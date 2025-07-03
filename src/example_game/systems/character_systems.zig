const std = @import("std");
const Arraylist = std.ArrayList;
const MultiArraylist = std.MultiArrayList;
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

pub fn updateTargetPos(characters: MultiArraylist(Character), tile_event_consumer: *TileEventConsumer) void {
    if (tile_event_consumer.events.items.len > 0) {
        //do something with the event
        const event: TileClickEvent = tile_event_consumer.events.orderedRemove(0);
        const char_slice = characters.slice();
        for (char_slice.items(.target_pos), char_slice.items(.position), char_slice.items(.path), char_slice.items(.queued_state)) |*target, pos, *path, *state| {
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
                    //TODO: We will put the new ActionState into the a queue and pop it off once we reach the final spot, if we our goal state hasn't changed we will grab it from the queue for the system that needs it
                    state.* = .HARVESTING;
                    target.* = findClosestTile(new_pos, pos);
                    path.* = AStar.aStar(pos, target.*);
                }
            }
        }
    }
}

pub fn moveUnit(characters: MultiArraylist(Character)) void {

    //get the next location in move_path, set player's position to that location
    const char_slice = characters.slice();
    for (char_slice.items(.path), char_slice.items(.position), char_slice.items(.queued_state), char_slice.items(.curr_state)) |*move, *curr_position, *q_state, *c_state| {
        if (move.*.items.len > 0) {
            const new_pos: Vector2 = move.*.pop() orelse @panic("UH OH FAILED moveUnit");
            curr_position.* = new_pos;
            if (move.*.items.len == 0) {
                //Here we will set the c_state to q_state
                c_state.* = q_state.*;
                q_state.* = .IDLE;
            }
        }
    }
}

pub fn resourceInteraction(characters: MultiArraylist(Character)) void {
    //happens when player clicks on a resource
    const char_slice = characters.slice();
    for (char_slice.items(.curr_state), char_slice.items(.forestry_tool)) |state, *tool| {
        if (state == .HARVESTING) {
            tool.*.harvest_cd.tick();
        }
    }
}

//UITLS
//TODO: These is duplicated from AStar so we can find a better place or way to do it

///We'll use some arbitrary heuristic to judge the "Closest Valid Tile" this will be based on our position relative to the goal
fn findClosestTile(goal: Vector2, curr_pos: Vector2) Vector2 {
    const list = getAllNeighbours(goal);
    //Heuristic
    var dist: u32 = 999999;
    var best_pos: Vector2 = .{ .y = 0, .x = 0 };
    //For each valid tile
    for (list.items) |p| {
        const temp_dist: u32 = @abs(p.x - curr_pos.x) + @abs(p.y - curr_pos.y);
        if (temp_dist < dist) {
            dist = temp_dist;
            best_pos = p;
        }
    }
    //Check curr_pos - goal
    //figure out which takes the least moves
    // get the tile in World.tiles
    return best_pos;
}

fn getAllNeighbours(goal: Vector2) Arraylist(Vector2) {
    const move1: Vector2 = .{ .x = 1, .y = 0 };
    //    const move2: Vector2 = .{ .x = 1, .y = 1 };
    const move3: Vector2 = .{ .x = 0, .y = 1 };
    //    const move4: Vector2 = .{ .x = -1, .y = 1 };
    const move5: Vector2 = .{ .x = -1, .y = 0 };
    //    const move6: Vector2 = .{ .x = -1, .y = -1 };
    const move7: Vector2 = .{ .x = 0, .y = -1 };
    //    const move8: Vector2 = .{ .x = 1, .y = -1 };
    const moves: [4]Vector2 = .{ move1, move3, move5, move7 };
    var list: Arraylist(Vector2) = Arraylist(Vector2).init(std.heap.page_allocator);
    for (moves) |move| {
        const new_pos: Vector2 = Vector2.add(goal, move);
        if (validTile(goal, new_pos, move, World.tiles[0..])) {
            //If it is a valid tile we want to see if it is the "closest" to our chracter
            list.append(new_pos) catch std.debug.panic("Failed to add: {?} to list of neighbours", .{new_pos});
        }
    }
    return list;
}

fn validTile(curr_pos: Vector2, next_pos: Vector2, movement: Vector2, tiles: [][]TileType) bool {
    //Out of bounds check
    if ((next_pos.y > tiles.len - 1 or next_pos.x > tiles[0].len - 1) or (next_pos.x < 0 or next_pos.y < 0)) {
        return false;
    }

    //Check for non-walkable terrain
    //std.debug.print("Pos: ({?}, {?})\n", .{ next_pos.y, next_pos.x }); std.debug.print("Type: {?}\n", .{tiles[@intCast(next_pos.y)][@intCast(next_pos.x)]});
    if (tiles[@intCast(next_pos.y)][@intCast(next_pos.x)] == TileType.RESOURCE) {
        return false;
    }

    //Diagonal movement check for adjacent terrain
    if (movement.y != 0 and movement.x != 0) {
        if (tiles[@intCast(curr_pos.y + movement.y)][@intCast(curr_pos.x)] == TileType.RESOURCE and tiles[@intCast(curr_pos.y)][@intCast(curr_pos.x + movement.x)] == TileType.RESOURCE) {
            return false;
        }
    }

    return true;
}

test "finding closest tile to resource" {
    @import("init_system.zig").spawnTiles();
    World.printTiles();
    _ = findClosestTile(.{ .x = 5, .y = 5 }, .{ .x = 1, .y = 1 });
}
