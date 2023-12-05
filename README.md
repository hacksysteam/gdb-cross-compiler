<p align="center">
    <img width="100px" src="https://www.freewear.org/images/articles/detail/FW0345_Dise%C3%B1o.png"
        align="center" alt="GDB logo" />
    <h2 align="center">GDB Cross Compiler</h2>
    <p align="center">Compile GDB for various distributions and architectures!</p>
</p>
<p align="center">
    <img alt="Download count" src="https://img.shields.io/github/downloads/hacksysteam/gdb-cross-compiler/total.svg" />
    <img alt="GDB Version" src="https://img.shields.io/badge/GDB-13.2-blue.svg" />
    <br />
    <br />
</p>

## Supported GDB Versions

* **13.2**
* **12.1**

## Supported Distributions

* Ubuntu 22

## Downloads

Automatically compiled binaries are available in the [Releases](https://github.com/hacksysteam/gdb-cross-compiler/releases) section.

### GDB - 13.2

| Name      | Architecture         |
|-----------|----------------------|
| gdb       | [x86_64-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/13.2/gdb-x86_64-linux-gnu.zip) |
| gdbserver | [i686-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/13.2/gdbserver-i686-linux-gnu.zip) |
| gdbserver | [x86_64-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/13.2/gdbserver-x86_64-linux-gnu.zip) |
| gdbserver | [arm-linux-gnueabi](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/13.2/gdbserver-arm-linux-gnueabi.zip) |
| gdbserver | [aarch64-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/13.2/gdbserver-aarch64-linux-gnu.zip) |

### GDB - 12.1

| Name      | Architecture         |
|-----------|----------------------|
| gdb       | [x86_64-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/12.1/gdb-x86_64-linux-gnu.zip) |
| gdbserver | [i686-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/12.1/gdbserver-i686-linux-gnu.zip) |
| gdbserver | [x86_64-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/12.1/gdbserver-x86_64-linux-gnu.zip) |
| gdbserver | [arm-linux-gnueabi](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/12.1/gdbserver-arm-linux-gnueabi.zip) |
| gdbserver | [aarch64-linux-gnu](https://github.com/hacksysteam/gdb-cross-compiler/releases/download/12.1/gdbserver-aarch64-linux-gnu.zip) |

## Local Compilation Instructions

If you prefer to compile locally, follow these steps:

```sh
$ git clone https://github.com/hacksysteam/gdb-cross-compiler
$ cd gdb-cross-compiler
$ bash build-docker.sh
```
