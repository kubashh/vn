const lib = @import("../lib.zig");
const bundleImportAlloc = @import("bundleImports.zig").bundleImportAlloc;
const emitOutFree = @import("emitOut.zig").emitOutFree;
const formatFiles = @import("formatFiles.zig").formatFiles;

const consts = lib.consts;
const util = lib.util;
const fs = lib.fs;
const TimeMesure = lib.TimeMesure;

const allocator = consts.allocator;
const pathMain = consts.pathMain;

const log = util.log;
const Error = util.Error;

const fileExist = fs.fileExist;

pub fn compiler() void {
    mainFileExistExit();

    formatFiles(); // TODO format files

    log("Compiling...");

    TimeMesure.start("Bundling imports");
    const file = bundleImportAlloc();
    TimeMesure.end();

    // TODO check files checkFile()
    // TODO twim file twimFileAllocFree()
    // TODO compile to zig? compileToZig()

    TimeMesure.start("Emiting output");
    emitOutFree(file);
    TimeMesure.end();

    log("Done.");
}

inline fn mainFileExistExit() void {
    if (!fileExist(pathMain)) Error("Main file not exist", "Expected at path {s}.", .{pathMain});
}
