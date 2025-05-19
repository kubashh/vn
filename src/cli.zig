const consts = @import("lib/consts.zig");
const config = @import("lib/config.zig");
const util = @import("lib/util.zig");
const compiler = @import("compiler/compiler.zig").compiler;
const vm = @import("vm/vm.zig").vm;
const std = @import("std");

const allocator = consts.allocator;
const version = consts.version;
const pathOut = consts.pathOut;
const pathMain = consts.pathMain;

const setConfig = config.setConfig;

const print = util.print;
const eql = util.eql;
const log = util.log;
const createFile = util.createFile;
const fileExist = util.fileExist;
const makeDir = util.makeDir;
const copy = util.copy;
const Error = util.Error;

pub inline fn cli(arg: []const u8) !void {
    if (eql(arg, "-h") or eql(arg, "--help")) {
        printHelp();
    } else if (eql(arg, "version")) {
        printVersion();
    } else if (eql(arg, "init")) {
        initProject();
    } else if (eql(arg, "build")) {
        try build();
    } else if (!fileExist(arg)) {
        printBadArguments(arg);
    } else exe(arg);
}

inline fn printHelp() void {
    log(
        \\Usage: vir [command or exePath or nothing]
        \\
        \\Commands:
        \\
        \\  no_flags          Build and run project (current dir)
        \\  build             Build project (no run)
        \\
        \\  <runPath>         Optional argument for run path
        \\
        \\  init              Init project
        \\  version           Get version
        \\
        \\  -h, --help        Print help
    );
}

inline fn printVersion() void {
    print("Vir version: {s}\n", .{version});
}

inline fn initProject() void {
    const name = getProjectNameAlloc();
    defer allocator.free(name);

    // vir.json
    setConfig(.{
        .name = name,
        .version = version,
    });

    // src
    makeDir("src") catch {
        return;
    };

    // Main
    createFile(pathMain,
        \\constructor() {
        \\  Debug.log("Hello World!")
        \\}
        \\
    ) catch {};
}

fn getProjectNameAlloc() []u8 {
    const pathExe: []const u8 = std.process.getCwdAlloc(allocator) catch |err| {
        Error("Get dir", "{any}", .{err});
    };
    defer allocator.free(pathExe);

    print("{s}", .{pathExe});

    var lastIndex: usize = 0;
    for (pathExe, 0..) |c, i| {
        if (c == '/')
            lastIndex = i;
    }

    return copy(pathExe[lastIndex + 1 ..]);
}

inline fn printBadArguments(path: []const u8) void {
    printHelp();
    Error("Bad command", "No file / command: `{s}`", .{path});
}

inline fn dev() !void {
    try compiler();

    vm(pathOut);
}

inline fn build() !void {
    try compiler();
}

inline fn exe(arg: []const u8) void {
    if (!fileExist(arg)) {
        log("File not found");
    } else vm(arg);
}
