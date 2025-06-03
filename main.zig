const std = @import("std");
const lib = @import("src/lib.zig");
const cli = @import("src/cli.zig").cli;
const compiler = @import("src/compiler/compiler.zig").compiler;

const consts = lib.consts;
const util = lib.util;

const allocator = consts.allocator;
const pathOut = consts.pathOut;
const ArgIterator = consts.ArgIterator;
const os = consts.os;

const Error = util.Error;
const getFirstArgAlloc = util.getFirstArgAlloc;
const sh = util.sh;

pub fn main() void {
    const arg = getFirstArgAlloc();
    defer allocator.free(arg);

    if (arg.len == 0)
        return dev();

    cli(arg);
}

inline fn dev() void {
    compiler();

    // sh("echo ----------------------------");
    // sh("zig build");
    // sh(".out/bin/vno");
}
