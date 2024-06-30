const gl = @import("ziggl");

pub const ColourStuff = struct {
    r: f32,
    g: f32,
    b: f32,
    r_change: f32,
    g_change: f32,
    b_change: f32,
};

pub fn colour_magic(colour_loc: c_int, colour_stuff: *ColourStuff) void {
    if (colour_stuff.r >= 1.0) {
        colour_stuff.r_change = -0.02;
    } else if (colour_stuff.r <= 0.0) {
        colour_stuff.r_change = 0.02;
    }

    if (colour_stuff.g >= 1.0) {
        colour_stuff.g_change = -0.02;
    } else if (colour_stuff.g <= 0.0) {
        colour_stuff.g_change = 0.02;
    }

    if (colour_stuff.b >= 1.0) {
        colour_stuff.b_change = -0.02;
    } else if (colour_stuff.b <= 0.0) {
        colour_stuff.b_change = 0.02;
    }

    gl.Uniform4f(colour_loc, colour_stuff.r, colour_stuff.g, colour_stuff.b, 1.0);
    colour_stuff.r += colour_stuff.r_change;
    colour_stuff.g += colour_stuff.g_change;
    colour_stuff.b += colour_stuff.b_change;
}
