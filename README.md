# data-notebooks

Collection of data analysis projects on jupyter notebooks, _pdf_ version too!

# Setup
Load enviroment variables

`source ./src/.env`

#  Description of files
## src
- `inegi.R`
    Provides the function `datos_inegi_total` to download data from INEGI, takes an id and a token as arguments.
- `inegi_modelos_arima_sarima.Rmd`
    An Rmarkdown notebook, presenting _ARIMA/SARIMA_ models for several INEGI indicators.
- `chinook_analysis.ipyng`
    Data analysis on the [Chinook](https://github.com/lerocha/chinook-database?tab=readme-ov-file) database. Exploratory data analysis with PCA, modeling time series using ARIMA/ARIMA models.