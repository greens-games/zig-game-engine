const std = @import("std");
const Arraylist = std.ArrayList;
const rl = @import("raylib");
const Character = @import("../components/character.zig").Character;

pub fn detect_hover(characters: Arraylist(*Character)) void {
    const mouse_x = rl.getMouseX();
    const mouse_y = rl.getMouseY();

    std.debug.print("Mouse: ({?}, {?})\n", .{ mouse_x, mouse_y });
    for (characters.items) |character| {
        if (character.x == mouse_x) {
            if (character.y == mouse_y) {
                std.debug.print("Entered character at Character: ({?}, {?})\n", .{ character.x, character.y });
            }
        }
    }
}
