const std = @import("std");
const consts = @import("../lib/consts.zig");
const utils = @import("../lib/utils.zig");

const allocator = consts.allocator;

const print = utils.print;
const log = utils.log;

pub fn vm(path: []const u8) !void {
    log("Running...");

    const file = readFileToBuffer(path) catch |err| switch (err) {
        error.FileNotFound => {
            return log("Bad path");
        },
        else => {
            return log("Other error!");
        },
    };
    defer allocator.free(file);

    print("\nFile content:\n{s}\n", .{file});

    log("Done.");
}

fn readFileToBuffer(path: []const u8) ![]u8 {
    const f = try std.fs.cwd().openFile(path, .{});
    defer f.close(); // The file closes before we exit the function which happens before we work with the buffer.

    const f_len = try f.getEndPos();
    const buf = try allocator.alloc(u8, f_len);
    errdefer allocator.free(buf); // In case an error happens while reading

    _ = try f.readAll(buf);
    return buf;
}
