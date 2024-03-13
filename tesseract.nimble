import std/os

# Package

version     = "0.0.1"
author      = "Jose Maria Garcia"
description = "Tesseract bindings"
license     = "MIT"

# Deps

requires "nim >= 1.0.0"
requires "https://github.com/mantielero/leptonica.nim"

skipDirs = @["examples"]
srcDir = "src"