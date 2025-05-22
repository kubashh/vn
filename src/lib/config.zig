const std = @import("std");
const consts = @import("consts.zig");
const util = @import("util.zig");
const fs = @import("fs.zig");

const allocator = consts.allocator;
const pathConfig = consts.pathConfig;

const readFileAlloc = util.readFileAlloc;
const Error = util.Error;
const copyAlloc = util.copyAlloc;

const saveStringifyJson = fs.saveStringifyJson;

const ConfigShape = struct { name: []const u8, version: []const u8 };

pub const Config = struct {
    name: []u8,
    version: []u8,

    pub fn init() Config {
        const file = getConfigFileAlloc();
        defer allocator.free(file);

        const parsed = parseJsonInit(ConfigShape, file);
        defer parsed.deinit();

        return Config{
            .name = copyAlloc(parsed.value.name),
            .version = copyAlloc(parsed.value.version),
        };
    }

    pub fn deinit(self: *const Config) void {
        allocator.free(self.name);
        allocator.free(self.version);
    }
};

inline fn getConfigFileAlloc() []const u8 {
    const file = readFileAlloc(pathConfig);

    if (file.len == 0)
        Error("No configuration file", "Expected at path `{s}`", .{pathConfig});

    return file;
}

inline fn parseJsonInit(comptime T: type, file: []const u8) std.json.Parsed(T) {
    return std.json.parseFromSlice(
        T,
        allocator,
        file,
        .{},
    ) catch |err|
        Error("Cannot parse config file", "{any}", .{err});
}

pub inline fn setConfig(newConfig: ConfigShape) void {
    saveStringifyJson(pathConfig, newConfig);
}
