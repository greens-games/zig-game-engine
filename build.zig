const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    //Deps
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        .linux_display_backend = .X11,
    });

    //create module
    const module = b.addModule("engine", .{
        .root_source_file = .{ .src_path = .{
            .owner = b,
            .sub_path = "src/mod.zig",
        } },
        .target = target,
        .optimize = optimize,
    });
    _ = module;

    const lib = b.addStaticLibrary(.{
        .name = "zig-last-try",

        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "zig-last-try",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const art = raylib_dep.artifact("raylib");
    exe.linkLibrary(art);
    exe.linkLibC();
    //CLibs
    //exe.linkSystemLibrary("glfw3");
    //exe.linkSystemLibrary("gl");
    //exe.addCSourceFile(.{ .file = b.path("../../utils/glad/src/gl.c") });

    // Import the generated module.
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
