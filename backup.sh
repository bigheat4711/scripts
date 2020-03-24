#!/bin/bash

backupName=bestpractices.tar.gz 
backup=~/tmp/$backupName
target=~/autodelete/$backupName

tar cf $backup ~/.bash* ~/.ssh/* ~/scripts/ ~/bp/* ~/.*rc
diff $backup $target || mv --backup=t $backup $target
