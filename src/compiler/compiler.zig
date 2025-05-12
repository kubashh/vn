const std = @import("std");

pub fn compiler() !void {
    std.debug.print("Compiling...\n", .{});

    // read "./src/Main.vir"

    std.debug.print("Done.\n", .{});
}
