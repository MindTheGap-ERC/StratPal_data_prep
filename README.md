# StratPal_ws_data_prep

Data preparation for StratPal workshop and package [(Hohmann et al. 2024, 2025)](#references). Emulates scenario A of [Hohmann et al. (2024)](#references) using CarboKitten.jl [(Hidding et al. 2025)](#references).

## Author

__Niklas Hohmann__  
Utrecht University  
email: n.h.hohmann [at] uu.nl  
Web page: [www.uu.nl/staff/NHohmann](https://www.uu.nl/staff/NHHohmann)  
ORCID: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

## Requirements

Julia >= 1.10, R >= 4.0

## Running

To simulate the carbonate platform, do in Julia package mode (press `]` in the Julia REPL)

```julia
activate .
instantiate
```

This will activate the project and download & precompile all required Julia packages. Then run

```julia
include("code/sim_platform.jl")
```

to run simulate the carbonate platform. This will generate the platform data in `data/`, including outputs of age-depth models, water depth, and stratigraphic columns as .csv file. Then you can genrate the figures using

```julia
include("code/vis_platform.jl")
```

which will generate all figures in `figs/`.

To process the data in R and save it as .rda file (as it is provided in the `StratPal` package), run the file `code/data_proc_jl.R` in R, e.g., via

```
Rscript code/data_proc_jl.R
```

in your console.

## Copyright

Copyright 2023-2025 Netherlands eScience Center and Utrecht University

## License

Apache 2.0 License, see LICENSE file for full license text.

## References

* Hidding, J., Jarochowska, E., Hohmann, N., Liu, X., Burgess, P., and Spreeuw, H.: CarboKitten.jl – an open source toolkit for carbonate stratigraphic modeling, EGUsphere [preprint]. https://doi.org/10.5194/egusphere-2025-4561, 2025.
* Hohmann, N., and Jarochowska, E: StratPal: An R package for creating stratigraphic paleobiology modelling pipelines. Methods in Ecology and Evolution, 16, 678–686. https://doi.org/10.1111/2041-210X.14507, 2025.
* Hohmann, N.: StratPal: R package for stratigraphic paleobiology modeling pipelines (v0.7.0). Zenodo. https://doi.org/10.5281/zenodo.12790994, 2025.
* Hohmann, N., Koelewijn, J.R., Burgess, P., and Jarochowska, E.: Identification of the mode of evolution in incomplete carbonate successions. BMC Ecol Evo 24, 113. https://doi.org/10.1186/s12862-024-02287-2, 2025.



## Funding information

Funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them.
![European Union and European Research Council logos](https://erc.europa.eu/sites/default/files/2023-06/LOGO_ERC-FLAG_FP.png)
