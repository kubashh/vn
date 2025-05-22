const std = @import("std");
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
const getFirstArgAlloc = util.getFirstArgAlloc;

pub fn main() !void {
    const arg = getFirstArgAlloc();
    defer allocator.free(arg);

    if (arg.len == 0)
        return dev();

    try cli(arg);
}

inline fn dev() void {
    compiler() catch |err|
        Error("Other", "{any}", .{err});

    vm(pathOut);
}
