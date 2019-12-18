#!/bin/bash

########### SLURM CONFIGURATION ############

# Name of the job
#SBATCH --job-name=spherocylinder
#SBATCH --output=spherocylinder-%j.out
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
SIMULATION_DIR=${HOME_DIR}/simulation/scale3-5
SOL_DIR=${HOME_DIR}/solution/scale3-5
LOG_DIR=${HOME_DIR}/logs

# Problem declaration
PROBLEM_LIST=("spherocylinder")
MESH_LIST=("scale3" "scale4" "scale5")
RE_LIST="10 300"

# Parameters
RHO=1.2886
MU=0.00001716
D=4.0817

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
    for Re in $RE_LIST; do
      echo solving problem at Reynolds $Re with mesh $MESH
      echo

      cd $SIMULATION_DIR

      if [ ${#RE_LIST[@]} -gt 0 ]; then
        OLD_RE=$SOL_DIR
        SOL_DIR=$SOL_DIR/Re$Re

        # Velocity calculation
        V_INF=$(echo "$Re * $MU / ($RHO * $D)" | bc -l)

        echo Generating the configuration file..
        echo

        sed -i 's/^INC_VELOCITY_INIT=.*$/INC_VELOCITY_INIT= ( '$V_INF', 0.0, 0.0 )/' SU2_config.cfg
      fi

      # Cleaning data
      echo cleaning..
      echo

      rm -v !(*.cfg|*.su2)

      # Flow computation
      echo
      echo computing the flow..

      mpirun -n $SLURM_NTASKS $MPI_FLAGS SU2_CFD SU2_config.cfg
      mv restart_flow.dat solution_flow.dat
      SU2_SOL SU2_config.cfg

      # Solution storage
      echo
      echo storing the solution

      if [ ${#RE_LIST[@]} -gt 0 ]; then
        mkdir -p $SOL_DIR
        cp SU2_config.cfg $SOL_DIR/Re${Re}.cfg
        cp flow.vtk $SOL_DIR/Re${Re}.vtk
        cp !(*.su2|*.sh|*.vtk|*.cfg) $SOL_DIR/.

        SOL_DIR=$OLD_RE
      else
        mkdir -p $SOL_DIR
        cp !(*.su2|*.sh) $SOL_DIR/.
      fi

      echo
      echo flow computed, solution stored.

      cd $HOME_DIR

    done
    SOL_DIR=$OLD_MESH
  done
  SOL_DIR=$OLD_PROBLEM
done

shopt -u extglob
