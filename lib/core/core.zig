const __std = @import("std");

inline fn print(a: []const u8) void {
    __std.debug.print("{s}\n", .{a});
}
inline fn printin(a: []const u8) void {
    __std.debug.print("{s}", .{a});
}

const Number = struct {
    fn toString(n: anytype) []const u8 {
        var buffer: [4096]u8 = undefined;
        const result = __std.fmt.bufPrintZ(buffer[0..], "{d}", .{n}) catch unreachable;
        return @as([]const u8, result);
    }
};

const String = struct {};
