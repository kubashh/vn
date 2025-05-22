const std = @import("std");
const consts = @import("consts.zig");
const util = @import("util.zig");

const allocator = consts.allocator;

const print = util.print;
const Error = util.Error;
const formatAlloc = util.formatAlloc;

pub inline fn joinPathAlloc(a: []const u8, b: []const u8) []u8 {
    return formatAlloc("{s}/{s}", .{ a, b });
}

const alloc = util.alloc;

pub inline fn makeDir(path: []const u8) !void {
    try std.fs.cwd().makeDir(path);
}

pub inline fn openIterateDir(path: []const u8) std.fs.Dir {
    return std.fs.cwd().openDir(path, .{ .iterate = true }) catch |err|
        Error("File not found", "path: {s}, err: {any}", .{ path, err });
}

pub inline fn fileExist(path: []const u8) bool {
    std.fs.cwd().access(path, .{}) catch {
        return false;
    };

    return true;
}

pub inline fn readFileAlloc(path: []const u8) []u8 {
    const f = std.fs.cwd().openFile(path, .{}) catch |err| if (err == error.FileNotFound) {
        Error("File not found", "Expected at path {s}.", .{path});
    } else Error("At readFileAlloc()", "{any}", .{err});

    defer f.close();

    const f_len = f.getEndPos() catch |err|
        Error("Cannot get file end pos", "{any}", .{err});

    const buf = alloc(f_len);

    _ = f.readAll(buf) catch |err|
        Error("read file", "{any}", .{err});

    return buf;
}

pub inline fn createFile(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().createFile(path, .{});
    defer file.close();
    try file.writeAll(content);
}

pub inline fn getCwdAlloc() []u8 {
    return std.process.getCwdAlloc(allocator) catch |err|
        Error("Get dir", "{any}", .{err});
}

pub inline fn saveStringifyJson(path: []const u8, obj: anytype) void {
    var file = std.fs.cwd().createFile(path, .{}) catch |err|
        Error("stringify", "{any}", .{err});

    defer file.close();

    const options = std.json.StringifyOptions{ .whitespace = .indent_4 };

    std.json.stringify(obj, options, file.writer()) catch |err|
        Error("stringify", "{any}", .{err});

    _ = file.write("\n") catch |err|
        Error("stringify", "{any}", .{err});
}
