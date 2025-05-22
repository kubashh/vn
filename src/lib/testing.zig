const std = @import("std");
const config = @import("config.zig");
const util = @import("util.zig");
const fs = @import("fs.zig");

const expect = std.testing.expect;

test "config" {
    try expect(util.eql("asdf", "asdf"));
    _ = config.Config;
}

test "util" {
    try expect(util.eql("asdf", "asdf"));
    _ = util.split;
    _ = util.log;
    _ = util.logv;
    _ = util.Error;
    _ = util.joinAlloc;
    _ = util.formatAlloc;
    _ = util.alloc;
    _ = util.copyAlloc;
    _ = util.parseJsonAlloc;
    _ = util.getFirstArgAlloc;
    _ = util.sh;
}

test "fs" {
    _ = fs.makeDir;
    _ = fs.fileExist;
    _ = fs.readFileAlloc;
    _ = fs.createFile;
    _ = fs.getCwdAlloc;
    _ = fs.saveStringifyJson;
}
