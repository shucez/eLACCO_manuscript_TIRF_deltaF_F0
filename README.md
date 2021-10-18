# TIRF_2CH_nonratio.R

`TIRF_2CH_nonratio.R` is an R script for calculating $\Delta$ F/F0 for each of the two channels exported from Nikon NIS-Elements Advanced Research software.

## Prerequisites

This script is dependent on `ggplot2` and `plyr` packages.

```R
install.packages("ggplot2", "plyr")
```

## Usage
1. Open the `xlsx` file exported from Nikon NIS-Elements in Microsoft Excel. This file should contain both FITC and TRITC channel. You may use `sample.xlsx` as the demo data.
2. Open `raw.txt` using Microsoft Excel. 
3. Delete all content in `raw.txt`.
4. Copy everything from `xlsx` file to `raw.txt`. Delete the first row.
5. Save `raw.txt`. In case warning may show up, click "yes".
6. Open `TIRF_2CH_nonratio.R` in Rstudio. 
7. Change the directory in row 11 to the appropriate directory where your `raw.txt` is located.
```R
setwd("~/Research/eLACCO1.0")
```
8. Click 'Source'. Once the program completes successfully, 2 graphs should be plotted for FITC and TRITC channels, respectively, showing individual traces of $\Delta$ F/F0 for each ROI. 2 files names `00signal1.txt` and `00signal2.txt` are generated for the 2 channels, respectively, documenting the $\Delta$ F/F0 values for each ROI over time.
9. `00signal1.txt` and `00signal2.txt` are comma-delimited text files that can be directly imported into GraphPad Prism for better visualization.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)