const std = @import("std");
const compiler = @import("compiler/compiler.zig");
const vm = @import("vm/vm.zig");

const print = std.debug.print;
const eql = std.mem.eql;

const allocator = std.heap.page_allocator;

inline fn log(str: []const u8) void {
    print("{s}\n", .{str});
}

fn createFile(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().createFile(
        path,
        .{ .read = true },
    );
    defer file.close();
    try file.writeAll(content);
}

fn makeDir(path: []const u8) !void {
    try std.fs.cwd().makeDir(path);
}

pub fn main() !void {
    try cli();
}

fn cli() !void {
    if (std.os.argv.len == 1) {
        try compiler.compiler();
        return;
    }

    // Initialize arguments
    // Then deinitialize at the end of scope
    var argsIterator = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argsIterator.deinit();

    // Skip executable
    _ = argsIterator.next();

    var path: ?[:0]const u8 = "";

    if (std.os.argv[1][0] != '-') {
        path = argsIterator.next();
        print("path: {?s}\n", .{path});
    }

    // Handle all arguments
    while (argsIterator.next()) |arg| {
        if (eql(u8, arg, "-h")) {
            // print help
            log(
                \\options:
                \\run_path            first and optional argument for run path (if empty get current)
                \\no flags            run already build project
                \\-h, --help          show help
                \\-v                  get version
                \\-i                  init project
                \\-b                  build mode: build (no run)
                \\-d                  dev mode: build and run", .{});
            );
            return;
        } else if (eql(u8, arg, "-v")) {
            // print version
            print("version: {s}\n", .{"0.0.0"});
            return;
        } else if (eql(u8, arg, "-i")) {
            // create empty project
            log("Init empty project");

            // vir.json
            try createFile("vir.json",
                \\{
                \\  "version": "0.0.0"
                \\}
            );
            // try createFile(".out/.viro", "test");

            // makeDir(".");

            // var iter_dir = try std.fs.cwd().openDir(
            //     ".",
            //     .{},
            // );
            // defer iter_dir.close();

            // _ = try iter_dir.createFile("x", .{});

            return;
        } else {
            log(
                \\bad argument given
                \\valid args: no arg, -h, -v, -b, -d
            );
            return;
        }
    }

    // while test $# -gt 0; do
    // case "$1" in
    //     -i)
    //     IFS='/' read -r -a array <<< $PATH
    //     NAME="${array[-1]}"
    //     echo "name: $NAME"

    //     echo "init"
    //     /bin/rm -rf $PATH
    //     /bin/mkdir -p $PATH
    //     # /bin/mkdir -p "$PATH/.cache"
    //     /bin/mkdir -p "$PATH/.out"
    //     /bin/mkdir -p "$PATH/modules"
    //     /bin/mkdir -p "$PATH/src"
    //     echo 'constructor() {
    // Debug.log("Hello World!")
    // }' >> "$PATH/src/Main.vir"
    //     echo '{
    // "version": "0.0.0"
    // }' >> "$PATH/vir.json"
    //     exit
    //     ;;
    //     -b)
    //     echo "build mode"
    //     BUILD=true
    //     RUN=false
    //     shift
    //     ;;
    //     -d)
    //     echo "dev mode"
    //     BUILD=true
    //     shift
    //     ;;
    //     *)
    //     echo "bad argument given"
    //     echo "valid args: no arg, -h, -v, -b, -d"
    //     exit 1
    //     ;;
    // esac
    // done

    // echo "path: $PATH"
    // echo "build: $BUILD"
    // echo "run: $RUN"
}
