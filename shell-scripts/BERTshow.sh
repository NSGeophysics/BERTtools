# INPUT:
#
# 1) path to data
# 2) cmin
# 3) cmax


pytripatch --cellBrowser -d $1/resistivity.vector --cMin=$2 --cMax=$3 -i 3 --coverage=$1/coverage.vector $1/mesh/meshParaDomain.bms
