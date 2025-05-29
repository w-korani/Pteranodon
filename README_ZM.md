<div align="center">
  <center><h1>Pteranodon</h1></center>
  <center><h2>A tool for assembly of contigs/scaffolds referenced to another genome</h2></center>
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
   cd Pteranodon
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

Pteranodon is a three-step process comprising an initial bash script, an interactive R Shiny Application, and a final bash script that outputs a corrected FASTA file.

1. PteranodonBase.sh: Align a reference FASTA file with a query FASTA file and produce an RDS file for interactive editing.
   ```
   PteranodonBase.sh
   -ref         # /path/to/ref.fa (required)
   -query       # /path/to/query.fa (required)
   -o           # output file name (optional; default is PteranodonOUT)
   -SegLen      # query sequences are split into segments of this length; units are in bases
   -MinQueryLen # filters out small contigs; units are in Megabases
   -ScafPer     # query sequences below this percentage out of ref matches are excluded
   -t           # number of threads (optional; default is 1)
   -h           # display help function
   ```
2. Pteranodon Wings v2: https://w-korani.shinyapps.io/pteranodonwingsv2/.

Split, invert, and join contigs using point-and-click tools in an R Shiny App. The selected edits will generate a set of commands in a .sh file for download and use in the next step. A step-by-step guide of the app functionality can be found in the example code below.

3. PteranodonRecurrent.sh: Apply the changes selected in Pteranodon Wings and output a modified FASTA file.
   ```
   PteranodonRecurrent.sh
   -script # /path/to/2025-05-20.sh (the file downloaded from Pteranodon Wings; required)
   -query  # /path/to/query.fa (required)
   -o      # the output file name including the file extension, e.g. output_file.fa
   -h      # display help function
   ```
These three steps may be repeated as needed.


## Tutorial: Get to know Pteranodon with example data
It is highly recommended to follow this tutorial for an understanding of how to use the R Shiny App **Pteranodon Wings**. The data for this tutorial can be found in the file **TestingData.zip**.

1. Unzip the example data.
```
unzip TestingData.zip
```
2. Run PteranodonBase.sh with the files **ref.fa** and **query.fa** as input to produce the file **test_out.rds**.
```
PteranodonBase.sh -ref ref.fa -query query.fa -o test_out -SegLen 1000 -MinQueryLen 3 -ScafPer 0.2
```
3. In a web browser, go to https://w-korani.shinyapps.io/pteranodonwingsv2/. Click the Browse button and select the .rds file to upload to Pteranodon Wings.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/eeb413d6-1f7a-4e53-9062-451988e17786" />
</div>

4. Select TRv2.Chr03 from the dropdown menu.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/3745b2e5-0c55-4364-b25b-cdbc978a35bc" />
</div>

5. One of the three contigs on chromosome 3 is inverted. Using the split command, click on the rightmost end of the inverted contig to select the splitting position coordinate. Then click the add button.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/66c1b560-8915-4ac6-a298-04bfd771b362" />
</div>

Adding the split command will result in two new chromosomal segments consisting of the sequences on either side of the splitting position coordinate. Additionally, a Pteranodon command (e.g. Ptr.split) will appear in a box below the add button. Subsequent commands will generate below this Ptr command.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/b8fce5ec-4e4e-4b17-979d-2b73946bc89f" />
</div>

6. Select the invert command and the ID of the inverted chromosomal segment chr03_P1. Click the add button to generate a new chromosomal segment in the proper orientation and its accompanying Ptr command.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/ded00034-9e9e-4c87-b056-1b37f57b8a84" />
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/141c4519-bb42-4c0b-b062-5daf01dc703e" />
</div>

7. Select the join command and choose the newly oriented chromosomal segment from the list of IDs. From the “joining with…” dropdown menu, select the segment chr03_P2. Click the add button to generate a new chromosomal segment joining the corrected first segment with the rest of the chromosome, along with its accompanying Ptr command.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/5f4944e2-a0da-4b96-b2d3-72ced5efd1b5" />
</div>

8. Select the rename command and choose the corrected full chromosome from the list of IDs, then click the add button.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/6e2b7072-459c-4f22-9432-59712183e303" />
</div>

9. Click the “generate script file” button to download a .sh file containing the four Ptr commands generated through the interactions in the Shiny App. This script file will be used as input for the next Pteranodon script.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/7e4b88f9-e41c-42af-a18b-f2caf43891b6" />
</div>

10. Run PteranodonRecurrent.sh with the generated script file as input to produce the file **recurrent_test_out.fa** with the corrected inversion on chromosome 3.
```
PteranodonRecurrent.sh -script data-2025-05-20.sh -query query.fa -o recurrent_test_out.fa
```

<div align="center">
  <img width="500" alt="Image" src="https://github.com/user-attachments/assets/926ce715-1053-46b9-818e-6e6fe76b325d" />
</div>


## Citation
Pteranodon is currently in pre-publication.
