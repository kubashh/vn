const lib = @import("../lib.zig");
const bundleImportAlloc = @import("bundleImports.zig").bundleImportAlloc;

const consts = lib.consts;
const util = lib.util;
const fs = lib.fs;

const allocator = consts.allocator;
const pathMain = consts.pathMain;
const pathOut = consts.pathOut;
const pathOutDir = consts.pathOutDir;

const log = util.log;
const print = util.print;
const Error = util.Error;

const fileExist = fs.fileExist;
const createFile = fs.createFile;
const makeDir = fs.makeDir;

pub fn compiler() !void {
    if (!fileExist(pathMain)) Error("Main file not exist", "Expected at path {s}.", .{pathMain});

    log("Compiling...");

    const file = try bundleImportAlloc();
    // defer allocator.free(file);

    saveOutFile(file);

    log("Done.");
}

inline fn saveOutFile(file: []const u8) void {
    print("{s}\n", .{file});
    makeDir(pathOutDir) catch {};
    createFile(pathOut, file) catch |err|
        Error("At saveOutFile()", "{any}", .{err});
}
