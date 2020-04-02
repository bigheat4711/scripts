#!/bin/bash

find ~/.autodelete/        -maxdepth 1 -mtime +30 -exec rm -rf {} \;
# might fail
find ~/nethome/autodelete/ -maxdepth 1 -mtime +30 -exec rm -rf {} \; 2>/dev/null
