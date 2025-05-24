const lib = @import("../lib.zig");

const buildFile = @embedFile("outBuildFile.zig");

const consts = lib.consts;
const util = lib.util;
const fs = lib.fs;

const allocator = consts.allocator;
const pathOut = consts.pathOut;
const pathOutDir = consts.pathOutDir;

const Error = util.Error;

const readFileAlloc = fs.readFileAlloc;
const makeDir = fs.makeDir;
const createFile = fs.createFile;

pub inline fn emitOutFree(file: []const u8) void {
    defer allocator.free(file);

    makeDir(pathOutDir) catch {};
    createFile(pathOut, file) catch |err|
        Error("At saveOutFile()", "{any}", .{err});    

    createFile(pathOutDir ++ "/build.zig", buildFile) catch |err|
        Error("At saveOutFile()", "{any}", .{err});
}
