#!/bin/bash
#set -x ;
searchPattern='classpathentry excluding[^ ]\+';
for f in `find -name .classpath`;
do echo $f;
sed -i.backup "s/$searchPattern/classpathentry/g" $f;
dwdiff $f.backup $f -c -3;
rm $f.backup;
done
