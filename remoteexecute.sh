#!/bin/bash
MYCOMMAND=$(base64 -w0 $1)
ssh accmobservboss@accrlog "echo $MYCOMMAND | base64 -d | bash"
