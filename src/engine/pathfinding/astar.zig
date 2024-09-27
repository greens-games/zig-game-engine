const std = @import("std");
const ArrayList = std.ArrayList;
const Vector2 = @import("../core/types.zig").Vector2;
//TODO: Remove when we have better solution for not using game specific logic here
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
    parent_index: i32 = -1,
    //Use row + col for pos
    pos: Vector2,
    f: f32 = 0,
    g: f32 = 0,
    h: f32 = 0,
};

///AStar pathfinding to find the close to most optimal path
pub fn aStar(start: Vector2, goal: Vector2, tiles: [][]TileType) ArrayList(Vector2) {
    var curr_pos: Vector2 = undefined;
    _ = &curr_pos;

    var open_list: ArrayList(Node) = ArrayList(Node).init(std.heap.page_allocator);
    defer open_list.deinit();
    var close_list: ArrayList(Node) = ArrayList(Node).init(std.heap.page_allocator);
    defer close_list.deinit();

    const start_node: Node = .{ .pos = start, .f = 0, .g = 1, .h = calcH(goal, start) };

    addToList(&open_list, start_node);
    var index: i32 = 0;
    while (open_list.items.len > 0) {
        //Do search stuff
        //
        var q = open_list.orderedRemove(findLowestF(open_list));
        addToList(&close_list, q);

        if (q.pos.eql(goal)) {
            //we reached the goal Yay time to backtrack
            //backTrack(close_list);
            break;
        }
        //Generate Successors into list
        var successors = ArrayList(Node).init(std.heap.page_allocator);
        defer successors.deinit();

        //getAllNeighbours (which is get all nodes that are next to this node
        //If a neighbour is in the closed list skip it (we visited it already)
        getAllNeighbours(&q, &successors, tiles);

        successor_loop: for (successors.items) |*successor| {
            //check if successor pos is in closed list
            for (close_list.items) |node| {
                if (successor.pos.eql(node.pos)) {
                    //we are in the close list so ignore this successor
                    continue :successor_loop;
                }
            }
            //calculate g,h,f for successor
            successor.g = q.g + calcG(start, successor.pos);
            successor.h = calcH(goal, successor.pos);
            successor.f = calcF(successor.h, successor.g);
            //check if successor pos is in open list
            for (open_list.items) |*node| {
                if (successor.pos.eql(node.pos)) {
                    if (successor.g < node.g and successor.f < node.f and successor.h < node.h) {
                        node.g = successor.g;
                        node.h = successor.h;
                        node.f = successor.f;
                        node.parent_index = successor.parent_index;
                        continue :successor_loop;
                    }
                }
            }
            successor.parent_index = index;
            const finalNode: Node = successor.*;
            addToList(&open_list, finalNode);
        }

        index += 1;
    }
    return reverseList(backTrack(close_list));
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
        const new_pos: Vector2 = Vector2.add(parent.pos, move);
        if (validTile(parent.pos, new_pos, move, tiles[0..])) {
            const node: Node = .{ .pos = new_pos };
            addToList(neighbour_list, node);
            //std.debug.print("First in Neighbour list {?}; current parent {?}; size of neightbour list {?}; current node: {?}\n", .{ neighbour_list.items[0], parent, neighbour_list.items.len, node });
        }
    }
}

fn validTile(curr_pos: Vector2, next_pos: Vector2, movement: Vector2, tiles: [][]TileType) bool {
    //Out of bounds check
    if ((next_pos.y > tiles.len - 1 or next_pos.x > tiles[0].len - 1) or (next_pos.x < 0 or next_pos.y < 0)) {
        return false;
    }

    //Check for non-walkable terrain
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

fn calcF(h: f32, g: f32) f32 {
    return h + g;
}
fn calcG(start_pos: Vector2, move_pos: Vector2) f32 {
    _ = start_pos;
    _ = move_pos;
    return 1.0;
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
    var smallest: f32 = 100000.0;
    var current_index: usize = 0;
    for (list.items, 0..) |value, i| {
        if (value.f < smallest) {
            current_index = i;
            smallest = value.f;
        }
    }
    return current_index;
}

fn backTrack(list: ArrayList(Node)) ArrayList(Vector2) {
    var curr_node: Node = list.items[list.items.len - 1];
    var ret_list = ArrayList(Vector2).init(std.heap.page_allocator);

    var i: usize = 100;
    _ = &i;

    //for (list.items) |item| { std.debug.print("Node: {?} Parent: {?}\n", .{ item.pos, item.parent_index }); }
    while (curr_node.parent_index >= 0) {
        std.debug.print("POS: {?} \n", .{curr_node.pos});
        //std.debug.print("POS: {?} \n", .{curr_node.parent_index});
        ret_list.append(curr_node.pos) catch @panic("Failed to add character to list of current nodes");
        curr_node = list.items[@intCast(curr_node.parent_index)];
    }

    return ret_list;
}

fn reverseList(list: ArrayList(Vector2)) ArrayList(Vector2) {
    var index: usize = list.items.len - 1;
    var new_list: ArrayList(Vector2) = ArrayList(Vector2).init(std.heap.page_allocator);

    while (index > 0) {
        new_list.append(list.items[index]) catch @panic("Failed reversing list");
        std.debug.print("POS REVERSED: {?} \n", .{list.items[index]});
        index -= 1;
    }

    new_list.append(list.items[index]) catch @panic("Failed reversing list");
    return new_list;
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

//test "Get all neighbours" {
//    var list = ArrayList(Node).init(std.testing.allocator);
//    defer list.deinit();
//
//    var tiles: [6][]TileType = undefined;
//
//    for (&tiles) |*slice| {
//        slice.* = try std.testing.allocator.alloc(TileType, 6);
//        slice.ptr[0] = .GROUD;
//        slice.ptr[1] = .GROUD;
//        slice.ptr[2] = .GROUD;
//        slice.ptr[3] = .GROUD;
//        slice.ptr[4] = .GROUD;
//        slice.ptr[5] = .GROUD;
//    }
//
//    defer {
//        for (&tiles) |slice| {
//            std.testing.allocator.free(slice);
//        }
//    }
//
//    tiles[0][0] = .RESOURCE;
//    tiles[2][2] = .RESOURCE;
//
//    var node: Node = .{ .pos = .{ .x = 1, .y = 1 } };
//
//    try std.testing.expect(tiles[0][0] == TileType.RESOURCE);
//    getAllNeighbours(&node, &list, tiles[0..]);
//    std.debug.print("Neighbours: {?}\n", .{list.items.len});
//
//    try std.testing.expect(list.items.len == 6);
//}
//
//test "AStar" { var list = ArrayList(Node).init(std.testing.allocator); defer list.deinit(); var tiles: [5][]TileType = undefined; for (&tiles) |*slice| { slice.* = try std.testing.allocator.alloc(TileType, 5); slice.ptr[0] = .GROUD; slice.ptr[1] = .GROUD; slice.ptr[2] = .GROUD; slice.ptr[3] = .GROUD; slice.ptr[4] = .GROUD; } defer { for (&tiles) |slice| { std.testing.allocator.free(slice); } } tiles[2][2] = .RESOURCE; const start: Vector2 = .{ .x = 0, .y = 0 }; const end: Vector2 = .{ .y = 2, .x = 1 }; aStar(start, end, tiles[0..]); }

//TODO: this path goes from 2,1 to 2,0 which is inefficient we would want to not go to 2,1 first
test "AStar complex path" {
    var list = ArrayList(Node).init(std.testing.allocator);
    defer list.deinit();
    var tiles: [5][]TileType = undefined;
    for (&tiles) |*slice| {
        slice.* = try std.testing.allocator.alloc(TileType, 5);
        slice.ptr[0] = .GROUD;
        slice.ptr[1] = .GROUD;
        slice.ptr[2] = .GROUD;
        slice.ptr[3] = .GROUD;
        slice.ptr[4] = .GROUD;
    }
    defer {
        for (&tiles) |slice| {
            std.testing.allocator.free(slice);
        }
    }
    tiles[1][0] = .RESOURCE;
    tiles[1][1] = .RESOURCE;
    tiles[1][3] = .RESOURCE;
    tiles[2][2] = .RESOURCE;
    tiles[3][3] = .RESOURCE;
    const start: Vector2 = .{ .x = 0, .y = 0 };
    const end: Vector2 = .{ .y = 4, .x = 4 };
    _ = aStar(start, end, tiles[0..]);

    //for (new_list.items) |pos| { std.debug.print("POS REVERSED: {?} \n", .{pos}); }
}
