<div align="center">
  <center><h1>Pteranodon</h1></center>
  <center><h2>A tool for assemble contigs/scaffolds referenced to another genome</h2></center>
  <img width="500" alt="Image" src="https://github.com/user-attachments/assets/e905befa-2785-40e5-b0da-a11748ea1137" />
</div>

## Requirements
### KhufuPAN
- **KhufuEnv:** https://github.com/w-korani/KhufuEnv
- **bwa:** https://bio-bwa.sourceforge.net/


## Implementation & Getting Help

1. comparing the query genome to the reference genome and produce RDS object
   ```
   PteranodonBase.sh -h
   ```
2. customizing the comparision of the RDS object usign Rshiny app.
   ```
   https://w-korani.shinyapps.io/pterandon_wings/
   ```
3. executing the customization
   ```
   PteranodonRecurrent.sh -h
   ```
The three steps may be repeated as needed.


## Example code
```
PteranodonBase.sh -t 4 -ref ref.genome -query query.genome \
       -o PtrOut -SegLen 1000 -MinQueryLen 10 -ScafPer 0.1
```
```
https://w-korani.shinyapps.io/pterandon_wings/
```
```
PteranodonRecurrent.sh -script PtrWinExec.sh -query query.genome -o query.genome.fa
```

<div align="center">
  <img width="500" alt="" />
</div>


## Citation
comming soon
