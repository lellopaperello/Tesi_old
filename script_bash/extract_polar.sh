#!/bin/bash

# Loop through all the given subdirectories under which the folders "a[alpha]"
# are contained
for arg in "$@"; do
  cd $arg   # $arg is the directory a[alpha]
  rm -f *.dat
  # Loop through all the Re[$Re] directories and extract Re and Cd
  for dir in $( ls -dv */ ); do
    dir=${dir%*/}                   # remove the trailing "/"
    echo ${dir##*a} >> alpha.dat    # append everything after "a" to "alpha.dat"

    # extract cl from history.csv and append it to cl.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,([^,]*).*$/\1/' >> cl.dat
    # extract cd from history.csv and append it to cd.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,[^,]*,([^,]*).*$/\1/' >> cd.dat
    # extract cm from history.csv and append it to cm.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,([^,]*).*$/\1/' >> cm.dat

    # "Sugli angoli non mi fido neanche di mia madre - cit."
    # extract cfx from history.csv and append it to cfx.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,([^,]*).*$/\1/' >> cfx.dat
    # extract cfy from history.csv and append it to cfy.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,([^,]*).*$/\1/' >> cfy.dat
    # extract cfz from history.csv and append it to cfz.dat
    sed -n '$p' $dir/history.csv | sed -r 's/^[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,([^,]*).*$/\1/' >> cfz.dat

    # extract iter from history.csv and append it to conv.dat (convergence)
    sed -n '$p' $dir/history.csv | sed -r 's/^\s*([^,]*).*$/\1/' >> conv.dat
  done
  cd ..
done
