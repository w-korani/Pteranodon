#!/bin/bash -i
##################
source /cluster/projects/khufu/korani_projects/KhufuEnv/KhufuEnv.sh
source /cluster/projects/khufu/korani_projects/Pteranodon/scripts/utilities.sh
##################
helpFunc()
{
   "$khufu_dir"/utilities/logo.sh
   echo -e "Usage:         \033[46m$0 -script script -query query \033[0m
   \033[46m-/--script\033[0m   input script file produced by Pteranodon_wings
   \033[46m-/--query\033[0m scaffolds' or contigs' query fasta
   \033[46m-/-o\033[0m  the output fasta file "
   exit 1
}
##################
script=""
query=""
outFile=""
##################
##################
SOPT='t:o:h'
LOPT=('script' 'query' )
OPTS=$(getopt -q -a --options ${SOPT} --longoptions "$(printf "%s:," "${LOPT[@]}")" --name "$(basename "$0")" -- "$@")
eval set -- $OPTS
while [[ $# > 0 ]]; do
    case ${1} in
		-h) helpFunc ;;
		-t) t=$2 && shift ;;
      -o) outFile=$2 && shift ;;
		--script) script=$2 && shift ;;
		--query) query=$2 && shift ;;
		esac
    shift
done
##################
if [[ $script == "" ]]; then echo "script should be provided" ; exit 0; fi
if [[ $query == "" ]]; then echo "query should be provided" ; exit 0; fi
if [[ $outFile == "" ]]; then outFile=$(echo $script | sed "s:.*/::g" | sed "s:.sh$:.fa:g" ); echo "output dir was not set; $(echo $outFile | sed "s:[.].*:OUT:g" ) will be used" ; fi
out=$(echo $outFile | sed "s:[.].*:OUT:g" )
##################
echo "outFile=$outFile"
echo "output Dir is "$out""
echo "script=$script"
echo "query=$query"
##################
script=$(readlink -f "$script")
query=$(readlink -f "$query")
currDir=$(pwd)
# out=$(echo $outFile | sed "s:.fa*$::g" )
if [ -d "$out" ] ; then rm -r "$out"; fi
mkdir $out
cd $out
fastaSplit $query
cd fastaCHRs
cat $script  | while read -r com
do
   echo $com
   eval $com
done
cd "$currDir"
cat "$out"/fastaCHRs/RN_*.fa > "$outFile"
##################