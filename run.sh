clear
zig build
if [ $# -eq 1 ] && [ $1 = "init" ]; then rm -rf playground; mkdir playground; fi
cd playground
../zig-out/bin/vn $1