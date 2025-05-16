const std = @import("std");
const consts = @import("consts.zig");
const util = @import("util.zig");

const allocator = consts.allocator;
const pathConfig = consts.pathConfig;

const log = util.log;
const readFileAlloc = util.readFileAlloc;
const fileExist = util.fileExist;
const Error = util.Error;

const Config = struct { name: []const u8, version: []const u8 };

fn getConfigFileAlloc() []const u8 {
    return readFileAlloc(pathConfig) catch |err| if (err == error.FileNotFound) {
        Error("File not found", "Expected at path {s}.", .{pathConfig});
    } else {
        Error("Other", "At getConfigFileAlloc()", .{});
    };
}

pub fn getNameAlloc() []const u8 {
    const file = getConfigFileAlloc();
    defer allocator.free(file);

    if (file.len == 0)
        Error("No configuration file", "Expected at path `{s}`", .{pathConfig});

    const parsed = std.json.parseFromSlice(
        Config,
        allocator,
        file,
        .{},
    ) catch |err| {
        Error("Parse", "Cannot parse config file.\nerr: {any}", .{err});
    };
    defer parsed.deinit();

    const name = std.mem.Allocator.dupe(allocator, u8, parsed.value.name) catch |err| {
        Error("Other", "{any}", .{err});
    };
    return name;
}
