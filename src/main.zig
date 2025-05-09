const std = @import("std");
const compiler = @import("compiler/compiler.zig");
const vm = @import("vm/vm.zig");

const print = std.debug.print;

pub fn main() !void {
    // _ = std.process.args();

    // if (std.os.argv.len < 2) return error.NoPathGiven;

    // const file_path = std.os.argv[1];

    // // const file = std.fs.cwd().openFile(file_path, .{}) catch |err| {
    // //     std.log.err("Failed to open file: {s}", .{@errorName(err)});
    // //     return;
    // // };
    // // defer file.close();

    // // std.debug.print("{any}", .{file});

    // std.debug.print("Path {s}!\n", .{file_path});

    // try compiler.compiler();
    // try vm.vm();

    try cli();
}

fn cli() !void {
    const args = std.os.argv;

    if (args.len == 1) {
        try compiler.compiler();
        return;
    }

    var index: u2 = 1;
    // var path: *u8 = "asdf";

    // // const allocator = std.heap.page_allocator;

    if (args[1][0] != '-') {
        index = 2;
        // const memory = try allocator.alloc(u8, args[1].len);

        // path = args[1];
    }

    for (args, index..) |arg, i| {
        std.debug.print("here {}: {s}\n", .{ i, arg });
        if (eqlFlag(arg, "-h")) {
            print("{s}", .{
                \\options:
                \\run_path            first and optional argument for run path (if empty get current)
                \\no flags            run already build project
                \\-h, --help          show help
                \\-v                  get version
                \\-b                  build mode: build (no run)
                \\-d                  dev mode: build and run", .{});
                \\
            });
            return;
        } else if (eqlFlag(arg, "-v")) {
            print("version: {s}\n", .{"0.0.0"});
            return;
        }
    }

    // const allocator = std.heap.page_allocator;

    // const memory = try allocator.alloc(u8, 100);
    // defer allocator.free(memory);

    // std.debug.print("{s}", .{memory});

    // for (memory) |c| {
    //     std.debug.print("{c}", .{c});
    // }

    // while test $# -gt 0; do
    // case "$1" in
    //     -v)
    //     echo "version: 0.0.0"
    //     shift
    //     ;;
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

fn eql(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    for (0..a.len) |i| {
        if (a[i] != b[i]) {
            std.debug.print("{}{}", .{ a[i], b[i] });
            return false;
        }
    }
    return true;
}

fn eqlFlag(a: [*:0]u8, b: *const [2:0]u8) bool {
    if (a[0] == 0) return false;
    if (a[1] == 0) return false;
    if (a[2] != 0) return false;
    if (a[0] == b[0])
        if (a[1] == b[1]) return true;
    return false;
}
