const std = @import("std");
const util = @import("util.zig");

const alloc = util.alloc;

pub const allocator = std.heap.page_allocator;
pub const ArgIterator = std.process.ArgIterator;
pub const os = std.os;

pub const StringHashMap = std.StringHashMap;
pub const ArrayList = std.ArrayList;

const versionFile = @embedFile("../../.version");
pub const version = getVersion();

pub const pathConfig = "vir.json";
pub const pathMain = "src/Main.vir";
pub const pathOut = ".out/viro";

fn getVersion() []const u8 {
    var lastIndex: usize = 0;
    var count: u2 = 0;
    for (versionFile, 0..) |c, i| if (c == '.') {
        lastIndex = i;
        if (count > 2) break;
        count += 1;
    };

    return versionFile[0..lastIndex];
}
