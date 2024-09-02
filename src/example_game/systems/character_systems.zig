const std = @import("std");
const Arraylist = std.ArrayList;
const rl = @import("raylib");
const Character = @import("../components/character.zig").Character;
const GridUtils = @import("../../example_game/grid/grid_utils.zig");
const Vector2 = @import("../../engine/core/types.zig").Vector2;

//TODO: Remove all instances of raylib from gameplay systems (we can use raylib stuff in input and render systems)
pub fn detectHover(characters: Arraylist(Character)) void {
    _ = characters;
}

pub fn moveCharacter(characters: Arraylist(Character)) void {
    if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left)) {
        const mouse_x = rl.getMouseX();
        const mouse_y = rl.getMouseY();
        std.debug.print("Moving character to position: ({?}, {?})\n", .{ mouse_x, mouse_y });
        for (characters.items) |*character| {
            const row_col: Vector2 = GridUtils.worldToGridCoords(mouse_x, mouse_y);
            const new_pos: Vector2 = GridUtils.gridToWorldCoords(row_col.x, row_col.y);
            character.position = new_pos;
        }
    }
}
