const consts = @import("../lib/consts.zig");
const util = @import("../lib/util.zig");

const ArrayList = consts.ArrayList;

const allocator = consts.allocator;
// const StringHashMap = consts.StringHashMap;
const ext = consts.ext;
const mainPath = consts.mainPath;

const log = util.log;
const print = util.print;
const readFileAlloc = util.readFileAlloc;
const split = util.split;
const eql = util.eql;
const fileExist = util.fileExist;
const printErrorComptime = util.printErrorComptime;

pub fn compiler() !void {
    const path = mainPath;
    if (!fileExist(path)) return printErrorComptime("Main file at path {s} not exist!", .{path});

    log("Compiling...");

    try bundleImports(path);

    log("Done.");
}

pub fn bundleImports(path: []const u8) !void {
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

    const file = readFileAlloc(path) catch |err| switch (err) {
        error.NotDir, error.FileNotFound => {
            return log("Bad path");
        },
        else => {
            return log("Other error!");
        },
    };
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

fn getImportsPath(file: []const u8) ![]const u8 {
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
