const lib = @import("../lib.zig");

const consts = lib.consts;
const util = lib.util;
const fs = lib.fs;

const allocator = consts.allocator;
const ArrayList = consts.ArrayList;

const log = util.log;
const print = util.print;
const split = util.split;
const formatAlloc = util.formatAlloc;
const copyAlloc = util.copyAlloc;
const include = util.include;
const Error = util.Error;

const joinPathAlloc = fs.joinPathAlloc;
const readFileAlloc = fs.readFileAlloc;
const openIterateDir = fs.openIterateDir;

pub inline fn bundleImportAlloc() []const u8 {
    const file = bundledFileAlloc() catch |err|
        Error("", "{any}", .{err});
    // TODO join std lib; print; main call; with file
    return file;
}

inline fn bundledFileAlloc() ![]u8 {
    var outFile = ArrayList(u8).init(allocator);
    defer outFile.deinit();

    const paths = try getPathsAlloc("src");
    defer allocator.free(paths);

    var ite = split(paths, ";");
    while (ite.next()) |path| {
        const file = readFileAlloc(path);
        defer allocator.free(file);

        try outFile.appendSlice("const ");
        try outFile.appendSlice(getFileName(path));
        try outFile.appendSlice(" = struct {\n");
        try outFile.appendSlice(file);
        try outFile.appendSlice("\n};\n");
    }

    return copyAlloc(outFile.items);
}

fn getPathsAlloc(path: []const u8) ![]u8 {
    var list = ArrayList(u8).init(allocator);
    defer list.deinit();

    var dir = openIterateDir(path);
    defer dir.close();

    var ite = dir.iterate();
    while (try ite.next()) |e| {
        const fullPath = joinPathAlloc(path, e.name);
        defer allocator.free(fullPath);

        switch (e.kind) {
            .file => {
                try list.appendSlice(fullPath);
                try list.append(';');
            },
            else => {
                const pathsPrev = try getPathsAlloc(fullPath);
                defer allocator.free(pathsPrev);

                try list.appendSlice(pathsPrev);
            },
        }
    }

    // if main dir cut last ';'
    if (include(path, '/'))
        return copyAlloc(list.items[0 .. list.items.len - 1]);
    return copyAlloc(list.items);
}

inline fn getFileName(path: []const u8) []const u8 {
    var index: usize = 0;
    var indexLast: usize = 0;
    for (path, 0..) |c, i| {
        if (c == '/')
            index = i;
        if (c == '.')
            indexLast = i;
    }

    return path[index + 1 .. indexLast];
}
