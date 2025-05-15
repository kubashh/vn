const consts = @import("lib/consts.zig");
const util = @import("lib/util.zig");
const compiler = @import("compiler/compiler.zig").compiler;
const vm = @import("vm/vm.zig").vm;

const version = consts.version;
const outPath = consts.outPath;
const configPath = consts.configPath;
const mainPath = consts.mainPath;

const print = util.print;
const eql = util.eql;
const log = util.log;
const createFile = util.createFile;
const fileExist = util.fileExist;
const makeDir = util.makeDir;

pub inline fn cli(arg: []const u8) !void {
    if (eql(arg, "-h") or eql(arg, "--help")) {
        printHelp();
    } else if (eql(arg, "version")) {
        printVersion();
    } else if (eql(arg, "init")) {
        try initProject();
    } else if (eql(arg, "build")) {
        try build();
    } else if (!fileExist(arg)) {
        printBadArguments(arg);
    } else exe(arg);
}

inline fn printHelp() void {
    log(
        \\Usage: vir [command or exePath]
        \\
        \\Commands:
        \\
        \\  no_flags            Build and run project (current dir)
        \\  build               Build project (no run)
        \\
        \\  <runPath>           Optional argument for run path
        \\
        \\  init                Init project
        \\  version             Get version
        \\
        \\  -h, --help          Print help
    );
}

inline fn printVersion() void {
    print("Vir version: {s}\n", .{version});
}

inline fn initProject() !void {
    // getNameInitProject("");

    // vir.json
    try createFile(configPath,
        \\{
        \\  "name": "
    ++ "name" ++
        \\"
        \\  "version": "
    ++ version ++
        \\"
        \\}
    );

    // src
    makeDir("src") catch |err| switch (err) {
        error.PathAlreadyExists => {
            return;
        },
        else => {},
    };

    // Main
    try createFile(mainPath,
        \\constructor() {
        \\  Debug.log("Hello World!")
        \\}
        \\
    );
}

inline fn printBadArguments(path: []const u8) void {
    printHelp();
    print(
        \\
        \\error: no file / command: `{s}`
        \\
    , .{path});
}

inline fn dev() !void {
    try compiler();

    vm(outPath ++ "viro");
}

inline fn build() !void {
    try compiler();
}

inline fn exe(arg: []const u8) void {
    if (!fileExist(arg)) {
        log("File not found");
    } else vm(arg);
}
