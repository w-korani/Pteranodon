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
   cd Pteranodon
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

## Implementation

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
   -auto        # automatically assemble contigs and produce a FASTA file (automating steps 2 and 3 below)
   -h           # display help function
   ```
2. Pteranodon Wings v2: https://w-korani.shinyapps.io/pteranodonwingsv2/.

Split, invert, and join contigs using point-and-click tools in an R Shiny App. The selected edits will generate a set of commands in a .sh file for download and use in the next step. A step-by-step guide of the app functionality can be found in the example code below.

3. PteranodonRecurrent.sh: Apply the changes selected in Pteranodon Wings and output a modified FASTA file.
   ```
   PteranodonRecurrent.sh
   -script # /path/to/2025-05-30.sh (the file downloaded from Pteranodon Wings; required)
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

4. Select TRv2.Chr02 from the dropdown menu.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/bdede8f8-bb8c-4913-8c65-5a7fa2fae257" />
</div>

5. Contig2 on chromosome 2 is inverted. Select Contig2 and the invert command, then click the add button.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/d942c5ea-60b1-4e59-9bc0-78c7075b58b6" />
</div>

6. Adding the invert command will result in a new inverted contig called Contig2_RC. A Pteranodon command (e.g. Ptr.RevComp) will also appear in a box below the add button. Subsequent commands will generate below this Ptr command.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/be39fb5e-4ce3-49ce-97e6-30ceb5e550e4" />
</div>

7. Select the join command and choose Contig4 from the list of IDs. From the “joining with…” dropdown menu, select the segment Contig2_RC. Click the add button to generate a new chromosomal segment joining the two contigs called Contig4_J_Contig2_RC, along with its accompanying Ptr command.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/2aebe8d0-be71-4341-a030-5237b536d43e" />
</div>

<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/c02415a8-7b59-421a-b3d6-f4b98526140e" />
</div>

8. With the join command still selected, choose Contig4_J_Contig2_RC from the list of IDs. From the “joining with…” dropdown menu, select the segment Contig1 and click the add button.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/5291af0a-151a-407d-89a6-938663c12276" />
</div>
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/6e59c260-e8de-4dd4-bcb7-93b60401e078" />
</div>

9. Select the rename command and choose Contig4_J_Contig2_RC_J_Contig1 from the list of IDs, then click the add button.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/070c3973-2c08-4136-bd37-17e1e97cbb16" />
</div>

10. Click the “generate script file” button to download a .sh file containing the four Ptr commands generated through the interactions in the Shiny App. This script file will be used as input for the next Pteranodon script.
<div align="center">
  <img width="750" alt="Image" src="https://github.com/user-attachments/assets/99e985f2-5929-4ea5-9073-08eac896568a" />
</div>

11. Run PteranodonRecurrent.sh with the generated script file as input to produce the file **recurrent_test_out.fa** with the corrected assembly for chromosome 2.
```
PteranodonRecurrent.sh -script data-2025-05-30.sh -query query.fa -o recurrent_test_out.fa
```





## Citation
Pteranodon is currently in pre-publication.
