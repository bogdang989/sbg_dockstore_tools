class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://sevenbridges.com'
baseCommand:
  - /opt/bin/muse.py
inputs:
  - id: bam_inputs
    type: 'File[]'
    label: Input BAM Files
    doc: Tumor/Normal pair of input BAM files.
    secondaryFiles:
      - .bai
  - id: reference
    type: File
    inputBinding:
      position: 0
      prefix: '-f'
    label: Reference GZ
    doc: Reference FASTA/FA file.
  - id: known
    type: File
    inputBinding:
      position: 0
      prefix: '-D'
    label: dbsnp
    doc: Known variants database - dbSNP.
  - id: mode
    type:
      type: enum
      symbols:
        - wgs
        - wxs
      name: mode
    inputBinding:
      position: 0
      prefix: '--mode'
      shellQuote: false
    label: Mode
    doc: WGS or WES mode (Genome or Exome).
outputs:
  - id: mutations
    doc: Output VCF file.
    label: Output VCF
    type: File
    outputBinding:
      glob: '*.vcf'
      outputEval: >-
        ${return [].concat(inheritMetadata([].concat(self)[0],
        inputs.bam_inputs))[0]}
doc: >-
  The Muse workflow from the ICGC PanCancer Analysis of Whole Genomes (PCAWG)
  project, used in harmonization of the ICGC dataset.   

  ![pcawg
  logo](https://raw.githubusercontent.com/ICGC-TCGA-PanCancer/pcawg_delly_workflow/2.0.0/img/PCAWG-final-small.png
  "pcawg logo")


  PCAWG MuSE variant calling workflow is developed by MD Anderson Cancer Center

  (http://bioinformatics.mdanderson.org/main/MuSE), it consists of software
  component calling structural variants using uniformly aligned tumor / normal
  WGS sequences. The workflow has been dockerized and packaged using CWL
  workflow language, the source code is available on
  [GitHub](https://github.com/ICGC-TCGA-PanCancer/pcawg-muse).  


  For more information see the PCAWG project [page](https://dcc.icgc.org/pcawg)
  and the GitHub [page](https://github.com/ICGC-TCGA-PanCancer) for the code
  including the source for [this
  workflow](https://github.com/ICGC-TCGA-PanCancer/pcawg-muse).  


  *A list of **all inputs and parameters** with corresponding descriptions can
  be found at the bottom of the page.*



  ### Common Use Cases

  This tool is used to call variants from Tumor/Normal pair of BAM files,
  previoulsy generated by using the **ICGC-PCAWG-Seqware-BWA-Workflow** tool
  available in **Public Apps**, in the same manner as the VCF files in the ICGC
  PCAWG dataset. To do this, set:

  - Tumor/Normal pair in BAM format, provided via **Input BAM Files** port.

  - Reference file **pcawg.icgc.genome.fa.gz** via **Reference GZ** port. This
  file is available in **Public Reference Files**.

  - Known dbSNP entries **dbsnp_132_b37.leftAligned.vcf.gz** via **dbsnp** port.
  This file is available in **Public Reference Files**.

  - Input **mode** for whole genome or whole exome sequencing data (**wgs** or
  **wes**).

  - For running the tool you need to copy the reference files to your project.


  ### Changes Introduced by Seven Bridges


  Tool was modified to optimize for cloud execution and make the usage easier.
  Modifications of the tool include:

  - Adding stdout redirection to a file that is saved with other logs
  (stdout.log).

  - Inheriting SBG metadata from input BAM files.

  - Setting an optimal instance for the tool (c4.2xlarge, See Performance
  Benchmarking below).

  - Added JS expressions to derive output name from input BAM Case ID metadata.

  - Tumor and Normal inputs merged into a single input to enable batching by
  **Case ID**. Normal and tumor are distinguished in JS expression by using
  metadata field **Sample Type**. 

  - Description updated to include additional information and common issues.  
    
  NOTE: Tool modifications do not affect the final result.


  ### Common Issues and Important Notes


  - Please use the reference files **pcawg.icgc.genome.fa.gz** and
  **dbsnp_132_b37.leftAligned.vcf.gz**, available in **Public Reference Files**.

  - Make sure that the reads are aligned to the **pcawg.icgc.genome.fa.gz**
  reference, using the public app **ICGC-PCAWG-Seqware-BWA-Workflow**.

  - Metadata fields **Sample Type** and **Case ID** are required for execution.

  - Metadata field **Case ID** must be the same in both Tumor and Normal BAM
  files.

  - **Sample type** metadata field for Normal sample BAM **must** contain the
  word **"Normal"** and the same field in Tumor sample BAM metadata must not
  contain the word **"Normal"**.


  ### Performance Benchmarking


  The following table shows examples of run time and cost.  

  *Cost can be reduced with **spot instance** usage. Visit [knowledge
  center](https://docs.sevenbridges.com/docs/about-spot-instances) for more
  details.*  

  | Input BAM sizes (Tumor+Normal) | Cost  | Duration | Instance Type (AWS) |

  |----------------|-------|----------|----------|

  | 120+40GB        | 2.28$ | 9h 4m  | c4.2xlarge       |

  | 5+4GB        | 0.12$ | 27m   | c4.2xlarge     |
label: ICGC PCAWG MuSE Workflow
arguments:
  - position: -1
    shellQuote: false
    valueFrom: "${\n\n  function common_substring(a,b) {\n    var i = 0;\n\n    while(a[i] === b[i] && i < a.length)\n      i = i + 1;\n\n    return a.slice(0, i);\n  }\n\n  var basename = ''  \n  \n  if (inputs.bam_inputs)\n  {\n    var reads = [].concat(inputs.bam_inputs)\n    \n    if (reads[0].metadata && reads[0].metadata['case_id'])\n    {\n    \tbasename = reads[0].metadata['case_id'].replace(' ', '_').replace('-', '_')\n    }\n    else\n    {\n        basename = reads[0].path.split('/').pop()\n\n        for(var i=0; i<reads.length; i++)\n          basename = common_substring(basename, reads[i].path.split('/').pop())\n\n        if(basename.indexOf('.') > -1){\n          tmp = basename.split('.')\n          ext_check = tmp.pop()\n          if(ext_check.length == 3)\n            basename = tmp.join('.')\n        }\n    }\n  }\n  \n  if(inputs.run_id){\n    if(inputs.run_id.indexOf('.') > -1){\n      tmp = inputs.run_id.split('.')\n      ext_check = tmp.pop()\n      if(ext_check.length == 3)\n        basename = tmp.join('.')\n    }\n    else{\n      basename = inputs.run_id\n    }\n\n    if(basename.slice(-1) == '.' || basename.slice(-1) == '-')\n      basename = basename.slice(0,-1)\n  }\n  \n  if(basename == '')\n    basename = 'combined'\n  \n  if(basename.slice(-1) == '.' || basename.slice(-1) == '-')\n    basename = basename.slice(0,-1)\n\n  return \"-O \" + basename + \".vcf -w ./ --muse MuSEv1.0rc\"\n}"
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: "${\n \tfor (i=0;i<inputs.bam_inputs.length;i++) {\n \t    if (!inputs.bam_inputs[i].metadata['sample_type']) throw('Please set sample_type metadata')\n   \t\tif (inputs.bam_inputs[i].metadata['sample_type'].toLowerCase().search('normal') !== -1)\n    \t\treturn '--normal-bam ' + inputs.bam_inputs[i].path\n \t}\n}"
  - position: 0
    shellQuote: false
    valueFrom: "${\n \tfor (i=0;i<inputs.bam_inputs.length;i++) {\n \t     if (!inputs.bam_inputs[i].metadata['sample_type']) throw('Please set sample_type metadata')\n   \t\tif (inputs.bam_inputs[i].metadata['sample_type'].toLowerCase().search('normal') == -1)\n    \t\treturn '--tumor-bam ' + inputs.bam_inputs[i].path\n \t}\n}"
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/bogdang/pcawg-muse:1.0'
  - class: InlineJavascriptRequirement
    expressionLib:
      - '        function common_substring(a,b) { var i = 0; while(a[i] === b[i] && i < a.length) { i = i + 1; } return a.slice(0, i) }; var output_basename = function() { if (inputs.output_file_basename) { return inputs.output_file_basename } else{ arr = [].concat(inputs.reads); base = arr[0].path.replace(/^.*[/]/, '''').split(''.'').slice(0, -1).join(''.''); for(i=0;i<arr.length;i++){ base = common_substring(base, arr[i].path.replace(/^.*[/]/, '''').split(''.'').slice(0, -1).join(''.'')); if (base.length == 0) base = ''PCAWG_Aligned'' } return ''PCAWG.'' + base } }; var updateMetadata = function(file, key, value) { file[''metadata''][key] = value; return file; }; var setMetadata = function(file, metadata) { if (!(''metadata'' in file)) file[''metadata''] = metadata; else { for (var key in metadata) { file[''metadata''][key] = metadata[key]; } } return file }; var inheritMetadata = function(o1, o2) { var commonMetadata = {}; if (!Array.isArray(o2)) { o2 = [o2] } for (var i = 0; i < o2.length; i++) { var example = o2[i][''metadata'']; for (var key in example) { if (i == 0) commonMetadata[key] = example[key]; else { if (!(commonMetadata[key] == example[key])) { delete commonMetadata[key] } } } } if (!Array.isArray(o1)) { o1 = setMetadata(o1, commonMetadata) } else { for (var i = 0; i < o1.length; i++) { o1[i] = setMetadata(o1[i], commonMetadata) } } return o1; };'
stdout: stdout.log
'sbg:categories':
  - CWL1.0
  - Variant Calling
