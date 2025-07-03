const rl = @cImport({
    @cInclude("raylib.h");
});
///Shapes as sprites rahter than images
pub const GeometricSprite = struct {
    x: u32,
    y: u32,
    color: rl.Color,
};
