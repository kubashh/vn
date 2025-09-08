const std = @import("std");
const util = @import("util.zig");

const StringHashMap = std.StringHashMap;

const alloc = util.alloc;

pub const allocator = std.heap.page_allocator;
pub const os = std.os;

pub const ArrayList = std.ArrayList;
pub const SplitIterator = std.mem.SplitIterator(u8, .any);

pub const SSHashMap = StringHashMap([]const u8);

pub const version = "0.0.4";

pub const pathConfig = "vn.json";
pub const pathMain = "src/Main.vn";
pub const pathOutDir = ".out";
pub const pathOut = ".out/vno.zig";
