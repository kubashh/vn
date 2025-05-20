const lib = @import("../lib.zig");

const util = lib.util;
const fs = lib.fs;

const log = util.log;
const print = util.print;
const Error = util.Error;

const fileExist = fs.fileExist;
const readFileAlloc = fs.readFileAlloc;

pub fn vm(path: []const u8) void {
    if (!fileExist(path)) Error("No exec file", "Expected at path {s}.", .{path});

    log("Running...");

    const file = readFileAlloc(path);
    run(file);

    // TODO read file
    // TODO run vm

    log("Done.");
}

pub inline fn run(file: []const u8) void {
    print("{s}", .{file});
}
