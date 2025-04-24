<div align="center">
  <center><h1>Pteranodon</h1></center>
  <center><h2>A tool for assemble contigs/scaffolds referenced to another genome</h2></center>
  <img width="500" alt="Image" src="https://github.com/user-attachments/assets/e905befa-2785-40e5-b0da-a11748ea1137" />
</div>

## Requirements
### KhufuPAN
- **KhufuEnv:** https://github.com/w-korani/KhufuEnv
- **bwa:** https://bio-bwa.sourceforge.net/

## Installation

1. Download the package.
   ```
   git clone https://github.com/w-korani/Pteranodon
   ```
2. Go to the package folder.
   ```
   cd Pteranodon_main
   ```
3. Run the installer.
   ```
   sudo bash ./installer.sh
   ```
4. Add the source for the Bash Shell Environment.
   ```
   echo "source /etc/Pteranodon/call.sh"  >>  ~/.bashrc
   ```
5. Refresh the Bash Shell Environment.
   ```
   . ~/.bashrc
   ```


## Uninstallation
1. Go to the package folder.
   ```
   cd Pteranodon_main
   ```
2. Run the uninstaller.
   ```
   sudo bash ./uninstaller.sh
   ```
3. Remove the source for the Bash Shell Environment.
   ```
   sed -i "/^source \/etc\/Pteranodon\/call.sh$/d"  ~/.bashrc
   ```
4. Refresh the Bash Shell Environment.
   ```
   . ~/.bashrc  
   ```
   or
   ```
   exec bash
   ```

## Implementation & Getting Help

1. comparing the query genome to the reference genome and produce RDS object
   ```
   PteranodonBase.sh -h
   ```
2. customizing the comparision of the RDS object usign Rshiny app.
   ```
   https://w-korani.shinyapps.io/pteranodonwingsv2/
   ```
3. executing the customization
   ```
   PteranodonRecurrent.sh -h
   ```
The three steps may be repeated as needed.


## Example code
```
PteranodonBase.sh -t 4 -ref ref.fa -query query.fa \
       -o PtrOut -SegLen 1000 -MinQueryLen 10 -ScafPer 0.1
```
```
https://w-korani.shinyapps.io/pteranodonwingsv2/
```
```
PteranodonRecurrent.sh -script PtrOut.script -query query.fa -o queryAdjusted.fa
```

<div align="center">
  <img width="500" alt="Image" src="https://github.com/user-attachments/assets/926ce715-1053-46b9-818e-6e6fe76b325d" />
</div>


## Citation
comming soon
