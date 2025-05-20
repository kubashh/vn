const lib = @import("../lib.zig");

const consts = lib.consts;
const util = lib.util;
const fs = lib.fs;

const ArrayList = consts.ArrayList;

const allocator = consts.allocator;
// const StringHashMap = consts.StringHashMap;
const ext = consts.ext;
const pathMain = consts.pathMain;
const pathOut = consts.pathOut;
const pathOutDir = consts.pathOutDir;

const log = util.log;
const print = util.print;
const split = util.split;
const eql = util.eql;
const Error = util.Error;
// const createFile = util.createFile;
// const formatAlloc = util.formatAlloc;

const fileExist = fs.fileExist;
const readFileAlloc = fs.readFileAlloc;
const createFile = fs.createFile;
const makeDir = fs.makeDir;

pub fn compiler() !void {
    const path = pathMain;
    if (!fileExist(path)) Error("Main file not exist", "Expected at path {s}.", .{path});

    log("Compiling...");

    const file = readFileAlloc(pathMain);

    try bundleImports(path);

    saveOutFile(file);

    log("Done.");
}

inline fn bundleImports(path: []const u8) !void {
    log("Bundling imports...");

    // var map = StringHashMap([]const u8).init(allocator);
    // defer map.deinit();

    // try map.put("test", "testv");
    // try map.put("test2", "test4");
    // try map.put("test3", "test234234");

    // var iterator = map.iterator();

    // var i: u8 = 0;
    // while (iterator.next()) |val| : (i += 1) {
    //     print("{s}: {s}", .{ val.key_ptr.*, val.value_ptr.* });
    //     logv(i);
    //     if (i < 9) {
    //         var buf: [256]u8 = @as([]const u8, i);
    //         const str = try fmt.bufPrint(&buf, "{}", .{i});
    //         // try map.put("val" ++ str, str);
    //         print("{s}\n", .{str});
    //         log(buf);
    //     }
    // }

    var outFile = ArrayList(u8).init(allocator);
    defer outFile.deinit();

    const file = readFileAlloc(path);
    defer allocator.free(file);

    _ = try getImportsPath(file);

    // for (0..file.len - 6) |i| {
    //     if (eql("import", file[i .. i + 6])) {
    //         const impPath = getImportFilePath(file, i + 8);
    //         log(impPath);
    //     }
    // }

    try outFile.appendSlice(file);

    // log(file);
}

inline fn getImportsPath(file: []const u8) ![]const u8 {
    var list = ArrayList([]const u8).init(allocator);
    defer list.deinit();

    var it = split(file, "\n ");
    var imp = false;
    while (it.next()) |str| {
        if (imp) {
            try list.append(str);
            imp = false;
        } else if (eql("import", str))
            imp = true;
    }

    const out: []const u8 = "";

    for (list.items) |item| {
        log(item);
    }

    return out;
}

inline fn saveOutFile(file: []const u8) void {
    print("{s}\n", .{file});
    makeDir(pathOutDir) catch {};
    createFile(pathOut, file) catch |err|
        Error("At saveOutFile()", "{any}", .{err});
}
