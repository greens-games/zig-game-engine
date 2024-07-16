const std = @import("std");
const MouseButton = @import("mach-glfw").MouseButton;
const Action = @import("mach-glfw").Action;
const Mods = @import("mach-glfw").Mods;

///We need consumers and producers for the queue
///This would be like an Observer type patter (Also kind of like an Event Broker)
pub const MouseEventQueueType = std.DoublyLinkedList(MouseEvent);
pub const MouseEventNode = MouseEventQueueType.Node;
pub const MouseEventBroker = struct {
    queue: MouseEventQueueType = .{},
    //Singly Linked List for consumers and produces
    //We don't need to remove often which is the main downside of SinglyLinkedLists
    consumers: std.SinglyLinkedList(EventReader(anyopaque)) = .{},
};

//Consumer
pub fn Consumer(comptime T: type) type {
    return struct {
        impl: T,
    };
}

pub fn EventReader(comptime T: type) type {
    return struct {
        owner: T,
    };
}
//Producer

const KeyEvent = struct {
    key: u8,
};

pub const MouseEvent = struct {
    button: MouseButton,
    action: Action,
    mods: Mods,
};

/// User Defined events
const UserEvent = struct {
    user_event: u8,
};

//System that consumes an event
const TestConsumer = struct {
    x: u8 = 0,
    //This will end up being a list
    event: MouseEvent = undefined,

    pub fn handle_consume(self: *TestConsumer, node: MouseEventNode) void {
        self.event = node.data;
    }
};

test "Create consumer" {
    const test_consumer: TestConsumer = .{};
    _ = test_consumer;
    var broker: MouseEventBroker = .{};
    const event: MouseEvent = .{ .mods = .{}, .button = .left, .action = .press };
    var node: MouseEventNode = .{ .data = event };
    broker.queue.append(&node);
}
