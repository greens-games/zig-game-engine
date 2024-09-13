const std = @import("std");
const ArrayList = std.ArrayList;
const Vector2 = @import("../core/types.zig").Vector2;

const Successor = struct {
    parent_id: i32 = 0,
    pos: Vector2,
    f: i32 = 0,
    g: i32 = 0,
    h: i32 = 0,
};

const Node = struct {
    pos: Vector2,
    f: i32 = 0,
    g: i32 = 0,
    h: i32 = 0,
};

pub fn aStar(start: Vector2, goal: Vector2) void {
    var curr_pos: Vector2 = undefined;
    _ = &curr_pos;

    var open_list: ArrayList(Node) = ArrayList(Node).init(std.heap.page_allocator);
    defer open_list.deinit();
    var close_list: ArrayList(Node) = ArrayList(Node).init(std.heap.page_allocator);
    defer close_list.deinit();

    const start_node: Node = .{ .pos = start };
    addToList(&open_list, start_node);

    while (open_list.items.len > 0) {
        //Do search stuff
        //
        const q = open_list.orderedRemove(findLowestF(open_list));

        //Generate Successors into list
        var successors = ArrayList(Successor).init(std.heap.page_allocator);
        defer successors.deinit();

        if (q.pos.eql(goal)) {
            //we reached the goal Yay time to backtrack
        }

        //getAllNeighbours (which is get all nodes that are next to this node
        //If a neighbour is in the closed list skip it (we visited it already)

        for (successors.items) |value| {
            _ = value;
            //do all successor logics
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
