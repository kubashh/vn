# VN programming language

# For now not working!

## 1. Lang

Simple compiled programming language similar to Zig, Java, JavaScript and TypeSctipt

## Help

```shell
./vn/install/path -h
```

## `vn.json` (config file)

```json
{
  "name": "name",
  "version": "x.x.x",
  "imports": {
    "lib": "src/lib.vn"
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
    "x86_64-windows": false
  }
}
```

## Usage

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

## Lang keywords
- `var`
- `const`
- `fn` // maybe `const`

### To do
- `pub`
- `u{1-128}`
- `i{1-128}`
- `f16`, `f32`, `f64`, `f80`, `f128`
- `enum`
- `error`
- `Error`

## Types

### 1. Numbers
1. `u{1-128}`
2. `i{1-128}`
3. `f16`, `f32`, `f64`, `f80`, `f128`,

### 2. errors
1. `error` not ends program (can return, tr and catch `error` like in zig)
2. `Error` ends program

### 3. `enum`

### 4. Declaration
1. `var`
2. `const`
3. `fn`

### 5. Before declaration
1. `pub`
2. `static` ?


## To do

- remove unused values
- rename to ptr
- create exe's
