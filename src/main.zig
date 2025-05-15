const consts = @import("lib/consts.zig");
const cli = @import("cli.zig").cli;
const compiler = @import("compiler/compiler.zig").compiler;
const vm = @import("vm/vm.zig").vm;

const allocator = consts.allocator;
const outPath = consts.outPath;
const ArgIterator = consts.ArgIterator;
const os = consts.os;

pub fn main() !void {
    if (os.argv.len == 1)
        return try dev();

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

inline fn dev() !void {
    try compiler();

    vm(outPath ++ "viro");
}
