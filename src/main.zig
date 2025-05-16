const consts = @import("lib/consts.zig");
const util = @import("lib/util.zig");
const cli = @import("cli.zig").cli;
const compiler = @import("compiler/compiler.zig").compiler;
const vm = @import("vm/vm.zig").vm;
const config = @import("lib/config.zig");

const allocator = consts.allocator;
const pathOut = consts.pathOut;
const ArgIterator = consts.ArgIterator;
const os = consts.os;

const log = util.log;
const Error = util.Error;

pub fn main() !void {
    if (os.argv.len == 1)
        return dev();

    const name = config.getNameAlloc();
    log(name);

    // Initialize arguments
    // Then deinitialize at the end of scope
    var argsIterator = try ArgIterator.initWithAllocator(allocator);
    defer argsIterator.deinit();

    // Skip exe path
    if (argsIterator.next()) |arg| {
        // config.path = arg;
        _ = arg;
    }

    // Handle argument
    if (argsIterator.next()) |arg| {
        try cli(arg);
    }
}

inline fn dev() void {
    compiler() catch |err| {
        Error("Other", "{any}", .{err});
    };

    vm(pathOut ++ "viro");
}
