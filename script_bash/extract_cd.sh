#!/bin/bash

# Loop through all the given subdirectories under "solution"
for arg in "$@"; do
  cd $arg
  rm -f *.dat
  # Loop through all the Re[$Re] directories and extract Re and Cd
  for dir in $( ls -dv */ ); do
    dir=${dir%*/}                 # remove the trailing "/"
    echo ${dir##*Re} >> Re.dat    # append everything after Re to "Re.dat"

    # extract cd from history.csv and append it to cd.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,[^,]*,([^,]*).*$/\1/' >> cd.dat

    # extract iter from history.csv and append it to conv.dat (convergence)
    sed -n '$p' $dir/history.csv | sed -r 's/^\s*([^,]*).*$/\1/' >> conv.dat
  done
  cd ..
done
