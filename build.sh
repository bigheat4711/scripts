#for all folders in current directory without current folder dot (.)
for D in `find . -maxdepth 1 -type d ! -name '\.'`
do
  echo "Current directory:" $D;
  cd $D ; cp --backup=t maven.log ~/temp ; mvn clean install --also-make -U -DskipTests | tee maven.log ; cd ..
done
