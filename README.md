# data-notebooks

Collection of data analysis projects on jupyter notebooks, _pdf_ version too!

# Setup
Load enviroment variables

`source ./src/.env`

#  Description of files
## src
- `inegi.R`
    Provides the function `datos_inegi_total` to download data from INEGI, takes an id and a token as arguments.
- `inegi_modelos_arima_sarima.Rmd`, `build/inegi_modelos_arima_sarima.pdf`
    An Rmarkdown notebook, presenting _ARIMA/SARIMA_ models for several INEGI indicators.
- `chinook_analysis.ipyn`
    Data analysis on the [Chinook](https://github.com/lerocha/chinook-database?tab=readme-ov-file) database. Exploratory data analysis with _PCA_, modeling time series using 
    _ARIMA/ARIMA_ models.
- `build/cetes.pdf`
    Contains the analysis, modeling and solution to the problem of optimizing a CETES portfolio, using linear programming tools (Simplex).

## build
- PDF version of the notebooks on `src`.