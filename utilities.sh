###########
# P: part
# RC: Reverse Complement
# J: join
# RN: rename
###########
## split_single_scaffold: split
## Reverse Complement: RevComp
## merge_two_scaffolds: merge
###########
###########
Ptr.split(){
local tmpDir0001=$(mktemp -d "./KhufuEnviron.XXXXXXXXX")
cat $1 | fastaUnWrap | awk -v pos=$2 -v dir="$tmpDir0001" '{if(NR==1){X0=$0; gsub(">","",X0); print X0 > dir"/X0.txt" } else if(NR==2) {S=$0; S1=substr(S,1,pos);S2=substr(S,pos+1); print S1 > dir"/X1.fa"; print S2 > dir"/X2.fa" } }'
local id=$(cat "$tmpDir0001"/X0.txt)
cat <(echo ">"$id"_P1" ) <(cat "$tmpDir0001"/X1.fa | fold -w 120 ) > "$id"_P1.fa
cat <(echo ">"$id"_P2" ) <(cat "$tmpDir0001"/X2.fa | fold -w 120 ) > "$id"_P2.fa
rm -rf $tmpDir0001
trap "rm -rf $tmpDir0001" EXIT
}
###########
Ptr.RevComp(){
   local id=$(echo $1 | sed "s:.fa$:_RC:g")
   cat $1 | fastaUnWrap | sed 1d| tr [:lower:] [:upper:] | rev | sed "s:A:1:g" | sed "s:T:A:g" | sed "s:1:T:g" | sed "s:C:1:g" | sed "s:G:C:g" | sed "s:1:G:g" | fold -w 120 | sed "1i>$id" > "$id".fa
}
###########
Ptr.join(){
local id1=$(echo $1 | sed "s:.fa$::g" )
local id2=$(echo $2 | sed "s:.fa$::g" )
cat <(cat $1 | sed 1d ) <(cat $2 | sed 1d )  | fold -w 120 |  sed "1i$(echo ">"$id1"_J_"$id2)"  > $id1"_J_"$id2".fa"
}
###########
Ptr.rename(){
cat $1 | sed 1d | fold -w 120 | sed "1i>$2" > "RN_"$2".fa"
}
###########
###########