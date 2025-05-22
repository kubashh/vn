const std = @import("std");
const consts = @import("consts.zig");
const testing = @import("testing.zig");

const allocator = consts.allocator;
const SplitIterator = consts.SplitIterator;

const expect = testing.expect;

pub const print = std.debug.print;

pub inline fn eql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

pub inline fn include(s: []const u8, d: u8) bool {
    for (s) |c|
        if (c == d) return false;

    return true;
}

pub inline fn split(a: []const u8, b: []const u8) SplitIterator {
    return std.mem.splitAny(u8, a, b);
}

pub inline fn log(a: []const u8) void {
    print("{s}\n", .{a});
}

pub inline fn logv(a: anytype) void {
    print("{any}\n", .{a});
}

pub inline fn Error(comptime t: []const u8, comptime a: []const u8, args: anytype) void {
    print("Error: " ++ t ++ "\n" ++ a ++ "\n", args);
    std.process.exit(1);
}

pub inline fn joinAlloc(args: anytype) []u8 {
    return formatAlloc("{s}" ** args.len, args);
}

pub inline fn formatAlloc(fmt: []const u8, args: anytype) []u8 {
    return std.fmt.allocPrint(allocator, fmt, args) catch |err|
        Error("Join Strings", "{any}", .{err});
}

pub inline fn alloc(len: u64) []u8 {
    return allocator.alloc(u8, len) catch |err|
        Error("Allocation", "{any}", .{err});
}

pub inline fn copyAlloc(str: []const u8) []u8 {
    return std.mem.Allocator.dupe(allocator, u8, str) catch |err|
        Error("Other", "{any}", .{err});
}

pub inline fn parseJsonAlloc(comptime T: type, file: []const u8) std.json.Parsed(T) {
    return std.json.parseFromSlice(T, allocator, file, .{}) catch |err|
        Error("Cannot parse config file", "{any}", .{err});
}

pub inline fn getFirstArgAlloc() []u8 {
    const args = std.process.argsAlloc(allocator) catch |err|
        Error("Args", "{any}", .{err});
    defer allocator.free(args);

    if (args.len < 2)
        return "";

    return copyAlloc(args[1]);
}

// arg - command word ex: &[_][]const u8{ "zig", "build" }
pub inline fn sh(argv: []const []const u8) !void {
    var cmd = std.process.Child.init(argv, allocator);
    try cmd.spawn();

    const out = try cmd.wait();
    if (out.Exited != 0)
        Error("Bash line", "returned process {}", .{out.Exited});
}
