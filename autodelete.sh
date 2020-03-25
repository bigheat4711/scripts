#!/bin/bash
find ~/nethome/autodelete/ -maxdepth 1 -mtime +30 -exec rm -rf {} \;
find ~/.autodelete/        -maxdepth 1 -mtime +30 -exec rm -rf {} \;
