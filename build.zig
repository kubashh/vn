const std = @import("std");

const name = "vn";
const pathMain = "main.zig";
const optimize = .ReleaseFast; // .ReleaseSafe

const targets: []const std.Target.Query = &.{
    .{ .cpu_arch = .aarch64, .os_tag = .macos },
    .{ .cpu_arch = .aarch64, .os_tag = .linux },
    .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .gnu },
    .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .musl },
    .{ .cpu_arch = .x86_64, .os_tag = .windows },
};

pub fn build(b: *std.Build) !void {
    if (b.args != null) {
        try buildCrossPlatform(b);
    } else devMode(b);
}

inline fn buildCrossPlatform(b: *std.Build) !void {
    for (targets) |t| {
        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = b.path(pathMain),
            .target = b.resolveTargetQuery(t),
            .optimize = optimize,
        });

        const target_output = b.addInstallArtifact(exe, .{
            .dest_dir = .{
                .override = .{
                    .custom = try t.zigTriple(b.allocator),
                },
            },
        });

        b.getInstallStep().dependOn(&target_output.step);
    }
}

inline fn devMode(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    // Build an executable
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path(pathMain),
        .target = target,
        .optimize = optimize,
    });

    // Installed into the standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);
}
