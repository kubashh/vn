const std = @import("std");

pub const print = std.debug.print;
pub const eql = std.mem.eql;

pub inline fn log(str: []const u8) void {
    print("{s}\n", .{str});
}
