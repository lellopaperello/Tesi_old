#!/bin/bash

shopt -s extglob

HOME_DIR=$PWD
VBLC_DIR=$HOME_DIR/Prova_Make

#ALFA_LIST="2"# 4 6"
#MU_LIST=(0.15)# 0.20 0.25 0.30)
#THETA_LIST="5"# 6 7 8 9 10 11 12"
CYC_LIST=(1)
MU_LIST=(0.15)
ALFA_LIST="2"
THETA_LIST=(5)

cd $VBLC_DIR

for ALFA_SH in $ALFA_LIST; do
   for ((IMU=0; IMU<=0; IMU++)); do
		for ((ITH=0; ITH<=0; ITH++)); do

         THETA=${THETA_LIST[$ITH]}
			MU=${MU_LIST[$IMU]}

			CYC=${CYC_LIST[$((($IMU + 1)*$ITH))]}

         V_INF=`echo "100.53 * $MU / c ($ALFA_SH*0.01745329)" | bc -l`

         sed -i 's/^param_rotor_file\s=.*$/param_rotor_file = P'$ALFA_SH'.dat/' $VBLC_DIR/parametri.in
			sed -i 's/^rotor_file\s=.*$/rotor_file = R'$ALFA_SH'.dat/' $VBLC_DIR/parametri.in
			sed -i 's/^coll_pitch\s=.*$/coll_pitch = '$THETA'/' $VBLC_DIR/parametri.in
			sed -i 's/^Vinf\s=.*$/Vinf = '$V_INF' 0.0 0.0/' $VBLC_DIR/parametri.in
			sed -i 's/^long_pitch\s=.*$/long_pitch = '$CYC'/' $VBLC_DIR/parametri.in

			$VBLC_DIR/VBLC

         mkdir -p $HOME_DIR/simulazioni/as_${ALFA_SH}_mu_${MU}_th_${THETA}
			mv simulazione/* $HOME_DIR/simulazioni/as_${ALFA_SH}_mu_${MU}_th_${THETA}/.



		done
	done
done
