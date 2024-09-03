const std = @import("std");
const ArrayList = std.ArrayList;
const KeyButton = @import("mach-glfw").MouseButton;
const Action = @import("mach-glfw").Action;
const Mods = @import("mach-glfw").Mods;
const Key = @import("mach-glfw").Key;
const TileClickEvent = @import("../components/tile_events.zig").TileClickEvent;
const TileType = @import("../../example_game/components/tile.zig").TileType;

var key_event_list: ArrayList(TileClickEvent) = ArrayList(TileClickEvent).init(std.heap.page_allocator);

//If the consumer and producers are not Pointers once we add an item to their event lists when we iterate through them there is nothing in the list. Not sure why yet
var key_consumer_list: ArrayList(*TileClickEventConsumer) = ArrayList(*TileClickEventConsumer).init(std.heap.page_allocator);
var key_producer_list: ArrayList(*TileClickEventProducer) = ArrayList(*TileClickEventProducer).init(std.heap.page_allocator);
pub fn update(self: @This()) void {
    _ = self;
    for (key_producer_list.items) |producer| {
        if (producer.events.items.len > 0) {
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
        const curr_event: TileClickEvent = popFront();
        //unlock list
        //Send front event to consumers
        for (key_consumer_list.items) |item| {
            item.receive(curr_event) catch std.debug.panic("Failed to add event {?}\n", .{item});
        }
    }
}

fn popFront() TileClickEvent {
    return key_event_list.orderedRemove(0);
}

//We need to be able to:
//Create a system that has a Conusmer or Producer property
//Add those to the associated list of the EventSystem (comptime?)
//Then those systems can call the receive/write functions in their updates

pub const TileClickEventConsumer = struct {
    events: ArrayList(TileClickEvent) = ArrayList(TileClickEvent).init(std.heap.page_allocator),

    fn init(self: *TileClickEventConsumer) !void {
        try key_consumer_list.append(self);
    }

    fn receive(self: *TileClickEventConsumer, event: TileClickEvent) !void {
        try self.events.append(event);
    }
};

pub const TileClickEventProducer = struct {
    events: ArrayList(TileClickEvent) = ArrayList(TileClickEvent).init(std.heap.page_allocator),

    pub fn init(self: *TileClickEventProducer) !void {
        try key_producer_list.append(self);
    }

    pub fn write(self: *TileClickEventProducer, event: TileClickEvent) !void {
        try self.events.append(event);
    }
};

test "other systems init" {
    var producer: TileClickEventProducer = .{};
    producer.init() catch @panic("failed to initialize producer");

    var consumer: TileClickEventConsumer = .{};
    consumer.init() catch @panic("failed to initialize consumer");

    try std.testing.expect(producer.events.items.len == 0);
    try std.testing.expect(consumer.events.items.len == 0);

    const event: TileClickEvent = .{ .col = 1, .row = 2, .tile_type = TileType.GROUD };
    try producer.write(event);

    try std.testing.expect(producer.events.items.len == 1);
    update();

    try std.testing.expect(producer.events.items.len == 0);
    try std.testing.expect(consumer.events.items.len == 1);
}
