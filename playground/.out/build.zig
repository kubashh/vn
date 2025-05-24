const std = @import("std");

const name = "vno";
const pathMain = "vno.zig";
const optimize = .ReleaseFast;

const targets: []const std.Target.Query = &.{
    .{ .cpu_arch = .aarch64, .os_tag = .macos },
    .{ .cpu_arch = .aarch64, .os_tag = .linux },
    .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .gnu },
    .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .musl },
    .{ .cpu_arch = .x86_64, .os_tag = .windows },
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    for (targets) |t| {
        const path = try std.fmt.allocPrint(b.allocator, "{s}{s}", .{ "../", try t.zigTriple(b.allocator) });
        // do not dealocate
        // defer b.allocator.free(path);
        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = b.path(pathMain),
            .target = b.resolveTargetQuery(t),
            .optimize = optimize,
        });

        const target_output = b.addInstallArtifact(exe, .{
            .dest_dir = .{
                .override = .{
                    .custom = path,
                },
            },
        });

        b.getInstallStep().dependOn(&target_output.step);
    }

    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path(pathMain),
        .target = target,
        .optimize = optimize,
    });

    // b.installArtifact(exe);

    const install = b.addInstallArtifact(exe, .{
        .dest_dir = .{
            .override = .{ .custom = "../bin" },
        },
    });
    b.default_step.dependOn(&install.step);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
