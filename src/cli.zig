const lib = @import("lib.zig");
const compiler = @import("compiler/compiler.zig").compiler;

const consts = lib.consts;
const config = lib.config;
const util = lib.util;
const fs = lib.fs;

const allocator = consts.allocator;
const version = consts.version;
const pathOut = consts.pathOut;
const pathMain = consts.pathMain;

const setConfig = config.setConfig;

const print = util.print;
const eql = util.eql;
const log = util.log;
const copyAlloc = util.copyAlloc;
const Error = util.Error;

const createFile = fs.createFile;
const getCwdAlloc = fs.getCwdAlloc;
const makeDir = fs.makeDir;

pub inline fn cli(arg: []const u8) void {
    if (eql(arg, "-h") or eql(arg, "--help")) {
        printHelp();
    } else if (eql(arg, "version")) {
        printVersion();
    } else if (eql(arg, "init")) {
        initProject();
    } else if (eql(arg, "build")) {
        build();
    } else printBadArguments(arg);
}

inline fn printHelp() void {
    log(
        \\Usage: vn [command or nothing]
        \\
        \\Commands:
        \\
        \\  <no_flags>        Build and run project (current dir)
        \\  build             Build project (no run)
        \\
        \\  init              Init project
        \\  version           Print version
        \\
        \\  -h, --help        Print help
    );
}

inline fn printVersion() void {
    print("Vn version: {s}\n", .{version});
}

inline fn initProject() void {
    const name = getProjectNameAlloc();
    defer allocator.free(name);

    // vn.json
    setConfig(.{
        .name = name,
        .version = version,
    });

    // src
    makeDir("src") catch {};

    // Main
    createFile(pathMain,
        \\constructor() {
        \\    print("Hello World!")
        \\}
        \\
    ) catch {};
}

inline fn getProjectNameAlloc() []u8 {
    const pathExe = getCwdAlloc();
    defer allocator.free(pathExe);

    var lastIndex: usize = 0;
    for (pathExe, 0..) |c, i| {
        if (c == '/')
            lastIndex = i;
    }

    return copyAlloc(pathExe[lastIndex + 1 ..]);
}

inline fn printBadArguments(path: []const u8) void {
    printHelp();
    Error("Bad command", "No file / command: `{s}`", .{path});
}

inline fn build() void {
    compiler();
}
