# StratPal_ws_data_prep

Data preparation for StratPal workshop and package. Extracts selected data from scenario A of Hohmann et al (2024) [DOI: 10.1186/s12862-024-02287-2](https://doi.org/10.1186/s12862-024-02287-2)

## Author

__Niklas Hohmann__  
Utrecht University  
email: n.h.hohmann [at] uu.nl  
Web page: [www.uu.nl/staff/NHohmann](https://www.uu.nl/staff/NHHohmann)  
ORCID: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

## Usage

First, download `scenarioA_glob_matlab_outputs.mat` from https://osf.io/zbpwa/, and place it in the `data` folder. Then run `code/extract_data.m` in Matlab, which will generate the intermediate file `data/scenarionA_processed.mat`. Next, open the file `StratPal_ws_data_prep.Rproj` in the Rstudio IDE. Then, run

```R
source("code/data_proc_r.R")
```

in the console, which generates the final output file under `data/scenarioA.Rdata`.

## Copyright

Copyright 2023-2024 Netherlands eScience Center and Utrecht University

## License

Apache 2.0 License, see LICENSE file for full license text.

## Funding information

Funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them.
![European Union and European Research Council logos](https://erc.europa.eu/sites/default/files/2023-06/LOGO_ERC-FLAG_FP.png)
