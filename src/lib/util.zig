const std = @import("std");
const consts = @import("consts.zig");

const allocator = consts.allocator;

pub const print = std.debug.print;

pub inline fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

pub inline fn split(a: []const u8, b: []const u8) std.mem.SplitIterator(u8, .any) {
    return std.mem.splitAny(u8, a, b);
}

pub inline fn log(a: []const u8) void {
    print("{s}\n", .{a});
}

pub inline fn logv(a: anytype) void {
    print("{any}\n", .{a});
}

pub inline fn concat(a: []u8, b: []u8) []u8 {
    return std.mem.concat(allocator, u8, .{ a, b });
}

inline fn printError(t: []const u8, a: []const u8, args: anytype) void {
    print(t ++ " Error!\n" ++ a ++ "\n", args);
}

pub inline fn printErrorComptime(a: []const u8, args: anytype) void {
    printError("Comptime", a, args);
}

pub inline fn printErrorRuntime(a: []const u8, args: anytype) void {
    printError("Runtime", a, args);
}

pub inline fn makeDir(path: []const u8) !void {
    try std.fs.cwd().makeDir(path);
}

pub inline fn createFile(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().createFile(
        path,
        .{},
    );
    defer file.close();
    try file.writeAll(content);
    print("info: created {s}\n", .{path});
}

pub inline fn fileExist(path: []const u8) bool {
    std.fs.cwd().access(path, .{}) catch |err| switch (err) {
        error.FileNotFound => {
            return false;
        },
        else => {},
    };

    return true;
}

pub inline fn readFileAlloc(path: []const u8) ![]u8 {
    const f = try std.fs.cwd().openFile(path, .{});
    defer f.close(); // The file closes before we exit the function which happens before we work with the buffer.

    const f_len = try f.getEndPos();
    const buf = try allocator.alloc(u8, f_len);
    errdefer allocator.free(buf); // In case an error happens while reading

    _ = try f.readAll(buf);
    return buf;
}

pub inline fn getNameInitProject() []const u8 {
    const exePath = std.os.argv[0];
    log(exePath);
}
