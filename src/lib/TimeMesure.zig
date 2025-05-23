const util = @import("util.zig");

const print = util.print;
const nowMicro = util.nowMicro;

var startTime: i64 = undefined;

pub inline fn start(comptime label: []const u8) void {
    print("{s}", .{label});
    startTime = nowMicro();
}

pub inline fn end() void {
    const dif = nowMicro() - startTime;
    print(" - {}μs\n", .{dif});
}
