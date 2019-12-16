#!/bin/sh

clear
echo 
echo Cleaning...

rm -f CFD/*
cp 0/grid.su2 CFD
cp 0/config.cfg CFD

rm -rf PT/history

rm -rf ICE/*/
rm -f ICE/NEIGHBOUR.txt
rm -f ICE/NORM.txt
rm -f ICE/WALLS.txt
rm -f ICE/CONSTRAIN.txt

rm -f MSH/airfoil_coordinates.dat
rm -f MSH/grid.airfoil.su2
rm -f MSH/grid.airfoil.vtk
rm -f MSH/NODES.txt
rm -f MSH/WALLS.txt
rm -f MSH/*.airfoil
rm -f MSH/*.mtv
rm -f MSH/*.911

rm -f logs/*
rm -f PostProcess/*

# rm -f *.log *.out *.err

echo
echo Done
echo

