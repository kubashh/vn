const lib = @import("../lib.zig");

const consts = lib.consts;
const util = lib.util;
const fs = lib.fs;

const allocator = consts.allocator;
const ArrayList = consts.ArrayList;
const SSHashMap = consts.SSHashMap;
const pathMain = consts.pathMain;

const log = util.log;
const logv = util.logv;
const print = util.print;
const split = util.split;
const eql = util.eql;

const readFileAlloc = fs.readFileAlloc;

pub inline fn bundleImportAlloc() ![]const u8 {
    log("Bundling imports...");

    // key - relativePath, value - fileContent
    var importsMap = SSHashMap.init(allocator);
    defer importsMap.deinit();

    const file = readFileAlloc(pathMain);
    defer allocator.free(file);

    try importsMap.put(pathMain, file);
    try importsMap.put("test", "fdff");
    try importsMap.put("tesdt", "faff");
    try importsMap.put("tefst", "ffgf");
    try importsMap.put("tesft", "ffaf");

    try mapAdd(importsMap);

    var iterator = importsMap.iterator();

    var i: u8 = 0; // importsMap.count();
    while (iterator.next()) |val| : (i += 2) {
        print("{s}: {}\n", .{ val.value_ptr.*, i });
        if (i < 16) {
            const buf = [_]u8{@as(u8, i + 'a')};
            print("letter: {s}\n", .{buf});
            try importsMap.put(&buf, "asdf");
        }
    }

    // _ = try getImportsPath(file);

    // for (0..file.len - 6) |i| {
    //     if (eql("import", file[i .. i + 6])) {
    //         const impPath = getImportFilePath(file, i + 8);
    //         log(impPath);
    //     }
    // }

    var outFile = ArrayList(u8).init(allocator);
    defer outFile.deinit();

    // var iterator = importsMap.iterator();
    // while (iterator.next()) |entry| {
    //     print("{s}: {s}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    // }

    return "OUT_FILE";
}

fn mapAdd(map: SSHashMap) !void {
    map.add();
}

// TODO fn toPathAlloc() []u8 {}

// fn bundleMap(map: StringHashMap([]const u8)) void {
//     const
// }

// inline fn getImportsPath(file: []const u8) ![]const u8 {
//     var list = ArrayList([]const u8).init(allocator);
//     defer list.deinit();

//     var it = split(file, "\n ");
//     var imp = false;
//     while (it.next()) |str| {
//         if (imp) {
//             try list.append(str);
//             imp = false;
//         } else if (eql("import", str))
//             imp = true;
//     }

//     const out: []const u8 = "";

//     for (list.items) |item| {
//         log(item);
//     }

//     return out;
// }
