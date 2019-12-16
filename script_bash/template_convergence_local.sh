#!/bin/bash

shopt -s extglob

# Variable declaration

# MPI_FLAGS='--bind-to core --report-bindings'
MPI_FLAGS=''

HOME_DIR=$PWD
CONFIG_DIR=${HOME_DIR}/config
GRID_DIR=${HOME_DIR}/grid/old
SIMULATION_DIR=${HOME_DIR}/simulation
SOL_DIR=${HOME_DIR}/solution/scale1_old
LOG_DIR=${HOME_DIR}/logs

# Problem declaration
PROBLEM_START="start_convergence"
PROBLEM_LIST=("convergence")
MESH_LIST=("scale1")

# Parameters
RHO=1.2886
MU=0.00001716
D=1

# Convergence parameters
i_max=2;

# Environment creation
mkdir -p $SIMULATION_DIR $SOL_DIR

# Commands
# $(seq 0.1 0.1 1) $(seq 2 1 10) $(seq 15 5 100)


for PROBLEM in ${PROBLEM_LIST[@]}; do
  if [ ${#PROBLEM_LIST[@]} -gt 0 ]; then
    cp $CONFIG_DIR/${PROBLEM}.cfg $SIMULATION_DIR/SU2_config.cfg
    if [ ${#PROBLEM_LIST[@]} -gt 1 ]; then
      OLD_PROBLEM=$SOL_DIR
      SOL_DIR=$SOL_DIR/$PROBLEM
    fi
  fi
  for MESH in ${MESH_LIST[@]}; do
    if [ ${#MESH_LIST[@]} -gt 0 ]; then
      cp $GRID_DIR/${MESH}.su2 $SIMULATION_DIR/mesh.su2
      if [ ${#MESH_LIST[@]} -gt 1 ]; then
        OLD_MESH=$SOL_DIR
        SOL_DIR=$SOL_DIR/$MESH
        mkdir -p $SOL_DIR
        cp $GRID_DIR/${MESH}.su2 $SOL_DIR/.
      fi
    fi

    cd $SIMULATION_DIR

    # Cleaning data
    echo cleaning..
    echo

    rm -v !(*.cfg|*.su2)

    # Flow computation
    echo
    echo computing the flow..

    mpirun -n 2 $MPI_FLAGS SU2_CFD $CONFIG_DIR/${PROBLEM_START}.cfg
    mv restart_flow.dat solution_flow.dat
    SU2_SOL SU2_config.cfg
    cp flow.vtk $SOL_DIR/0.vtk

    for (( i = 1; i <= $i_max; i ++ )); do

      mpirun -n 2 $MPI_FLAGS SU2_CFD SU2_config.cfg
      mv restart_flow.dat solution_flow.dat
      SU2_SOL SU2_config.cfg

      # Solution storage
      echo
      echo storing the solution

      cp flow.vtk $SOL_DIR/${i}.vtk

      echo
      echo flow computed, solution stored.

    done
    cp SU2_config.cfg $SOL_DIR/Re${Re}.cfg
    cp !(*.su2|*.sh|*.vtk|*.cfg) $SOL_DIR/.
    cd $HOME_DIR
    SOL_DIR=$OLD_MESH
  done
  SOL_DIR=$OLD_PROBLEM
done

shopt -u extglob
