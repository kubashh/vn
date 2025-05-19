const std = @import("std");
const consts = @import("consts.zig");
const util = @import("util.zig");

const allocator = consts.allocator;
const pathConfig = consts.pathConfig;

const readFileAlloc = util.readFileAlloc;
const Error = util.Error;
const copy = util.copy;
const createFile = util.createFile;
const formatAlloc = util.formatAlloc;
const log = util.log;

pub const ConfigShape = struct { name: []const u8, version: []const u8 };

pub const Config = struct {
    name: []u8,
    version: []u8,

    pub fn init() Config {
        const file = getConfigFileAlloc();
        defer allocator.free(file);

        const parsed = parseJsonInit(ConfigShape, file);
        defer parsed.deinit();

        return Config{
            .name = copy(parsed.value.name),
            .version = copy(parsed.value.version),
        };
    }

    pub fn deinit(self: *const Config) void {
        allocator.free(self.name);
        allocator.free(self.version);
    }
};

fn getConfigFileAlloc() []const u8 {
    const file = readFileAlloc(pathConfig) catch |err| if (err == error.FileNotFound) {
        Error("File not found", "Expected at path {s}.", .{pathConfig});
    } else {
        Error("At getConfigFileAlloc()", "{any}", .{err});
    };

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
    ) catch |err| {
        Error("Cannot parse config file", "{any}", .{err});
    };
}

pub fn setConfig(newConfig: ConfigShape) void {
    stringify(pathConfig, newConfig);
    // const content = formatAlloc(
    //     \\{s}
    //     \\  "name": "{s}",
    //     \\  "version": "{s}"
    //     \\{s}
    // , .{ "{", newConfig.name, newConfig.version, "}" });
    // defer allocator.free(content);

    // log(content);

    // createFile(pathConfig, content) catch {};
}

pub fn stringify(path: []const u8, obj: anytype) void {
    var file = std.fs.cwd().createFile(path, .{}) catch |err| {
        Error("stringify", "{any}", .{err});
    };
    defer file.close();

    const options = std.json.StringifyOptions{
        .whitespace = .indent_4,
    };

    std.json.stringify(obj, options, file.writer()) catch |err| {
        Error("stringify", "{any}", .{err});
    };

    _ = file.write("\n") catch |err| {
        Error("stringify", "{any}", .{err});
    };
}
