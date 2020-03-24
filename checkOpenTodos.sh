#!/bin/bash
grep --color=auto -rie "\(FIXME\|TODO\|XXX\)[[:space:]]\+cgrau" --include=*.java

