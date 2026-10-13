#!/usr/bin/env bash
set -euo pipefail
# Local library repository, independent from desktop setup.
if [ ! -d .haxelib ]; then haxelib newrepo; fi
haxelib install lime 8.2.2 --skip-dependencies --always
haxelib install openfl 9.4.1 --skip-dependencies --always
haxelib install flixel 6.1.0 --skip-dependencies --always
haxelib install flixel-addons 3.3.2 --skip-dependencies --always
haxelib install hscript-iris 1.1.3 --skip-dependencies --always
haxelib install tjson 1.4.0 --skip-dependencies --always
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp 1618253d7bb2dd8eea1bc7ffcd612452df76a7b7 --always
haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate b8970d2e4d875c743abe28e356a15413b1774d94 --always
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit daf0664aee99aa8b8d6bdd1eda993a1c3a399067 --always
(cd .haxelib/hxcpp/git/tools/hxcpp && haxe compile.hxml)
