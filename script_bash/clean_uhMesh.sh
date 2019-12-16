#!/bin/bash

shopt -s extglob

echo cleaning...

rm -v !(*.cfg|*.sh)

shopt -u extglob
