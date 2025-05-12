const std = @import("std");
const consts = @import("lib/consts.zig");
const compiler = @import("compiler/compiler.zig");
const vm = @import("vm/vm.zig");
const utils = @import("lib/utils.zig");

const print = utils.print;
const eql = utils.eql;
const log = utils.log;

const allocator = consts.allocator;

pub fn main() !void {
    // Initialize arguments
    // Then deinitialize at the end of scope
    var argsIterator = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argsIterator.deinit();

    // Handle all arguments
    var isFirst = true;
    while (argsIterator.next()) |arg| {
        if (std.os.argv.len == 1) {
            return try dev(arg);
        } else if (!isFirst) {
            try cli(arg);
        }
        if (!isFirst) break;
        isFirst = false;
    }
}

inline fn cli(arg: []const u8) !void {
    if (eql(u8, arg, "-h")) {
        printHelp();
    } else if (eql(u8, arg, "-v")) {
        printVersion();
    } else if (eql(u8, arg, "-i")) {
        try initProject();
    } else if (eql(u8, arg, "-b")) {
        try build();
    } else if (arg[0] == '-') {
        printBadArguments();
    } else try exe(arg);
}

inline fn printHelp() void {
    log(
        \\options:
        \\no flags            run already build project
        \\run_path            first and optional argument for run path (if empty get current)
        \\-h, --help          show help
        \\-v                  get version
        \\-i                  init project
        \\-b                  build mode: build (no run)
    );
}

inline fn printVersion() void {
    print("Vir version: {s}\n", .{consts.version});
}

inline fn initProject() !void {
    // vir.json
    try createFile("vir.json",
        \\{
        \\  "version": "
    ++ consts.version ++
        \\"
        \\}
    );

    // Src
    _ = std.fs.cwd().makeDir("src") catch |err| switch (err) {
        error.PathAlreadyExists => {
            return;
        },
        else => {},
    };
    var srcDir = try std.fs.cwd().openDir(
        "src",
        .{ .iterate = true },
    );
    srcDir.close();

    _ = try createFile("src/Main.vir",
        \\constructor() {
        \\  Debug.log("Hello World!")
        \\}
        \\
    );
}

inline fn printBadArguments() void {
    log(
        \\bad argument given
        \\valid args: no arg, -h, -v, -b
    );
}

inline fn dev(arg: []const u8) !void {
    try compiler.compiler();
    print("{s}\n", .{std.os.argv[0]});
    const path = try std.fmt.allocPrint(allocator, "{s}/src/Main.vir", .{arg});
    defer allocator.free(path);
    print("{s}\n", .{path});

    try vm.vm(path);
}

inline fn build() !void {
    try compiler.compiler();
}

inline fn exe(arg: []const u8) !void {
    try vm.vm(arg);
}

fn createFile(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().createFile(
        path,
        .{},
    );
    defer file.close();
    try file.writeAll(content);
    print("info: created {s}\n", .{path});
}
