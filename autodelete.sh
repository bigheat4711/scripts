#!/bin/bash
find ~/nethome/autodelete/ -mtime +30 -exec rm -rf {} \;
