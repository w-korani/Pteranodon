#!/bin/bash -i
##################
source /cluster/projects/khufu/qtl_seq_II/khufu_II/utilities/KhufuEnvVer2.sh
source /cluster/projects/khufu/korani_projects/KhufuEnv/KhufuEnv.sh
# module load cluster/bwa/0.7.17
##################
helpFunc()
{
   echo -e "Usage:         \033[46m$0 -ref ref -query query -SegLen SegLen -t 4\033[0m
   \033[46m-t\033[0m           NumOfThread
   \033[46m-/--ref\033[0m   reference genome fasta
   \033[46m-/--query\033[0m scaffolds' or contigs' query fasta
   \033[46m-/-o\033[0m  the output folder and prefix
   \033[46m-/--SegLen\033[0m  query sequences are split into  segments of this size in bases
   \033[46m-/--MinQueryLen\033[0m  query sequences less than this this megabases are excluded
   \033[46m-/--auto\033[0m   scafolds/contigs will be redirected and assigned automatically to the relative homologe
   "
   exit 1
}
##################
ref=""
query=""
out=""
t=4
SegLen=1000
MinQueryLen=10
auto=0
##################
##################
SOPT='t:o:h'
LOPT=('ref' 'query' 'SegLen' 'MinQueryLen' 'auto')
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
      --auto) auto=$2 && shift ;;
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
echo "auto=$auto"
##################
if [ -d "$out" ] ; then rm -r "$out"; fi
mkdir "$out"
ref=$(readlink -f "$ref")
query=$(readlink -f "$query")
currDir=$(pwd)
###
# ref processing
fastaSeqLen "$ref" | sort -Vrk2 > "$out"/ref.stat
######
if [[ ! -e "$ref".bwt ]]; 
then 
   echo "WARNING: ref index is not found"; 
   mkdir "$out"/ref
   cat $ref > "$out"/ref/ref.fa
   bwa index "$out"/ref/ref.fa
   ref=""$out"/ref/ref.fa"
fi
# mkdir "$out"/ref
# cat $ref > "$out"/ref/ref.fa
# bwa index "$out"/ref/ref.fa
###
# query procssing
fastaFilterLen "$query" $(echo $MinQueryLen | awk '{print $0*1e6}') > "$out"/Query.fa
fastaSeqLen "$out"/Query.fa | sort -Vrk2 > "$out"/Query.stat
fasta2kmer "$out"/Query.fa "$SegLen" "$SegLen" > "$out"/Query.seg.fa
###
## mapping, filtering & reformating
# bwa mem -M -t $t "$out"/ref/ref.fa "$out"/Query.seg.fa -o "$out"/Query.sam
bwa mem -M -t $t "$ref" "$out"/Query.seg.fa -o "$out"/Query.sam
cat "$out"/Query.sam | grep -v 'SA:Z:' |awk '{if($5==60 || $5 == "") print($0)}' | grep -v '@' | cut -f1-6 | awk -v SegLen=$""$SegLen"M" '{if($6 == SegLen) {print $0} }' | tr '_' '\t'  | cut -f 1,2,4,5 | sort -k3,3V -k4,4n | awk -v SegLen=$SegLen 'OFS="\t"{print $1,($2*SegLen)-SegLen,$3,$4}'  > "$out"/Query.sam2
cat "$out"/Query.sam2 | awk '{print $1"%"$3"\t"$0}' > "$out"/Query.sam2.txt1
cat "$out"/Query.sam2.txt1 | cut -f 1,4 | sort | uniq -c | sed -E "s:^ +::g" | tr ' ' '\t' | awk -v SegLen=$SegLen '{print $3"\t"$2"\t"$1*SegLen}' > "$out"/Query.sam2.txt2
merge "$out"/Query.sam2.txt2 "$out"/ref.stat | grep -vw "NA" | awk '{print $2}' > "$out"/Query.sam2.txt3
merge "$out"/Query.sam2.txt3 "$out"/Query.sam2.txt1 > "$out"/Query.sam3
##########################################################################################
##########################################################################################
##########################################################################################
if [[ $auto == 1 ]]
then
   ##########################################################################################
   currDir=$(pwd)
   cd $out
   fastaSplit $query
   cd $currDir
   mkdir "$out"/CHRs
   tmpFile0001=$(mktemp ""$out"/KhufuEnviron.XXXXXXXXX")
   ###
   for chr in $(cat $out/Query.sam3 | cut -f 4 | sort | uniq)
   do
      echo $chr
      cat $out/Query.sam3 | awk -v chr=$chr '{if($4==chr) {print $0} }' | cut -f 2- | sort -k1,1V -k2,2n > "$out"/CHRs/"$chr"
      cat "$out"/CHRs/"$chr" | cut -f 1,4| sed "1iid\ty" | avg |sed 1d | sort -k2,2n | cut -f 1 > "$out"/CHRs/"$chr".list
      merge "$out"/CHRs/"$chr".list "$out"/CHRs/"$chr" | sed "s:$:\tPtr.$chr:g" > "$out"/CHRs/"$chr".txt2
      Y=0
      for id in $(cat "$out"/CHRs/"$chr".list)
      do
         cat "$out"/CHRs/"$chr".txt2 | awk -v id=$id '{if($1==id) print $0}' > "$out"/CHRs/"$chr"."$id".txt3

if (( $(cat "$out"/CHRs/"$chr"."$id".txt3 | wc -l | awk -v SegLen=$SegLen -v MinQueryLen=$MinQueryLen '{if ($0*SegLen/1e6 > MinQueryLen) {print 1}else{print 0}}') == 0 ))
then
   continue
fi

         X=$(slopeDS "$out"/CHRs/"$chr"."$id".txt3 "V4" "V2" | awk '{if($0>0) {print 1} else {print 0} }')
         if [[ $X == 1 ]]
         then
            cat "$out"/CHRs/"$chr"."$id".txt3 | awk -v Y=$Y 'OFS="\t"{$2=$2+Y; print $0}' > "$out"/CHRs/"$chr"."$id".txt4
            cat "$out"/fastaCHRs/"$id".fa | grep -v ">" >> "$tmpFile0001"
         elif [[ $X == 0 ]]
            then
            paste <(cat "$out"/CHRs/"$chr"."$id".txt3 | cut -f 1-3) <(cat "$out"/CHRs/"$chr"."$id".txt3 | cut -f 4 | revertDS)  <(cat "$out"/CHRs/"$chr"."$id".txt3 | cut -f 5) | awk -v Y=$Y 'OFS="\t"{$2=$2+Y; print $0}' > "$out"/CHRs/"$chr"."$id".txt4
            cat "$out"/fastaCHRs/"$id".fa | fastaUnWrap | sed 1d| tr [:lower:] [:upper:] | rev | sed "s:A:1:g" | sed "s:T:A:g" | sed "s:1:T:g" | sed "s:C:1:g" | sed "s:G:C:g" | sed "s:1:G:g" | fold -w 120 >> "$tmpFile0001"
         fi
         Y=$(cat "$out"/CHRs/"$chr"."$id".txt4  | cut -f 2 | maxCol)
      done 
      cat "$tmpFile0001" | sed "1i>Ptr.$chr" | fastaWrap  > "$out"/CHRs/"$chr".fa4
      cat /dev/null >  "$tmpFile0001"
   done
   ###
   cat "$out"/CHRs/*.fa4 > "$out".fa
   echo ">>> ""$out".fa was produced "<<<"
   cat "$out"/CHRs/*.txt4 | awk '{print $5"%"$3"\t"$0}' > "$out"/Query.sam4
   ##########################################################################################
   Rscript -e 'args = commandArgs(trailingOnly=TRUE)
   library("ggplot2")
   A = as.data.frame(data.table::fread(args[1],header=FALSE))
   B=A[,c(1,3,5,2)]
   colnames(B)=c("chr","pos1","pos2","contig")
   G = ggplot(B,aes(pos1,pos2,color=contig)) + geom_point() + facet_wrap(.~chr, scale="free",ncol=4) + theme(axis.text.x = element_text(angle = 45, vjust = 01, hjust=1)) + theme(legend.position = "bottom")
   pdf(args[2],width=14,height=14); print(G); dev.off()
   ' "$out"/Query.sam4 "$out".pdf
   ##########################################################################################
elif [[ $auto == 0 ]]
then
   cp "$out"/Query.sam3 "$out"/Query.sam4
else
   echo "auto should be 1 or 2"
   exit 0
fi
##########################################################################################
Rscript -e 'args = commandArgs(trailingOnly=TRUE)
A = as.data.frame(data.table::fread(args[1],header=FALSE))
OUT=list()
for( id in unique(A$V1) ) {  
B = A[A$V1==id,c(3,5,2)]
colnames(B)=c("pos1","pos2","contig")
B$pos1 = as.numeric(as.character(B$pos1))
B$pos2 = as.numeric(as.character(B$pos2))
OUT[[id]] <- B
}
saveRDS(OUT,args[2]) ' "$out"/Query.sam4 "$out".rds
echo ">>>" "$out".rds "was produced <<<"
##########################################################################################
##########################################################################################
##########################################################################################