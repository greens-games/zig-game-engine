const std = @import("std");
const ArrayList = std.ArrayList;
const Vector2 = @import("../core/types.zig").Vector2;
//TODO: Remove when we have better solution
const TileType = @import("../../example_game/components/tile.zig").TileType;
const GridUtils = @import("../../example_game/grid/grid_utils.zig");

const Successor = struct {
    parent_id: i32 = 0,
    pos: Vector2,
    f: i32 = 0,
    g: i32 = 0,
    h: i32 = 0,
};

const Node = struct {
    parent_node: *Node = undefined,
    //Use row + col for pos
    pos: Vector2,
    movement: Vector2 = undefined,
    f: i32 = 0,
    g: i32 = 0,
    h: f32 = 0,
};

///AStar pathfinding to find the close to most optimal path
pub fn aStar(start: Vector2, goal: Vector2, tiles: [][]TileType) void {
    var curr_pos: Vector2 = undefined;
    _ = &curr_pos;

    var open_list: ArrayList(Node) = ArrayList(Node).init(std.heap.page_allocator);
    defer open_list.deinit();
    var close_list: ArrayList(Node) = ArrayList(Node).init(std.heap.page_allocator);
    defer close_list.deinit();

    const start_node: Node = .{ .pos = start, .f = 0, .g = 1, .h = calcH(goal, start) };

    addToList(&open_list, start_node);
    while (open_list.items.len > 0) {
        //Do search stuff
        //
        var q = open_list.orderedRemove(findLowestF(open_list));

        addToList(&close_list, q);

        if (q.pos.eql(goal)) {
            //we reached the goal Yay time to backtrack
        }
        //Generate Successors into list
        var successors = ArrayList(Node).init(std.heap.page_allocator);
        defer successors.deinit();

        //getAllNeighbours (which is get all nodes that are next to this node
        //If a neighbour is in the closed list skip it (we visited it already)
        getAllNeighbours(&q, &successors, tiles);

        for (successors.items) |value| {
            _ = value;
            //do all successor logics
        }
    }
}

fn getAllNeighbours(parent: *Node, neighbour_list: *ArrayList(Node), tiles: [][]TileType) void {
    const move1: Vector2 = .{ .x = 1, .y = 0 };
    const move2: Vector2 = .{ .x = 1, .y = 1 };
    const move3: Vector2 = .{ .x = 0, .y = 1 };
    const move4: Vector2 = .{ .x = -1, .y = 1 };
    const move5: Vector2 = .{ .x = -1, .y = 0 };
    const move6: Vector2 = .{ .x = -1, .y = -1 };
    const move7: Vector2 = .{ .x = 0, .y = -1 };
    const move8: Vector2 = .{ .x = 1, .y = -1 };
    const moves: [8]Vector2 = .{ move1, move2, move3, move4, move5, move6, move7, move8 };

    for (moves) |move| {
        const converted_pos = GridUtils.worldToGridCoords(parent.pos.x, parent.pos.y);
        const new_pos: Vector2 = Vector2.add(converted_pos, move);
        if (tiles[@intCast(new_pos.x)][@intCast(new_pos.y)] != TileType.RESOURCE) {
            const node: Node = .{ .parent_node = parent, .pos = new_pos, .movement = move };
            addToList(neighbour_list, node);
        }
    }
}

fn calcF(h: i32, g: i32) i32 {
    return h + g;
}
fn calcG(start_pos: Vector2, move_pos: Vector2) i32 {
    _ = start_pos;
    _ = move_pos;
    return 1;
}
fn calcH(goal_pos: Vector2, move_pos: Vector2) f32 {
    //Diagonal
    const dx: f32 = @abs(@as(f32, @floatFromInt(move_pos.x)) - @as(f32, @floatFromInt(goal_pos.x)));
    const dy: f32 = @abs(@as(f32, @floatFromInt(move_pos.y)) - @as(f32, @floatFromInt(goal_pos.y)));

    const D = 1;
    const D2 = @sqrt(2.0);

    const h: f32 = D * (dx + dy) + (D2 - 2 * D) * @min(dx, dy);
    //Euclidean
    //const h:f32 = @sqrt(2 * (move_pos.x - goal_pos.x) + 2 * (move_pos.y - goal_pos.y));

    return h;
}

fn addToList(list: *ArrayList(Node), item: Node) void {
    list.append(item) catch @panic("Failed to add item to list");
}

//O(n) always because we need to look at every node added
fn findLowestF(list: ArrayList(Node)) usize {
    var smallest: i32 = 100000;
    var current_index: usize = 0;
    for (list.items, 0..) |value, i| {
        if (value.f < smallest) {
            current_index = i;
            smallest = value.f;
        }
    }
    return current_index;
}

test "Find lowest F" {
    var close_list: ArrayList(Node) = ArrayList(Node).init(std.testing.allocator);
    defer close_list.deinit();

    const n1: Node = .{ .f = 5, .pos = .{ .x = 0, .y = 0 } };
    const n2: Node = .{ .f = 3, .pos = .{ .x = 0, .y = 0 } };
    const n3: Node = .{ .f = 1, .pos = .{ .x = 0, .y = 0 } };
    const n4: Node = .{ .f = 30, .pos = .{ .x = 0, .y = 0 } };
    addToList(&close_list, n1);
    addToList(&close_list, n2);
    addToList(&close_list, n3);
    addToList(&close_list, n4);

    const index: usize = findLowestF(close_list);

    try std.testing.expect(index == 2);
}

test "Cacl H" {
    const move: Vector2 = .{ .y = 1, .x = 1 };
    const goal: Vector2 = .{ .y = 8, .x = 8 };

    _ = calcH(goal, move);
}

test "Get all neighbours" {
    var list = ArrayList(Node).init(std.testing.allocator);
    defer list.deinit();

    var tiles: [6][]TileType = undefined;

    for (&tiles) |*slice| {
        slice.* = try std.testing.allocator.alloc(TileType, 6);
        slice.ptr[0] = .GROUD;
        slice.ptr[1] = .GROUD;
        slice.ptr[2] = .GROUD;
        slice.ptr[3] = .GROUD;
        slice.ptr[4] = .GROUD;
        slice.ptr[5] = .GROUD;
    }

    defer {
        for (&tiles) |slice| {
            std.testing.allocator.free(slice);
        }
    }

    tiles[0][0] = .RESOURCE;
    tiles[2][2] = .RESOURCE;

    var node: Node = .{ .pos = .{ .x = 32, .y = 32 } };

    try std.testing.expect(tiles[0][0] == TileType.RESOURCE);
    getAllNeighbours(&node, &list, tiles[0..]);

    try std.testing.expect(list.items.len == 6);
}
