#!/bin/bash

########### SLURM CONFIGURATION ############

# Name of the job
#SBATCH --job-name=cylinder
#SBATCH --output=cylinder_uhMesh.out
#SBATCH --no-requeue

# Number of nodes, number of cores per node
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --ntasks-per-core=1
#SBATCH --exclude=minion01,minion03 # Non working minions

# Quality of service
#SBATCH --qos=default-users

############################################

shopt -s extglob

# Variable declaration

# MPI_FLAGS='--bind-to core --report-bindings'
MPI_FLAGS=''

HOME_DIR=$PWD
CONFIG_DIR=${HOME_DIR}/config
GRID_DIR=${HOME_DIR}/grid
SIMULATION_DIR=${HOME_DIR}/simulation
SOL_DIR=${HOME_DIR}/solution
LOG_DIR=${HOME_DIR}/logs

# Problem declaration
PROBLEM_LIST=()
MESH_LIST=()
RE_LIST=

# Parameters
RHO=1.2886
MU=0.00001716
D=1

# Environment creation
mkdir -p $SIMULATION_DIR $SOL_DIR $LOG_DIR

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
      fi
    fi
    for Re in $RE_LIST; do
      for alpha in $ALPHA_LIST; do
        cd $SIMULATION_DIR

        # Cleaning data
        echo cleaning..
        echo

        rm -v !(*.cfg|*.su2)

        echo Restarting problem at Reynolds $Re and alpha $alpha with mesh $MESH
        echo

        # Recovering previous solution
        if [ $(wc -w <<< $RE_LIST) -gt 1 ]; then
          OLD_RE=$SOL_DIR
          SOL_DIR=$SOL_DIR/Re$Re
          if [ $(wc -w <<< $ALPHA_LIST) -gt 1 ]; then
            OLD_ALPHA=$SOL_DIR
            SOL_DIR=$SOL_DIR/a$alpha
          fi
        fi

        cp $SOL_DIR/solution_flow.dat .
        cp $SOL_DIR/*.cfg .

        # Flow computation
        echo
        echo computing the flow..

        mpirun -n $SLURM_NTASKS $MPI_FLAGS SU2_CFD SU2_config.cfg
        mv restart_flow.dat solution_flow.dat
        SU2_SOL SU2_config.cfg

        # Solution storage
        echo
        echo storing the solution

        SOL_DIR=${SOL_DIR}_restarted

        mkdir -p $SOL_DIR
        if [ $(wc -w <<< $RE_LIST) -gt 1 ]; then
          if [ $(wc -w <<< $ALPHA_LIST) -gt 1 ]; then
            cp SU2_config.cfg $SOL_DIR/a${alpha}.cfg
            cp flow.vtk $SOL_DIR/a${alpha}.vtk
            cp !(*.su2|*.sh|*.vtk|*.cfg) $SOL_DIR/.

            SOL_DIR=$OLD_ALPHA
          else
            cp SU2_config.cfg $SOL_DIR/Re${Re}.cfg
            cp flow.vtk $SOL_DIR/Re${Re}.vtk
            cp !(*.su2|*.sh|*.vtk|*.cfg) $SOL_DIR/.
          fi
          SOL_DIR=$OLD_RE
        else
          if [ $(wc -w <<< $ALPHA_LIST) -gt 1 ]; then
            cp SU2_config.cfg $SOL_DIR/a${alpha}.cfg
            cp flow.vtk $SOL_DIR/a${alpha}.vtk
            cp !(*.su2|*.sh|*.vtk|*.cfg) $SOL_DIR/.

            SOL_DIR=$OLD_ALPHA
          else
            cp !(*.su2|*.sh) $SOL_DIR/.
          fi
        fi

        echo
        echo flow computed, solution stored.

        cd $HOME_DIR
      done
    done
    SOL_DIR=$OLD_MESH
  done
  SOL_DIR=$OLD_PROBLEM
done

shopt -u extglob
