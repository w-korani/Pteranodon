#!/bin/bash -i
##################
source /cluster/projects/khufu/qtl_seq_II/khufu_II/utilities/KhufuEnvVer2.sh
source /cluster/projects/khufu/korani_projects/KhufuEnv/KhufuEnv.sh
# module load cluster/bwa/0.7.17
##################
helpFunc()
{
   "$khufu_dir"/utilities/logo.sh
   echo -e "Usage:         \033[46m$0 -ref ref -query query -SegLen SegLen -t 4\033[0m
   \033[46m-t\033[0m           NumOfThread
   \033[46m-/--ref\033[0m   reference genome fasta
   \033[46m-/--query\033[0m scaffolds' or contigs' query fasta
   \033[46m-/-o\033[0m  the output folder and prefix
   \033[46m-/--SegLen\033[0m  query sequences are split into  segments of this size in bases
   \033[46m-/--MinQueryLen\033[0m  query sequences less than this this megabases are excluded
   \033[46m-/--ScafPer\033[0m  query seqeunces less than this percentage out of ref matches are excluded "
   exit 1
}
##################
ref=""
query=""
out=""
t=4
SegLen=1000
MinQueryLen=10
ScafPer=0.1
##################
##################
SOPT='t:o:h'
LOPT=('ref' 'query' 'SegLen' 'MinQueryLen' 'ScafPer')
OPTS=$(getopt -q -a --options ${SOPT} --longoptions "$(printf "%s:," "${LOPT[@]}")" --name "$(basename "$0")" -- "$@")
eval set -- $OPTS
while [[ $# > 0 ]]; do
    case ${1} in
		-h) helpFunc ;;
		-t) t=$2 && shift ;;
      -o) out=$2 && shift ;;
		--ref) ref=$2 && shift ;;
		--query) query=$2 && shift ;;
		--SegLen) SegLen=$2 && shift ;;
		--MinQueryLen) MinQueryLen=$2 && shift ;;
      --ScafPer) ScafPer=$2 && shift ;;
		esac
    shift
done
##################
if [[ $out == "" ]]; then out="PteranodonOUT"; echo "output dir was not set; PteranodonOUT will be used" ; fi
if [[ $ref == "" ]]; then echo "ref should be provided" ; exit 0; fi
if [[ $query == "" ]]; then echo "query should be provided" ; exit 0; fi
##################
echo "t=$t"
echo "out=$out"
echo "ref=$ref"
echo "query=$query"
echo "SegLen=$SegLen"
echo "MinQueryLen=$MinQueryLen"
echo "ScafPer=$ScafPer"
##################
if [ -d "$out" ] ; then rm -r "$out"; fi
mkdir "$out"
ref=$(readlink -f "$ref")
query=$(readlink -f "$query")
currDir=$(pwd)
###
# ref processing
fastaSeqLen "$ref" | sort -Vrk2 > "$out"/ref.stat
mkdir "$out"/ref
cat $ref > "$out"/ref/ref.fa
bwa index "$out"/ref/ref.fa
###
# query procssing
fastaFilterLen "$query" $(($MinQueryLen*1000000)) > "$out"/Query.fa
fastaSeqLen "$out"/Query.fa | sort -Vrk2 > "$out"/Query.stat
fasta2kmer "$out"/Query.fa "$SegLen" "$SegLen" > "$out"/Query.seg.fa
###
## mapping, filtering & reformating
bwa mem -M -t $t "$out"/ref/ref.fa "$out"/Query.seg.fa -o "$out"/Query.sam
cat "$out"/Query.sam | grep -v 'SA:Z:' |awk '{if($5==60 || $5 == "") print($0)}' | grep -v '@' | cut -f1-6 | awk -v SegLen=$""$SegLen"M" '{if($6 == SegLen) {print $0} }' | tr '_' '\t'  | cut -f 1,2,4,5 | sort -k3,3V -k4,4n | awk -v SegLen=$SegLen 'OFS="\t"{print $1,($2*SegLen)-SegLen,$3,$4}'  > "$out"/Query.sam2
cat "$out"/Query.sam2 | awk '{print $1"%"$3"\t"$0}' > "$out"/Query.sam2.txt1
cat "$out"/Query.sam2.txt1 | cut -f 1,4 | sort | uniq -c | sed -E "s:^ +::g" | tr ' ' '\t' | awk -v SegLen=$SegLen '{print $3"\t"$2"\t"$1*SegLen}' > "$out"/Query.sam2.txt2
merge "$out"/Query.sam2.txt2 "$out"/ref.stat | grep -vw "NA" | awk -v ScafPer=$ScafPer '{if($3/$4>ScafPer) {print $2}}' > "$out"/Query.sam2.txt3
merge "$out"/Query.sam2.txt3 "$out"/Query.sam2.txt1 > "$out"/Query.sam3
##################
Rscript -e 'args = commandArgs(trailingOnly=TRUE)
A = as.data.frame(data.table::fread(args[1],header=FALSE))
OUT=list()
for( id in unique(A$V1) ) {  
B = A[A$V1==id,c(3,5)]
colnames(B)=c("pos1","pos2")
OUT[[id]] <- B
}
saveRDS(OUT,args[2]) ' "$out"/Query.sam3 "$out".rds
##################
# names(OUT) <- gsub("[.]","",names(OUT))
