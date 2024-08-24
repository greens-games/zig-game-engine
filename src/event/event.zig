const std = @import("std");
const ArrayList = std.ArrayList;
const MouseButton = @import("mach-glfw").MouseButton;
const Action = @import("mach-glfw").Action;
const Mods = @import("mach-glfw").Mods;
const Key = @import("mach-glfw").Key;

///We have a list of events
///When an event happens some writer writes to the list
///We will have some sort of broker that takes events in the list and sends the data to all consumers
///We will need a list of consumers to keep track of
///This means we can pop from the list and keep it small
///Should work regardless of the data structure we use (Arraylist vs LInked list)
pub var MouseEventList: ArrayList(MouseEvent) = ArrayList(MouseEvent).init(std.heap.page_allocator);
pub var MouseConsumerList = ArrayList(*MouseEventsConsumer).init(std.heap.page_allocator);

//Consumer
pub const KeyEventConsumer = struct {
    event: KeyEvent = undefined,
};

const MouseEventBroker = struct {
    fn poll_events() void {
        while (true) {
            if (MouseEventList.items.len > 0) {
                //Check for lock
                //Lock list
                //pop front event
                const curr_event: MouseEvent = popFront();
                //unlock list
                //Send front event to consumers
                for (MouseConsumerList.items) |item| {
                    item.receive(curr_event);
                }
            }
        }
    }
};

pub const MouseEventsConsumer = struct {
    events: ArrayList(MouseEvent) = ArrayList(MouseEvent).init(std.heap.page_allocator),

    fn receive(self: *MouseEventsConsumer, event: MouseEvent) !void {
        try self.events.append(event);
    }
};

pub fn popFront() MouseEvent {
    return MouseEventList.orderedRemove(0);
}

const KeyEvent = struct {
    key: Key,
    scancode: i32,
    action: Action,
    mods: Mods,
};

pub const MouseEvent = struct {
    button: MouseButton,
    action: Action,
    mods: Mods,
};

test "Add event" {
    const test_event = MouseEvent{
        .mods = .{},
        .action = .press,
        .button = .left,
    };

    try MouseEventList.append(test_event);

    const ret_event = popFront();

    try std.testing.expect(ret_event.button == .left);
    try std.testing.expect(ret_event.button != .right);
}

test "Add Consumer" {
    var test_consumer: MouseEventsConsumer = .{};
    try MouseConsumerList.append(&test_consumer);
    try std.testing.expect(MouseConsumerList.items.len == 1);
}

test "Consume Events" {
    const test_event = MouseEvent{
        .mods = .{},
        .action = .press,
        .button = .left,
    };

    try MouseEventList.append(test_event);

    const ret_event = popFront();

    var test_consumer: MouseEventsConsumer = .{};
    try MouseConsumerList.append(&test_consumer);

    try test_consumer.receive(ret_event);

    var expected_event: MouseEvent = undefined;
    if (test_consumer.events.items.len > 0) {
        expected_event = test_consumer.events.pop();
    }
    try std.testing.expect(test_consumer.events.items.len == 0);
    try std.testing.expect(test_event.button == .left);
}

test "has decl" {
    const mouseBroker: MouseEventBroker = .{};
    try std.testing.expect(@hasDecl(@TypeOf(mouseBroker), "poll_events"));
}
