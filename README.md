# VIR programming language


# For now not working!


## Lang
Simple language similar to Java, JavaScript and TypeSctipt

## Help
```shell
./vir/install/path -h
```

## `vir.json` (config file)
```json
{
  "name": "name",
  "version": "x.x.x",
  "imports": {
    "lib": "src/lib.vir"
  },
  "enabledFiles": {
    "f1": "res/f1.png",
    "f2": "res/f2.png"
  },
  "compiler": {
    "aarch64-linux": false,
    "aarch64-macos": false,
    "x86_64-linux-gnu": false,
    "x86_64-linux-musl": false,
    "x86_64-windows": false,
  }
}
```


# Dev

## usage

### Run tests
```shell
sh test.sh
```

### Run program
```shell
sh run.sh
```

### Cross compilation
```shell
zig build -- a
```

## To consider
- only `var` keyword for declaring variables (comptime oplimalization)
- fn as `const`
- no `pub` keyword (evrything public)
- compile to zig => os directly / VM

## Concepts
- Error ends program, error not ends program (can return, tr and catch error like in zig)

## Steps
1. Compile (Developer)
2. Run on client (client need to have VVM)


# To do

## Impontant
- fix vm.zig (read file error, why given path is diffrent)

## Compiler
- read Main file (/src/Main.vir) and bundle all files together
- remove unused values 
- rename to ptr
- create out file

## VM
- parse file
- run file + GC
