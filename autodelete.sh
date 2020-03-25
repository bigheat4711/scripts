#!/bin/bash
find ~/nethome/autodelete/ -mtime +30 -exec rm -rf {} \;
find ~/.autodelete/ -mtime +30 -exec rm -rf {} \;
