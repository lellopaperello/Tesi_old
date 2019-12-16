#!/bin/bash

shopt -s extglob

uhMesh uhMesh.cfg

if [ "$1" == "-view" ]; then
  su2_mesh2vtk grid.*.su2
  paraview grid.*.vtk &
fi

shopt -u extglob
