pub const Vector2 = struct {
    x: i32,
    y: i32,

    pub fn eql(self: Vector2, compare: Vector2) bool {
        return self.x == compare.x and self.y == compare.y;
    }

    pub fn add(self: Vector2, compare: Vector2) Vector2 {
        return Vector2{ .x = self.x + compare.x, .y = self.y + compare.y };
    }

    pub fn subtract(self: Vector2, compare: Vector2) Vector2 {
        return Vector2{ .x = self.x - compare.x, .y = self.y - compare.y };
    }

    pub fn multiply(self: Vector2, compare: Vector2) Vector2 {
        return Vector2{ .x = self.x * compare.x, .y = self.y * compare.y };
    }

    pub fn divide(self: Vector2, compare: Vector2) Vector2 {
        return Vector2{ .x = self.x / compare.x, .y = self.y / compare.y };
    }

    pub fn add_scalar(self: Vector2, scalar: i32) Vector2 {
        return Vector2{ .x = self.x + scalar, .y = self.y + scalar };
    }
};
