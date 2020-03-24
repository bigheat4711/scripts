#!/bin/bash

version=$(lynx -dump http://courseplay.github.io/courseplay/de/changelog/index.html | grep "Änderungen in Version.*" | grep "v[0-9]\..*" -o)
echo $version
