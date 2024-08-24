const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    //Deps
    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });
    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raygui = raylib_dep.module("raygui"); // raygui module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library

    //zigimg
    const zigimg_dependency = b.dependency("zigimg", .{
        .target = target,
        .optimize = optimize,
    });

    // Choose the OpenGL API, version, profile and extensions you want to generate bindings for.
    const gl_bindings = @import("zigglgen").generateBindingsModule(b, .{
        .api = .gl,
        .version = .@"4.6",
        .profile = .core,
        .extensions = &.{ .ARB_clip_control, .NV_scissor_exclusive },
    });

    //Mach GLFW
    const glfw_dep = b.dependency("mach_glfw", .{
        .target = target,
        .optimize = optimize,
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

    module.addImport("ziggl", gl_bindings);

    module.addImport("mach-glfw", glfw_dep.module("mach-glfw"));

    module.addImport("zigimg", zigimg_dependency.module("zigimg"));

    module.linkLibrary(raylib_artifact);
    module.addImport("raylib", raylib);
    module.addImport("raygui", raygui);

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

    //CLibs
    //exe.linkSystemLibrary("glfw3");
    //exe.linkSystemLibrary("gl");
    //exe.addCSourceFile(.{ .file = b.path("../../utils/glad/src/gl.c") });
    //exe.linkLibC();

    // Import the generated module.
    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("ziggl", gl_bindings);

    exe.root_module.addImport("mach-glfw", glfw_dep.module("mach-glfw"));

    exe.root_module.addImport("zigimg", zigimg_dependency.module("zigimg"));
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);
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

    // Choose the OpenGL API, version, profile and extensions you want to generate bindings for.
    const gl_bindings_test = @import("zigglgen").generateBindingsModule(b, .{
        .api = .gl,
        .version = .@"4.1",
        .profile = .core,
        .extensions = &.{ .ARB_clip_control, .NV_scissor_exclusive },
    });

    // Import the generated module.
    exe_unit_tests.root_module.addImport("ziggl", gl_bindings_test);

    //Mach GLFW
    const glfw_dep_test = b.dependency("mach_glfw", .{
        .target = target,
        .optimize = optimize,
    });
    exe_unit_tests.root_module.addImport("mach-glfw", glfw_dep_test.module("mach-glfw"));
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
