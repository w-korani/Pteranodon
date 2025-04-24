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
bootstrap.sh -gfa TestProc.gfa  -t 4
```
```
LibraryProc.sh -gfa TestProc.gfa -r1 fastqs/sample1.fq.gz -id S01 -t 4
LibraryProc.sh -gfa TestProc.gfa -r1 fastqs/sample2.fq.gz -id S02 -t 4
LibraryProc.sh -gfa TestProc.gfa -r1 fastqs/sample3.fq.gz -id S03 -t 4
```
```
CombineDS.sh -gam gams -gfa TestProc.gfa -min 1 -max 10 -o TestSet1.panmap -t 4 -l Set1.list
```
```
panmapFilterMissingSample TestSet1.panmap 0.9
panmapFilterMissingVariant TestSet1.Smiss0.9.panmap 0.75
panmapFilterMAF TestSet1.Smiss0.9.miss0.75.panmap 0.05
panmapGetDiAlleles TestSet1.Smiss0.9.miss0.75.MAF0.05.panmap
panmapGetDiAlleles TestSet1.Smiss0.9.miss0.75.MAF0.05.DiAllelic.panmap
panmapGetHomoPolymorphic TestSet1.Smiss0.9.miss0.75.MAF0.05.DiAllelic.DiAllelic.panmap
panmapGetSV TestSet1.Smiss0.9.miss0.75.MAF0.05.DiAllelic.DiAllelic.HomoPolymorphic.panmap
panmapAlleleFreqStats TestSet1.Smiss0.9.miss0.75.MAF0.05.DiAllelic.DiAllelic.HomoPolymorphic.SV.panmap > stat1
hapmapAlleleTypeFreq TestSet1.Smiss0.9.miss0.75.MAF0.05.DiAllelic.DiAllelic.HomoPolymorphic.SV.panmap > stat2
```

<div align="center">
  <img width="500" alt="Image" src="https://github.com/user-attachments/assets/5ef2d8ff-e97b-4b97-a6f6-b63ba1a0b656" />
</div>


## Citation
comming soon
