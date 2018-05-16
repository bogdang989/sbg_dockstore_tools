class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: tpp_spectrast_search_5_0_0
baseCommand: []
inputs:
  - 'sbg:category': CANDIDATE SELECTION AND SCORING OPTIONS
    'sbg:toolDefaultValue': 'False'
    id: all_charge_states
    type: boolean?
    inputBinding:
      position: 10
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.all_charge_states != undefined & inputs.all_charge_states == true)
                return '-sz'
            return ''
        }
    label: All charge states
    doc: >-
      Search library spectra of all charge states, i.e., ignore specified charge
      state (if any) of the query spectrum.
  - 'sbg:category': Input configuration
    'sbg:toolDefaultValue': 'False'
    id: cache_all_entries
    type: boolean?
    inputBinding:
      position: 5
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.cache_all_entries != undefined & inputs.cache_all_entries == true)
                return '-sR'
            if (inputs.cache_all_entries == undefined)
                return ''
            return '-sR!'
        }
    label: Cache all entries
    doc: >-
      Cache all entries in RAM. Requires a lot of memory (the library will
      usually be loaded almost in its entirety), but speeds up search for
      unsorted queries.
  - format: FASTA
    'sbg:category': Input Files
    id: database
    type: File?
    inputBinding:
      position: 3
      prefix: '-sD'
      shellQuote: false
    label: Database
    doc: >-
      Database must be in .fasta format. This will not affect the search in any
      way, but this information will be included in the output for any
      downstream data processing.
    'sbg:fileTypes': FASTA
  - 'sbg:category': Input configuration
    id: database_type
    type:
      - 'null'
      - type: enum
        symbols:
          - AA
          - DNA
        name: database_type
    inputBinding:
      position: 4
      prefix: '-sT'
      shellQuote: false
    label: Database type
    doc: >-
      Specify the type of the sequence database file. Type must be either "AA"
      or "DNA".
  - 'sbg:category': CANDIDATE SELECTION AND SCORING OPTIONS
    'sbg:toolDefaultValue': 'False'
    id: isotopically_avg_mass
    type: boolean?
    inputBinding:
      position: 9
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.isotopically_avg_mass != undefined && inputs.isotopically_avg_mass == true)
                return '-sA'
            if (inputs.isotopically_avg_mass == undefined)
                return ''
            return '-sA!'
        }
    label: Isotopically averaged mass
    doc: Use isotopically averaged mass instead of monoisotopic mass.
  - format: SPLIB
    'sbg:category': Input Files
    id: library
    type: File
    inputBinding:
      position: 2
      prefix: '-sL'
      separate: false
      shellQuote: false
      valueFrom: |-
        ${
            return inputs.library.path.split('/')[inputs.library.path.split('/').length - 1]
        }
    label: Library
    doc: >-
      Library must have .splib extension. The existence of the corresponding
      .spidx and .pepidx files of the same name is assumed.
    'sbg:fileTypes': SPLIB
    secondaryFiles:
      - ^.spidx
      - ^.pepidx
  - 'sbg:category': Output configuration
    id: output_format
    type:
      - 'null'
      - type: enum
        symbols:
          - txt
          - xls
          - pep.xml
          - html
        name: output_format
    inputBinding:
      position: 11
      prefix: '-sE'
      shellQuote: false
    label: Output format
    doc: >-
      The search result will be written to a file with the same base name as the
      search file, with extension <output_format>.
  - 'sbg:category': CANDIDATE SELECTION AND SCORING OPTIONS
    id: precursor_m_z_tolerance
    type: string?
    inputBinding:
      position: 8
      prefix: '-sM'
      shellQuote: false
    label: Precursor m/z tolerance
    doc: >-
      Specify precursor m/z tolerance. It is the m/z tolerance within which
      candidate entries are compared to the query.
  - format: 'MZXML, MZDATA, DTA, MSP'
    'sbg:category': Input Files
    id: spectra_files
    type: 'File[]'
    inputBinding:
      position: 101
      shellQuote: false
      valueFrom: |-
        ${
            res = ''
            if (inputs.spectra_files != undefined && inputs.spectra_files instanceof Array) {
                for (var i = 0; i < inputs.spectra_files.length; i++) {
                    name = inputs.spectra_files[i].path.split('/')
                    name = name[name.length - 1]
                    res = res + ' ' + name
                }
            }
            return res
        }
    label: Spectra files
    doc: Files containing unknown spectra to be searched.
    'sbg:fileTypes': 'MZXML, MZDATA, DTA, MSP'
  - 'sbg:category': Input Files
    id: subset_spectra
    type: File?
    inputBinding:
      position: 7
      prefix: '-sS'
      shellQuote: false
    label: Subset spectra
    doc: >-
      Only search a subset of the query spectra in the search file. Only query
      spectra with names matching a line of <file> will be searched.
  - 'sbg:category': Input configuration
    'sbg:toolDefaultValue': does not use multi-threding
    id: threads
    type: int?
    inputBinding:
      position: 6
      shellQuote: false
      valueFrom: |-
        ${
            if (inputs.threads != undefined & inputs.threads > 0)
                return '-sP ' + inputs.threads
            if (inputs.threads == undefined)
                return ''
            return '-sP!'
        }
    label: Number of threads
    doc: >-
      Cache all entries in RAM. Requires a lot of memory (the library will
      usually be loaded almost in its entirety), but speeds up search for
      unsorted queries.
outputs:
  - id: output_file
    doc: Output file.
    label: Output file
    type: 'File[]?'
    outputBinding:
      glob: |-
        ${
            if (inputs.output_format == 'txt')
                return '*.spec.txt'
            else if (inputs.output_format == 'xls')
                return '*.spec.xls'
            else if (inputs.output_format == 'pep.xml')
                return '*.spec.pep.xml'
            else if (inputs.output_format == 'html')
                return '*.spec.html'
            return '*.spec.pep.xml'
        }
    'sbg:fileTypes': 'TXT, XLS, PEP.XML, HTML'
    format: 'TXT, XLS, PEP.XML, HTML'
doc: >-
  **SpectraST** (also known as "Spectra Search Tool", which rhymes with
  "contrast") is a spectral library building and searching tool designed
  primarily for shotgun proteomics applications. It is an integral part of the
  Trans-Proteomic Pipeline developed by the Seattle Proteome Center.


  Traditionally, the inference of peptide sequence from its characteristic
  tandem mass spectra is done by sequence (database) searching. In sequence
  searching, a target protein (or translated DNA) database is used as a
  reference to generate all possible putative peptide sequences by in silico
  digestion.

  Spectral searching is an alternative approach that promises to address some of
  the shortcomings of sequence searching. In spectral searching, a spectral
  library is meticulously compiled from a large collection of previously
  observed and identified peptide MS/MS spectra. An unknown spectrum then can by
  identified by comparing it to all the candidates in the spectral library for
  the best match. This approach has been employed for mass spectrometric
  analysis of small molecules with great success but has only become possible
  for proteomics very recently. The main difficulty of generating enough
  high-quality experimental spectra for compilation into spectral libraries has
  been overcome by the recent explosion of proteomics data and the availability
  of public data repositories. Several attempts at creating and searching
  spectral libraries in the context of proteomics demonstrate the tremendous
  improvement in search speed and the great potential of this method in
  complementing, if not replacing, sequence searching in many proteomics
  applications.


  SpectraST Search can perform spectral searching using data in the following
  formats: mzML, mzXML (all versions), mzData , MGF (Mascot Generic), DTA
  (SEQUEST), and MSP (a simple peak list preceded by precursor information
  developed by the National Institute of Standards and Technology). 

  The spectral library must be in SpectraST’s SPLIB format, which can be created
  in SpectraST Create Mode. 

  The results can be output to the following file formats: pepXML, TXT, XLS, and
  HTML.


  ###Required Inputs

  1. spectra\_files: file in mzML, mzData, DTA, or MSP format that contains
  input mass spectrometry data

  2. library: spectral library file in SPLIB format and secondary SPIDX and
  PEPIDX files


  ###Outputs

  1. output_file: file in pepXML, TXT, XLS, or HTML format that contains the
  resulting peptide-spectrum matches



  ###Common Issues and Important Notes


  There are no known common issues.
label: TPP SpectraST Search
arguments:
  - position: 0
    separate: false
    shellQuote: false
    valueFrom: /local/tpp/bin/spectrast
  - position: 1001
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          res = ''
          for (var i = 0; i < inputs.spectra_files.length; i++) {
              res = res + ' ; '

              prefix = inputs.spectra_files[i].path.split('/')
              prefix = prefix[prefix.length - 1]
              part = prefix.split('.')[prefix.split('.').length - 1]
              prefix = prefix.substring(0, prefix.indexOf(part) - 1)

              res = res + 'mv '

              if (inputs.output_format == undefined)
                  suf = '.pep.xml'
              else
                  suf = '.' + inputs.output_format

              res = res + prefix + suf + ' ' + prefix + '.spec' + suf

          }
          return res
      }
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 1000
    coresMin: 1
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/vladimir_obucina/tpp:5.0.0'
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.spectra_files)
      - $(inputs.library)
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
