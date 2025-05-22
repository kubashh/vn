const std = @import("std");
const util = @import("util.zig");

const StringHashMap = std.StringHashMap;

const alloc = util.alloc;

pub const allocator = std.heap.page_allocator;
pub const os = std.os;

pub const ArrayList = std.ArrayList;
pub const SplitIterator = std.mem.SplitIterator(u8, .any);

pub const SSHashMap = StringHashMap([]const u8);

const versionFile = @embedFile("../../.version");
pub const version = getVersion();

pub const pathConfig = "vir.json";
pub const pathMain = "src/Main.vir";
pub const pathOutDir = ".out";
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
