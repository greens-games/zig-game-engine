const std = @import("std");
const ArrayList = std.ArrayList;
const KeyButton = @import("mach-glfw").MouseButton;
const Action = @import("mach-glfw").Action;
const Mods = @import("mach-glfw").Mods;
const Key = @import("mach-glfw").Key;

var key_event_list: ArrayList(KeyEvent) = ArrayList(KeyEvent).init(std.heap.page_allocator);
var key_consumer_list: ArrayList(*KeyEventConsumer) = ArrayList(*KeyEventConsumer).init(std.heap.page_allocator);
var key_producer_list: ArrayList(*KeyEventProducer) = ArrayList(*KeyEventProducer).init(std.heap.page_allocator);
fn update() void {
    for (key_producer_list.items) |producer| {
        if (producer.events.items.len >= 0) {
            while (producer.events.popOrNull()) |event| {
                key_event_list.append(event) catch std.debug.panic("Failed to add event {?}\n", .{event});
            }
        }
    }
    if (key_event_list.items.len > 0) {
        //Check for lock
        //Lock list
        //check if any producer has an event
        //pop front event
        //This is temp eventually we would loop through all events and push them to consumers
        const curr_event: KeyEvent = popFront();
        //unlock list
        //Send front event to consumers
        std.debug.print("Current event: {}\n", .{curr_event.key});
        for (key_consumer_list.items) |item| {
            item.receive(curr_event) catch std.debug.panic("Failed to add event {?}\n", .{item});
        }
    }
}

fn popFront() KeyEvent {
    return key_event_list.orderedRemove(0);
}

//We need to be able to:
//Create a system that has a Conusmer or Producer property
//Add those to the associated list of the EventSystem (comptime?)
//Then those systems can call the receive/write functions in their updates

pub const KeyEventConsumer = struct {
    events: ArrayList(KeyEvent) = ArrayList(KeyEvent).init(std.heap.page_allocator),

    fn init(self: *KeyEventConsumer) !void {
        try key_consumer_list.append(self);
    }

    fn receive(self: *KeyEventConsumer, event: KeyEvent) !void {
        try self.events.append(event);
    }
};

pub const KeyEventProducer = struct {
    events: ArrayList(KeyEvent) = ArrayList(KeyEvent).init(std.heap.page_allocator),

    fn init(self: *KeyEventProducer) !void {
        try key_producer_list.append(self);
    }

    fn write(self: *KeyEventProducer, event: KeyEvent) !void {
        try self.events.append(event);
    }
};

pub const KeyEvent = struct {
    key: Key,
    scancode: i32,
    action: Action,
    mods: Mods,
};

test "other systems init" {
    var producer: KeyEventProducer = .{};
    producer.init() catch @panic("failed to initialize producer");

    var consumer: KeyEventConsumer = .{};
    consumer.init() catch @panic("failed to initialize consumer");

    try std.testing.expect(producer.events.items.len == 0);
    try std.testing.expect(consumer.events.items.len == 0);

    const event: KeyEvent = .{ .key = .a, .action = .press, .scancode = 0, .mods = .{} };
    try producer.write(event);

    try std.testing.expect(producer.events.items.len == 1);
    update();

    try std.testing.expect(producer.events.items.len == 0);
    try std.testing.expect(consumer.events.items.len == 1);
}
