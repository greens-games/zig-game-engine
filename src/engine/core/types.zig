pub const Vector2 = struct {
    x: i32,
    y: i32,

    pub fn eql(self: Vector2, compare: Vector2) bool {
        return self.x == compare.x and self.y == compare.y;
    }
};
