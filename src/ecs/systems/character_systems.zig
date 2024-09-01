const std = @import("std");
const Arraylist = std.ArrayList;
const rl = @import("raylib");
const Character = @import("../components/character.zig").Character;

//TODO: Remove all instances of raylib from gameplay systems (we can use raylib stuff in input and render systems)
pub fn detectHover(characters: Arraylist(Character)) void {
    const mouse_x = rl.getMouseX();
    const mouse_y = rl.getMouseY();

    for (characters.items) |character| {
        if (character.x == mouse_x) {
            if (character.y == mouse_y) {
                //check collision
            }
        }
    }
}

pub fn moveCharacter(characters: Arraylist(Character)) void {
    if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left)) {
        const mouse_x = rl.getMouseX();
        const mouse_y = rl.getMouseY();
        std.debug.print("Moving character to position: ({?}, {?})\n", .{ mouse_x, mouse_y });
        for (characters.items) |*character| {
            character.x = mouse_x;
            character.y = mouse_y;
        }
    }
}
