const std = @import("std");

pub const allocator = std.heap.page_allocator;
pub const ArgIterator = std.process.ArgIterator;
pub const os = std.os;

pub const StringHashMap = std.StringHashMap;
pub const ArrayList = std.ArrayList;

pub const version = "0.0.0";

pub const configPath = "vir.json";
pub const mainPath = "src/Main.vir";
pub const outPath = ".out/";

// const ConfigShape = struct {
//     name: []const u8,
//     version: []const u8,
//     pub fn init(self: *ConfigShape, args: ConfigShape) void {
//         self.name = args.name;
//     }
// };
// pub const config = ConfigShape{ .name = "", .version = "" };
