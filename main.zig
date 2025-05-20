const lib = @import("src/lib.zig");
const cli = @import("src/cli.zig").cli;
const compiler = @import("src/compiler/compiler.zig").compiler;
const vm = @import("src/vm/vm.zig").vm;

const consts = lib.consts;
const util = lib.util;

const allocator = consts.allocator;
const pathOut = consts.pathOut;
const ArgIterator = consts.ArgIterator;
const os = consts.os;

const Error = util.Error;

pub fn main() !void {
    if (os.argv.len == 1)
        return dev();

    try cli();
}

inline fn dev() void {
    compiler() catch |err|
        Error("Other", "{any}", .{err});

    vm(pathOut);
}
