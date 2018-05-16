class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: admin/sbg-public-data/tpp-iprophet-5-0-0/10
baseCommand: []
inputs:
  - 'sbg:category': Input Options
    id: category_file
    type: File?
    inputBinding:
      position: 15
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.category_file != undefined) {
                path = inputs.category_file.path
                return 'CAT=' + path
            }
        }
    label: Category File
    doc: Specify file listing peptide categories
  - 'sbg:category': Input Options
    id: decoy_tag
    type: string?
    inputBinding:
      position: 13
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.decoy_tag != undefined) {
                decoy = inputs.decoy_tag
                return 'DECOY=' + decoy
            }
        }
    label: Decoy
    doc: Specify the decoy tag
  - format: PEP.XML
    id: input_files
    type: 'File[]'
    inputBinding:
      position: 51
      shellQuote: false
      valueFrom: |-
        ${
            res = ''
            if (inputs.input_files instanceof Array) {
                for (var i = 0; i < inputs.input_files.length; i++) {
                    res = res + ' '
                    res = res + inputs.input_files[i].path.split('/')[inputs.input_files[i].path.split('/').length - 1]

                }
            } else
                return inputs.input_files.path.split('/')[inputs.input_files.path.split('/').length - 1]
            return res
        }
    label: Input Files
    doc: Input pepXML files
    'sbg:fileTypes': PEP.XML
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: length
    type: boolean?
    inputBinding:
      position: 19
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.length == true) {
                return 'LENGTH'
            }
        }
    label: Length
    doc: Use Peptide Length model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': '1'
    id: max_threads
    type: int?
    inputBinding:
      position: 11
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.max_threads != undefined)
                return 'THREADS=' + inputs.max_threads
            return ''
        }
    label: Threads
    doc: specify threads to use (default 1)
  - 'sbg:category': Input Options
    id: min_prob
    type: float?
    inputBinding:
      position: 17
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.min_prob != undefined) {
                return 'MINPROB=' + inputs.min_prob
            }
        }
    label: Minimum probability
    doc: specify minimum probability of results to report
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nofpkm
    type: boolean?
    inputBinding:
      position: 21
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nofpkm == true) {
                return 'NOFPKM'
            }
        }
    label: NOFPKM
    doc: Do not use FPKM model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nonrs
    type: boolean?
    inputBinding:
      position: 27
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nonrs == true) {
                return 'NONRS'
            }
        }
    label: NONRS
    doc: Do not use NRS model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nonse
    type: boolean?
    inputBinding:
      position: 25
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nonse == true) {
                return 'NONSE'
            }
        }
    label: NONSE
    doc: Do not use NSE model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nonsi
    type: boolean?
    inputBinding:
      position: 35
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nonsi == true) {
                return 'NONSI'
            }
        }
    label: NONSI
    doc: Do not use NSI model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nonsm
    type: boolean?
    inputBinding:
      position: 29
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nonsm == true) {
                return 'NONSM'
            }
        }
    label: NONSM
    doc: Do not use NSM model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nonsp
    type: boolean?
    inputBinding:
      position: 31
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nonsp == true) {
                return 'NONSP'
            }
        }
    label: NONSP
    doc: Do not use NSP model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: nonss
    type: boolean?
    inputBinding:
      position: 23
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.nonss == true) {
                return 'NONSS'
            }
        }
    label: NONSS
    doc: Do not use NSS model
  - 'sbg:category': Input Options
    'sbg:toolDefaultValue': 'False'
    id: sharpnse
    type: boolean?
    inputBinding:
      position: 33
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.sharpnse == true) {
                return 'SHARPNSE'
            }
        }
    label: SHARPNSE
    doc: Use moroe discriminating model for NSE in SWATH mode
outputs:
  - id: output_file
    doc: Output pepXML file
    label: Output File
    type: File?
    outputBinding:
      glob: |-
        ${
            input = ''
            if (inputs.input_files instanceof Array)
                input = inputs.input_files[0].path
            else
                input = inputs.input_files.path
            input = input.split('/')[input.split('/').length - 1]
            prefix = ''
            suf = ''
            if (input.indexOf('xtan') != -1) {
                prefix = input.substring(0, input.indexOf('.xtan'))
                suf = input.substring(input.indexOf('.xtan'), input.length)
            } else {
                prefix = input.substring(0, input.indexOf('.pep'))
                suf = input.substring(input.indexOf('.pep'), input.length)
            }
            return prefix + '.ipro' + suf
        }
      outputEval: |-
        ${
            return inheritMetadata(self, inputs.input_files)

        }
    'sbg:fileTypes': PEP.XML
    format: PEP.XML
doc: >-
  **iProphet** is a tool that combines the evidence from multiple
  identifications of the same peptide sequence across different spectra,
  experiments, precursor ion charge states, and modified states. It also allows
  accurate and effective integration of the results from multiple database
  search engines applied to the same data. 


  iProphet is an integral part of the Trans-Proteomic Pipeline (TPP) developed
  by the Seattle Proteome Center. The use of iProphet in the TPP increases the
  number of correctly identified peptides at a constant false discovery rate
  (FDR) as compared to both PeptideProphet and a representative state-of-the-art
  tool Percolator. As the main outcome, iProphet permits the calculation of
  accurate posterior probabilities and FDR estimates at the level of unique
  peptide sequences, which in turn leads to more accurate probability estimates
  at the protein level. Fully integrated with the TPP, it supports all commonly
  used MS instruments, search engines, and computer platforms.


  ###Required Inputs


  1. input_files: output file in pepXML format from several peptide search
  engines


  ###Outputs


  1. output_file: file in pepXML format that contains improved peptide
  probability estimates


  ###Common Issues and Important Notes


  There are no known common issues.
label: TPP IProphet
arguments:
  - position: 0
    separate: false
    shellQuote: false
    valueFrom: /local/tpp/bin/InterProphetParser
  - position: 101
    shellQuote: false
    valueFrom: |-
      ${
          input = ''
          if (inputs.input_files instanceof Array)
              input = inputs.input_files[0].path
          else
              input = inputs.input_files.path
          input = input.split('/')[input.split('/').length - 1]
          prefix = ''
          suf = ''
          if (input.indexOf('xtan') != -1) {
              prefix = input.substring(0, input.indexOf('.xtan'))
              suf = input.substring(input.indexOf('.xtan'), input.length)
          } else {
              prefix = input.substring(0, input.indexOf('.pep'))
              suf = input.substring(input.indexOf('.pep'), input.length)
          }
          return prefix + '.ipro' + suf
      }
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 2000
    coresMin: 2
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/vladimir_obucina/tpp:5.0.0'
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.input_files)
  - class: InlineJavascriptRequirement
    expressionLib:
      - |-
        var updateMetadata = function(file, key, value) {
            file['metadata'][key] = value;
            return file;
        };


        var setMetadata = function(file, metadata) {
            if (!('metadata' in file))
                file['metadata'] = metadata;
            else {
                for (var key in metadata) {
                    file['metadata'][key] = metadata[key];
                }
            }
            return file
        };

        var inheritMetadata = function(o1, o2) {
            var commonMetadata = {};
            if (!Array.isArray(o2)) {
                o2 = [o2]
            }
            for (var i = 0; i < o2.length; i++) {
                var example = o2[i]['metadata'];
                for (var key in example) {
                    if (i == 0)
                        commonMetadata[key] = example[key];
                    else {
                        if (!(commonMetadata[key] == example[key])) {
                            delete commonMetadata[key]
                        }
                    }
                }
            }
            if (!Array.isArray(o1)) {
                o1 = setMetadata(o1, commonMetadata)
            } else {
                for (var i = 0; i < o1.length; i++) {
                    o1[i] = setMetadata(o1[i], commonMetadata)
                }
            }
            return o1;
        };

        var toArray = function(file) {
            return [].concat(file);
        };

        var groupBy = function(files, key) {
            var groupedFiles = [];
            var tempDict = {};
            for (var i = 0; i < files.length; i++) {
                var value = files[i]['metadata'][key];
                if (value in tempDict)
                    tempDict[value].push(files[i]);
                else tempDict[value] = [files[i]];
            }
            for (var key in tempDict) {
                groupedFiles.push(tempDict[key]);
            }
            return groupedFiles;
        };

        var orderBy = function(files, key, order) {
            var compareFunction = function(a, b) {
                if (a['metadata'][key].constructor === Number) {
                    return a['metadata'][key] - b['metadata'][key];
                } else {
                    var nameA = a['metadata'][key].toUpperCase();
                    var nameB = b['metadata'][key].toUpperCase();
                    if (nameA < nameB) {
                        return -1;
                    }
                    if (nameA > nameB) {
                        return 1;
                    }
                    return 0;
                }
            };

            files = files.sort(compareFunction);
            if (order == undefined || order == "asc")
                return files;
            else
                return files.reverse();
        };

