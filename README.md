# VIR programming language

# For now not working!

## Lang
Simple language similar to Java, JavaScript and TypeSctipt

### To consider
- only `var` keyword for declaring variables (comptime oplimalization)
- no `pub` keyword (evrything public)
- compile directly / VM

### `vir.json` (config file)
```json
{
  "name": "name",
  "version": "x.x.x",
  "imports": {
    "lib": "src/lib.vir"
  }
}
```

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
