const std = @import("std");
const ArrayList = std.ArrayList;

pub const Event = struct {
    data: *anyopaque,
};
var events: ArrayList(Event) = ArrayList(Event).init(std.heap.page_allocator);

//We will need a list of Events
//We will need a list of consumers of Events
//
const TestEvent = struct {
    damage: u8,
};
test "Event System Test" {
    var test_event: TestEvent = .{ .damage = 10 };
    const event: Event = .{ .data = &test_event };
    try events.append(event);

    const aligned_event: *TestEvent = @ptrCast(@alignCast(event.data));
    const copy: TestEvent = aligned_event.*;
    try std.testing.expect(copy.damage == 10);
}

//const UserEvent = struct {
//    some_data: u8,
//};

//fn consumerSystem(consumer: EventConsumer) void {
// reads for events
//}

//fn producerSystem(producer: EventProducer) void {
// add events to queue
//}
//
//Game
//{
//add(UserEvent)
//
//}
