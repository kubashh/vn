clear
zig build
if [ $# -eq 1 ] && [ $1 = "-i" ]; then rm -rf playground; mkdir playground; fi
cd playground
../zig-out/bin/vir $1