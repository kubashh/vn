const lib = @import("../lib.zig");

const util = lib.util;
const fs = lib.fs;

const log = util.log;
const Error = util.Error;

const fileExist = fs.fileExist;

pub fn vm(path: []const u8) void {
    if (!fileExist(path)) Error("No exec file", "Expected at path {s}.", .{path});

    log("Running...");

    // TODO read file
    // TODO run vm

    log("Done.");
}
