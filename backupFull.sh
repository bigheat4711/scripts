#!/bin/bash
exec &>>~/BACKUP_LOG.txt
scope=full
output=~/backup-$scope.tar.gz 
outputold=~/backup-$scope-old.tar.gz 
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
dst=~/nethome/autodelete/$scope-$timestamp

echo "INFO: Starting $0 $timestamp";
tar czf $output ~/projects/scripts/ ~/bp/* ~/repos/ ~/.*rc ~/.bash* ~/.config/terminator/config ~/?.txt ~/.ssh ~/.m2/settings.xml ~/.squirrel-sql/SQLAliases23.xml

cmp --quiet $output $outputold && echo "INFO: Files are identical" || ( echo "INFO: Files differ -> store in $dst" && mkdir $dst && cp --backup=t $output $dst );
mv $output $outputold;

if [ $? != 0 ];
then
  echo $timestamp "ERROR: An error occured while executing script $0:$LINENO";
  echo $timestamp "ERROR:   Can't cp tar to $dst";
  exit 1;
fi

echo "INFO: Finished $0 $timestamp";
echo '###'
