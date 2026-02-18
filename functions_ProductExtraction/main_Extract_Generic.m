% sur le pont d'avignon -ufu-

clear
clc

addpath evapotranspiration
addpath precipitation
addpath lwe

%% DIRECTORIES
% ROOT DIRS
dat.indir.lwe = '\\147.100.1.28\remote_sensing\GRACE\'; % GRACE data
dat.indir.ppt = '\\147.100.1.28\Donnees_Climatiques2\precipitations_products'; % all precipitation data except MSWEP
dat.indir.et = '\\147.100.1.28\Donnees_Climatiques2\evapotranspiration_products'; % all evapotranspiration data
dat.outdir = '\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\EXTRACTS'; % directory to save the extractions

% SUB DIRS
% lwe
dat.pdct_dir.lwe.GRACE = {'CSR_TELLUS_L3','GFZ_TELLUS_L3','JPL_TELLUS_L3'};

% et
dat.pdct_dir.le.CAMELE = 'CAMELE';
dat.pdct_dir.le.DOLCE = {'DOLCE\DOLCE_v2.1\',...
    'DOLCE\DOLCE_v3.0\'};
dat.pdct_dir.le.ERA5 = 'ERA5\ET';
dat.pdct_dir.le.ERA5Land = 'ERA5_Land\ET';
dat.pdct_dir.le.FLUXCOM = {'FLUXCOM\EnergyFluxes\RS\ensemble\720_360\8daily';...
    'FLUXCOM\EnergyFluxes\RS\ensemble\720_360\monthly';...
    'FLUXCOM\EnergyFluxes\RS\ensemble\4320_2160\8daily';...
    'FLUXCOM\EnergyFluxes\RS\ensemble\4320_2160\monthly';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\ALL\daily';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\ALL\monthly';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\daily';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\monthly';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\daily';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\monthly';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\GSWP3\daily';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\GSWP3\monthly';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\WFDEI\daily';...
    'FLUXCOM\EnergyFluxes\RS_METEO\ensemble\WFDEI\monthly'};
dat.pdct_dir.le.GLDAS_CLSM = 'GLDAS_CLSM025';
dat.pdct_dir.le.GLDAS_NOAH = 'GLDAS_NOAH025';
dat.pdct_dir.le.GLEAM = 'GLEAM';
dat.pdct_dir.le.HGLand = 'HG-Land v1.0';
dat.pdct_dir.le.MERRA = 'MERRAv2';
dat.pdct_dir.le.MSG.dir = {'MSG\MDMETv3\NETCDF\';'MSG\METREF\NETCDF\'};dat.pdct_dir.le.MSG.var = {'ET';'METREF'};%actual and reference ET - MSG
dat.pdct_dir.le.SSEBop = 'SSEBop\SSEBop_v5\global_decadal\ALL.SSEBop';
dat.pdct_dir.le.ETMonitor = 'ETMonitor';

% ppt
dat.pdct_dir.ppt.CHIRP = 'CHIRP';
dat.pdct_dir.ppt.CHIRPS = 'CHIRPS_v2.0';
dat.pdct_dir.ppt.CMAP = 'CMAP';
dat.pdct_dir.ppt.ERA5 = 'ERA5\PPT';
dat.pdct_dir.ppt.ERA5Land = 'ERA5_Land\PPT';
dat.pdct_dir.ppt.GPCC = 'GPCC';
dat.pdct_dir.ppt.MSWEP = '\\147.100.1.28\Donnees_Climatiques2\reanalyses\MSWEP\Past\Daily';

%% EXTRACT LWE/ET/P Products [auto w/ popups]
Extract_Generic(dat)
