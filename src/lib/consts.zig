const std = @import("std");

pub const allocator = std.heap.page_allocator;
pub const ArgIterator = std.process.ArgIterator;
pub const os = std.os;

pub const StringHashMap = std.StringHashMap;
pub const ArrayList = std.ArrayList;

pub const version = "0.0.0";

pub const pathConfig = "vir.json";
pub const pathMain = "src/Main.vir";
pub const pathOut = ".out/viro";
