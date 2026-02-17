% sur le pont d'avignon

%%%% ############################################################################## %%%%
%%%% ############################################################################## %%%%
%%%%                                                                                %%%%
%%%%                                                                                %%%%
%%%%         1) EXTRACT ET PRODUCTS                                                 %%%%
%%%%         2) Compile Ground Reference data - fluxnet, icos, ...                  %%%%
%%%%         3) Compile EVASPA inputs & estimates                                   %%%%
%%%%         4) Plotting                                                            %%%%
%%%%                                                                                %%%%
%%%%                                                                                %%%%
%%%%                                                                                %%%%
%%%% ############################################################################## %%%%
%%%% ############################################################################## %%%%



%% ################################################################################## %%
%%                                                                                    %% 
%% EXTRACT TIMESERIES ET DATA [POINT OR AOI/SUBSET] FROM GLOBAL ET PRODUCTS           %%
%%   - FOCUS ON SOUTHERN FRANCE                                                       %%
%%                                                                                    %%
%% ################################################################################## %%


clc
clear

ly=@(yr)~rem(yr,400)|(rem(yr,100)&~rem(yr,4));

if ~exist('isfolder'), isfolder=@isdir;end %#ok
chdir('F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts')
indir='F:\RS_data\ET\';

camele_dir = 'CAMELE';
fluxcom_dir = 'FLUXCOM';
% fluxnet_dir = 'FLUXNET';
glm_dir = 'GLEAM';
mcd_dir = 'MCD16';
msg_dir = 'MSG';
hg_dir = 'HG-Land v1.0';
dolce_dir = 'DOLCE';
merra_dir='MERRAv2';
gldasclsm_dir='GLDAS_CLSM025';
gldasnoah_dir='GLDAS_NOAH025';
era5_le_dir='ERA5\LE';
era5_le_land_dir='ERA5_Land\LE';
era5_et_dir='ERA5\ET';
era5_et_land_dir='ERA5_Land\ET';

extract_what = 'area'; % 'point' or 'area'

%%

switch extract_what
    case 'area'
        %% AREA EXTRACTION
        
        % % France subsets
        % % 51°07'48"N 	### 51°07'48"N 2°29'34"E top
        % % 42°20'41"N 	### 42°20'41"N 2°35'50"E bottom
        % % 5°09'38"W 	### 48°26'41"N 5°09'38"W left
        % % 8°14'30"E 	### 49°00'11"N 8°14'30"E right
        ROIsites.FRANCE.tOP = 52; 	    % ### 51°07'48"N 2°29'34"E top
        ROIsites.FRANCE.bTtm = 42; 	    % ### 42°20'41"N 2°35'50"E bottom
        ROIsites.FRANCE.leFT = -6;      %	### 48°26'41"N 5°09'38"W left
        ROIsites.FRANCE.RigHT = 9; 	   % ### 49°00'11"N 8°14'30"E right
        ROIsites.FRANCE.subset_nm = 'FRANCE';
        
        % % Fr - South East France -- see Choose_tuile_and_shape_fast()
        ROIsites.SouthEast_FR.tOP = 44.5;
        ROIsites.SouthEast_FR.bTtm = 42.3;
        ROIsites.SouthEast_FR.leFT = 2.4;
        ROIsites.SouthEast_FR.RigHT = 6.4;
        ROIsites.SouthEast_FR.subset_nm = 'SouthEast_FR';

        % % Fr - South West France -- see Choose_tuile_and_shape_fast()
        ROIsites.SouthWest_FR.tOP = 45.25;
        ROIsites.SouthWest_FR.bTtm = 42.5;
        ROIsites.SouthWest_FR.leFT = -1.75;
        ROIsites.SouthWest_FR.RigHT = 2.5;
        ROIsites.SouthWest_FR.subset_nm = 'SouthWest_FR';
        
        % % Fr - Grignon / Fontainebleau -- see Choose_tuile_and_shape_fast()
        ROIsites.FRFon_FRGri.tOP = 49.5083;
        ROIsites.FRFon_FRGri.bTtm = 47.5083;
        ROIsites.FRFon_FRGri.leFT = 0.9888;
        ROIsites.FRFon_FRGri.RigHT = 4.1589;
        ROIsites.FRFon_FRGri.subset_nm = 'FRFon_FRGri';

        % % Kenya subsets
        ROIsites.Kenya.tOP = 5.5;
        ROIsites.Kenya.bTtm = -5.5;
        ROIsites.Kenya.leFT = 33;
        ROIsites.Kenya.RigHT = 42;
        ROIsites.Kenya.subset_nm = 'KENYA';
        
        % % Southern Africa subsets
        ROIsites.SouthernAfrica.tOP = -20;
        ROIsites.SouthernAfrica.bTtm = -30;
        ROIsites.SouthernAfrica.leFT = 15;
        ROIsites.SouthernAfrica.RigHT = 25;
        ROIsites.SouthernAfrica.subset_nm = 'SouthernAfrica';
        

    case 'point'
        
        %% POINT EXTRACTION

        %% % French sites % LATLON

        %%% Avignon
        % "Remote sensing and flux site" of INRAe
        ROIsites.INRAe_RSflux.lat_pt = 43.9168; % N
        ROIsites.INRAe_RSflux.lon_pt = 4.8781; % E
        ROIsites.INRAe_RSflux.site_nm = 'INRAe_RSflux';

        % Crau-Camargue (Avignon) site
        ROIsites.Crau_Camargue.lat_pt = 43.4888; % N
        ROIsites.Crau_Camargue.lon_pt = 4.6653; % E
        ROIsites.Crau_Camargue.site_nm = 'Crau_Camargue';

        %%% FluxNet2015
        % FR-Fon: Fontainebleau-Barbeau - https://fluxnet.org/sites/siteinfo/FR-Fon
        ROIsites.FR_Fon.lat_pt = 48.4764; % N
        ROIsites.FR_Fon.lon_pt = 2.7801; % E
        ROIsites.FR_Fon.site_nm = 'FR_Fon';

        % FR-Gri: Grignon - https://fluxnet.org/sites/siteinfo/FR-Gri
        ROIsites.FR_Gri.lat_pt = 48.8442; % N
        ROIsites.FR_Gri.lon_pt = 1.9519; % E
        ROIsites.FR_Gri.site_nm = 'FR_Gri';

        % FR-LBr: Le Bray - https://fluxnet.org/sites/siteinfo/FR-LBr
        ROIsites.FR_LBr.lat_pt = 44.7171; % N
        ROIsites.FR_LBr.lon_pt = -0.7693; % W
        ROIsites.FR_LBr.site_nm = 'FR_LBr';

        % FR-Pue: Puechabon - https://fluxnet.org/sites/siteinfo/FR-Pue
        ROIsites.FR_Pue.lat_pt = 43.7413; % N
        ROIsites.FR_Pue.lon_pt = 3.5957; % E
        ROIsites.FR_Pue.site_nm = 'FR_Pue';
end

fields = fieldnames(ROIsites);


%% GLEAM
% v3.7b && v3.8a %% [NOT future-proof] indices below only specific to these versions - as of 071123
% lon_left = 699; lon_right = 754;
% lat_top = 155; lat_btm = 192;                     
% total ET - denoted 'E' - nc_files index 3

glm_dirs = dir([indir glm_dir]);
for i=8:length(glm_dirs)
    if isfolder([glm_dirs(i).folder '\' glm_dirs(i).name])
        dly_dirs = dir([glm_dirs(i).folder '\' glm_dirs(i).name '\daily']);
        for ii=3:length(dly_dirs)
            nc_files = dir([glm_dirs(i).folder '\' glm_dirs(i).name '\daily\' dly_dirs(ii).name]);            
            lat = ncread([nc_files(3).folder '\' nc_files(3).name],'lat');% total ET - denoted 'E' - index 3
            lon = ncread([nc_files(3).folder '\' nc_files(3).name],'lon');
            for i_flds=1:length(fields)
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'E' - index 3
                        et = ncread([nc_files(3).folder '\' nc_files(3).name],'E'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                        
                        ET.ET = permute(et,[2 1 3]); %% ' to re-orient array
                        ET.coord.lat = lat(lat_ind);
                        ET.coord.lon = lon(lon_ind);
                        ET.time = ncread([nc_files(3).folder '\' nc_files(3).name],'time');

                        % save subset struct
                        out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\GLEAM\' glm_dirs(i).name '\daily\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save(strrep([out_dir '\' nc_files(3).name],'.nc','.mat'),'-struct','ET')
                        clear ET
                    case 'point'
                        pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                        pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                        % Point total ET - denoted 'E' - index 3
                        ET_pt.ET = squeeze(ncread([nc_files(3).folder '\' nc_files(3).name],'E'...
                            ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                            ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                        
                        ET_pt.coord.lat = lat(pt_lat_ind);
                        ET_pt.coord.lon = lon(pt_lon_ind);
                        ET_pt.time = ncread([nc_files(3).folder '\' nc_files(3).name],'time');

                        % save point struct
                        out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\GLEAM\' glm_dirs(i).name '\daily\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save(strrep([out_dir '\' nc_files(3).name],'.nc','.mat'),'-struct','ET_pt')
                        clear ET_pt
                end        
            end
        end
    end
end

%% FLUXCOM %% NOTE : FLUXCOM data is in MJ/m2/d >> /2.45 to convert to mm/d
% RS && RS_METEO - %% [NOT future-proof] indices below only specific to these versions - as of 071123
%%% 0.08333 [~0.1] vs 0.25 res.

%%% only ensemble here [the members are in separate folders : not considered here]
fluxcom_dir_RSnRS_METEO = {[indir fluxcom_dir '\EnergyFluxes\RS\ensemble\720_360\8daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS\ensemble\720_360\monthly'];...
    [indir fluxcom_dir '\EnergyFluxes\RS\ensemble\4320_2160\8daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS\ensemble\4320_2160\monthly'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\ALL\daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\ALL\monthly'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\monthly'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\monthly'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\GSWP3\daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\GSWP3\monthly'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\WFDEI\daily'];...
    [indir fluxcom_dir '\EnergyFluxes\RS_METEO\ensemble\WFDEI\monthly']};

for ifxcm=1:length(fluxcom_dir_RSnRS_METEO) % RS & RS_METEO    
    nc_files = dir(char(fluxcom_dir_RSnRS_METEO(ifxcm)));
    for i=3:length(nc_files)

        if ~contains(nc_files(i).name,'LE.RS'), continue; end
        lat = ncread([nc_files(i).folder '\' nc_files(i).name],'lat');
        lon = ncread([nc_files(i).folder '\' nc_files(i).name],'lon');

        % total ET - denoted 'LE'
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
            %         if length(lat)==2160, coord = coord01; else, coord = coord025; end
                    et = ncread([nc_files(i).folder '\' nc_files(i).name],'LE'...
                        ,[lon_ind(1) lat_ind(1) 1]...
                        ,[length(lon_ind) length(lat_ind) inf])/2.45;% FLUXCOM data is in MJ/m2/d >> converting to mm/d 
                    et(et<-999)=nan;
                    ET.ET = permute(et,[2 1 3]); %% to re-orient array
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([nc_files(i).folder '\' nc_files(i).name],'time');
            
                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' strrep(nc_files(i).folder,indir,'')];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir '\' nc_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'LE'
                    ET_pt.ET = squeeze(ncread([nc_files(i).folder '\' nc_files(i).name],'LE'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]))/2.45; % FLUXCOM data is in MJ/m2/d >> converting to mm/d
                    
                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([nc_files(i).folder '\' nc_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\' strrep(nc_files(i).folder,indir,'')];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir '\' nc_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end
        end
    end
end

%% CAMELE
% 0.1 & 0.25 res

camele_ncfls = dir([indir camele_dir]);
for i=3:length(camele_ncfls)
    if ~contains(camele_ncfls(i).name,'.nc'), continue; end
    if contains(camele_ncfls(i).name,'.01.'),res_dir='\01\';else,res_dir='\025\';end
    % total ET - denoted 'ET'
    lat = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'lat');
    lon = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'lon');

    for i_flds=1:length(fields)
        switch extract_what
            case 'area'
                tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                lat_ind = find(lat<=tOP & lat>=bTtm);
                lon_ind = find(lon<=RigHT & lon>=leFT);
            %     if length(lat)==1500, coord = coord01; else, coord = coord025; end
                ET.ET = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'ET'...
                    ,[lat_ind(1) lon_ind(1) 1]...
                    ,[length(lat_ind) length(lon_ind) inf]);    
                ET.coord.lat = lat(lat_ind);
                ET.coord.lon = lon(lon_ind);
                ET.time = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'day');
                
                % save subset struct
                out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' camele_dir res_dir];
                if ~isfolder(out_dir), mkdir(out_dir),end
                save(strrep([out_dir camele_ncfls(i).name],'.nc','.mat'),'-struct','ET')
                clear ET
            case 'point'
                pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                ET_pt.ET = squeeze(ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'ET'...
                    ,[pt_lat_ind(1) pt_lon_ind(1) 1]...
                    ,[length(pt_lat_ind) length(pt_lon_ind) inf]));    
                ET_pt.coord.lat = lat(pt_lat_ind);
                ET_pt.coord.lon = lon(pt_lon_ind);
                ET_pt.time = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'day');
                % save subset struct
                out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\' camele_dir res_dir];
                if ~isfolder(out_dir), mkdir(out_dir),end
                save(strrep([out_dir camele_ncfls(i).name],'.nc','.mat'),'-struct','ET_pt')
                clear ET_pt
        end
    end
end

%% MSG - ETa, ETref
MSG_dir = {'MDMETv3\NETCDF\';'METREF\NETCDF\'};
MSG_var = {'ET';'METREF'};%actual and reference ET - MSG
for i_msgET=1:length(MSG_dir)
    msg_dirs = dir([indir msg_dir  '\'  char(MSG_dir(i_msgET))]); % msg_dir defined further up as 'MSG'
    for i_msgYR=3:length(msg_dirs)
        if ~isfolder([msg_dirs(i_msgYR).folder '\' msg_dirs(i_msgYR).name]), continue; end
        msg_ncfls = dir([msg_dirs(i_msgYR).folder '\' msg_dirs(i_msgYR).name]);
        
        for i_flds=1:length(fields)
            % MSG .nc files are provided for each day - creating array for whole year
            ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
            ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
            for i_msgfls=3:length(msg_ncfls)
                lat = ncread([msg_ncfls(i_msgfls).folder '\' msg_ncfls(i_msgfls).name],'lat');
                lon = ncread([msg_ncfls(i_msgfls).folder '\' msg_ncfls(i_msgfls).name],'lon');
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        
                        msg_ET = squeeze(ncread([msg_ncfls(i_msgfls).folder '\' msg_ncfls(i_msgfls).name],char(MSG_var(i_msgET))...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]))'; %% re-orient/rotate array

                        ET.ET = cat(3,ET.ET,msg_ET);
                        
                        ET.coord.lat = lat(lat_ind); % same throughout
                        ET.coord.lon = lon(lon_ind); % same throughout
%                         ET.coord.lat = [ET.coord.lat;lat(lat_ind)'];
%                         ET.coord.lon = [ET.coord.lon;lon(lon_ind)'];
                        ET.time = [ET.time;day(datetime(str2num(msg_ncfls(i_msgfls).name(end-14:end-11))...
                            ,str2num(msg_ncfls(i_msgfls).name(end-10:end-9))...
                            ,str2num(msg_ncfls(i_msgfls).name(end-8:end-7)))...
                            ,'dayofyear')];
                       
                    case 'point'
                        pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                        pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                        msg_ET = squeeze(ncread([msg_ncfls(i_msgfls).folder '\' msg_ncfls(i_msgfls).name],char(MSG_var(i_msgET))...
                            ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                            ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                        ET_pt.ET = [ET_pt.ET;msg_ET];
                        ET_pt.coord.lat = [ET_pt.coord.lat;lat(pt_lat_ind)];
                        ET_pt.coord.lon = [ET_pt.coord.lon;lon(pt_lon_ind)];
%                         ET_pt.time = [ET_pt.time;msg_ncfls(i_msgfls).name(end-14:end-3)];
                        ET_pt.time = [ET_pt.time;day(datetime(str2num(msg_ncfls(i_msgfls).name(end-14:end-11))...
                            ,str2num(msg_ncfls(i_msgfls).name(end-10:end-9))...
                            ,str2num(msg_ncfls(i_msgfls).name(end-8:end-7)))...
                            ,'dayofyear')];
                end
            end
            % save subset struct
            switch extract_what
                    case 'area'
                        out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' msg_dir '_' strrep(char(MSG_dir(i_msgET)),'\NETCDF\','')];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir '\' msg_ncfls(i_msgfls).name(1:end-11)],'-struct','ET')
                    case 'point'                        
                        out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\' msg_dir '_' strrep(char(MSG_dir(i_msgET)),'\NETCDF\','')];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir '\' msg_ncfls(i_msgfls).name(1:end-11)],'-struct','ET_pt')
            end
            clear ET_pt ET
        end
    end    
end

%% MOD16 | MYD16
cd('F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts')
% load('F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\EVASPA_081123\constants\coordinates_sat.mat')
load('\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\EVASPA_081123\constants\coordinates_sat.mat')
i_flds=1;
% indir_mxd16=['F:\RS_data\ET\' 'MCD16\YR\'];
indir_mxd16=[indir 'MCD16\YR\'];
% modtile={'h17v04';'h18v04';'h21v08';'h21v09';'h22v08';'h22v09'};
modtile={'h17v04';'h18v04'};
modtile={'h21v08';'h21v09';'h22v08';'h22v09'};%kenya
mxd16={'MOD16A3GF';'MYD16A3GF'};

ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
for i_tl=1:length(modtile)
    for i_mcd=1:length(mxd16)
        mxd_fls=dir([indir_mxd16 char(mxd16(i_mcd)) '\' char(modtile(i_tl))]);
        for i_fls=3:length(mxd_fls)
            mxd_ET=double(hdfread([mxd_fls(i_fls).folder '\' mxd_fls(i_fls).name],'ET_500m'));
            mxd_ET(mxd_ET>60000)=nan;
            mxd_ET=mxd_ET*.1;
            mxd_ET=imresize(mxd_ET,[1200 1200],'nearest');ETall.ET=mxd_ET;
            %% save whole tile
            out_dir = ['MODMYD16' '\' char(mxd16(i_mcd)) '\' char(modtile(i_tl))];
            if ~isdir(out_dir),mkdir(out_dir);end
            save([out_dir '\' strrep(mxd_fls(i_fls).name,'.hdf','.mat')],'-struct','ETall')
            
            for i_flds=1:length(fields)            
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        try
                            if modtile{i_tl}=="h18v04"
                                lat=TileCoord.Lat(:,1);lat_ind = find(lat<=tOP & lat>=bTtm);
                                lon=TileCoord.Lon(lat_ind(1),:);lon_ind = find(lon<=RigHT & lon>=leFT);
                            else%if modtile{i_tl}=="h17v04"
                                lat=eval(['TileCoord.Lat_' modtile{i_tl} '(:,1)']);lat_ind = find(lat<=tOP & lat>=bTtm);
                                lon=eval(['TileCoord.Lon_' modtile{i_tl} '(lat_ind(1),:)']);lon_ind = find(lon<=RigHT & lon>=leFT);
                            end
                        catch
                            continue
                        end
                        
                        ET.ET = [ETall.ET(lat_ind,lon_ind)];
                        ET.coord.lat = [lat(lat_ind)];
                        ET.coord.lon = [lon(lon_ind)];
                        ET.time = [str2num(mxd_fls(i_fls).name(12:18))];
                        % save subset struct
                        out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' mcd_dir];
                        if ~isdir(out_dir), mkdir(out_dir),end
                        save([out_dir '\' mxd_fls(i_fls).name(1:9) '_' modtile{i_tl} '_' mxd_fls(i_fls).name(11:15) '.mat'],'-struct','ET')
                    case 'point'
                        lat=TileCoord.Lat(:,1);pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                        lon=TileCoord.Lon(pt_lat_ind,:);pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                        ET_pt.ET = [ETall.ET(pt_lat_ind,pt_lon_ind)];
                        ET_pt.coord.lat = [lat(pt_lat_ind)];
                        ET_pt.coord.lon = [lon(pt_lon_ind)];
                        ET_pt.time = [str2num(mxd_fls(i_fls).name(12:18))];
                        % save subset struct
                        out_dir = ['ET_' FRsites.(char(fields(i_flds))).site_nm '\' extract_what '\' mcd_dir];
                        if ~isdir(out_dir), mkdir(out_dir),end
                        save([out_dir '\' moyd_fls(i_fls).name(1:15) '.mat'],'-struct','ET_pt')
                end

            end
            
        end
    end
end

%% DOLCE : MONTHLY ET [W.m-2]

dolce_ver = {'\DOLCE_v2.1\'... %%% merging 11 ET products - see readme in \\147.100.1.28\Donnees_Climatiques2\evapotranspiration_products\DOLCE
    ,'\DOLCE_v3.0\'}; %%% merging 4 ET products

for i_dlc=1:length(dolce_ver)
    DOLCE_files = dir([indir dolce_dir dolce_ver{i_dlc}]);
    for i=3:length(DOLCE_files)
        if contains([DOLCE_files(i).folder '\' DOLCE_files(i).name],'.nc')
            lat = ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'lat');
            lon = ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'lon');
            for i_flds=1:length(fields)
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'hfls' - monthly average latent heat energy from 1980-2018
                        le = ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'hfls'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);

                        % uncertainty - denoted 'hfls_sd' - standard deviation of monthly le from 1980-2018
                        le_sd = ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'hfls_sd'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);

                        ET.ET = flipud(permute(le,[2 1 3])); %% rotate/re-orient LE array 
                        ET.ET_sd = flipud(permute(le_sd,[2 1 3])); %% rotate/re-orient SD array

                        ET.coord.lat = flipud(lat(lat_ind)); % flip to start from north southwards
                        ET.coord.lon = lon(lon_ind);
                        ET.time = ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'time');

                        % save subset struct
                        out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' dolce_dir dolce_ver{i_dlc}];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save(strrep([out_dir DOLCE_files(i).name],'.nc','.mat'),'-struct','ET')
                        clear ET
                    case 'point'
                        pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                        pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                        % Point total le - denoted 'hfls' - monthly average latent heat energy from 1980-2018
                        ET_pt.ET = squeeze(ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'hfls'...
                            ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                            ,[length(pt_lon_ind) length(pt_lat_ind) inf]));

                        % uncertainty - denoted 'hfls_sd' - standard deviation of monthly le from 1980-2018
                        ET_pt.ET_sd = squeeze(ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'hfls_sd'...
                            ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                            ,[length(pt_lon_ind) length(pt_lat_ind) inf]));

                        ET_pt.coord.lat = lat(pt_lat_ind);
                        ET_pt.coord.lon = lon(pt_lon_ind);
                        ET_pt.time = ncread([DOLCE_files(i).folder '\' DOLCE_files(i).name],'time');

                        % save point struct
                        out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\' dolce_dir dolce_ver{i_dlc}];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save(strrep([out_dir DOLCE_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                        clear ET_pt
                end        
            end
        end
    end
end


%% ERA5 : DAILY ET - Total Evap [m]

ERA5_files = dir([indir era5_et_dir]);
for i=3:length(ERA5_files)
    if contains([ERA5_files(i).folder '\' ERA5_files(i).name],'.nc')
        lat = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'latitude');
        lon = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'longitude');
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                    % total ET - denoted 'slhf' - daily LE
                    try
                        e = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'e'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                    catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                        e = squeeze(ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'e'...
                            ,[lon_ind(1) lat_ind(1) 1 1]...
                            ,[length(lon_ind) length(lat_ind) 1 inf]));
                    end
                    e(e<=-32767) = nan;%le(le<=-999)=nan;
                    e = permute(e,[2 1 3]); %% rotate/re-orient LE array
                    e = squeeze(nansum(reshape(e,size(e,1),size(e,2),24,[]),3));
                    ET.ET = -e*1000;clear e %*1000 m to mm % -e : "Therefore, negative values indicate evaporation and positive values indicate condensation." - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=overview
                    
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ERA5\ET\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                    e = squeeze(ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'e'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]))/3600; %% /3600 to convert from J.m-2 >> W.m-2
                    e(e<=-32767)=nan;
                    e = nanmean(reshape(e,24,[]));
                    ET_pt.ET = -e*1000;clear e %*1000 m to mm % -e : "Therefore, negative values indicate evaporation and positive values indicate condensation." - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=overview

                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'time');

                    % save point struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ERA5\ET\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end        
        end
    end
end


%% ERA5 : DAILY latent heat flux [J.m-2]

ERA5_files = dir([indir era5_le_dir]);
for i=3:length(ERA5_files)
    if contains([ERA5_files(i).folder '\' ERA5_files(i).name],'.nc')
        lat = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'latitude');
        lon = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'longitude');
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                    % total ET - denoted 'slhf' - daily LE
                    try
                        le = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'slhf'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                    catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                        le = squeeze(ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'slhf'...
                            ,[lon_ind(1) lat_ind(1) 1 1]...
                            ,[length(lon_ind) length(lat_ind) 1 inf]));
                    end
                    le(le<=-32767)=nan;%le(le<=-999)=nan;
                    le=le/3600; %% /3600 to convert from J.m-2 >> W.m-2
                    le = permute(le,[2 1 3]); %% rotate/re-orient LE array
                    le = squeeze(nanmean(reshape(le,size(le,1),size(le,2),24,[]),3));
                    ET.LE = le;clear le
                    
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ERA5\LR\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                    le = squeeze(ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'slhf'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                    le(le<=-32767)=nan;
                    le=le/3600; %% /3600 to convert from J.m-2 >> W.m-2
                    le = nanmean(reshape(le,24,[]));
                    ET_pt.LE = le;

                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'time');

                    % save point struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ERA5\LE\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end        
        end
    end
end


%% ERA5-Land : DAILY ET - Total Evap [m]

ERA5_Land_files = dir([indir era5_et_land_dir]);
for i=3:length(ERA5_Land_files)
    if contains([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'.nc')
        lat = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'latitude');
        lon = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'longitude');
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                    % total ET - denoted 'slhf' - daily LE
                    try
                        e = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'e'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                    catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                        e = squeeze(ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'e'...
                            ,[lon_ind(1) lat_ind(1) 1 1]...
                            ,[length(lon_ind) length(lat_ind) 1 inf]));
                    end
                    e(e<=-32767) = nan;%le(le<=-999)=nan;                    
                    e = permute(e,[2 1 3]); %% rotate/re-orient LE array
                    e = e(:,:,24:24:length(e(1,1,:))); % era5-land is cumulative ; value at 00:00 [or even ~2300] is thus the total daily ET
%                     e = squeeze(nanmean(reshape(e,size(e,1),size(e,2),24,[]),3));
                    ET.ET = -e*1000;clear e %*1000 m to mm % -e : "Therefore, negative values indicate evaporation and positive values indicate condensation." - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land?tab=overview
                    
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ERA5_Land\ET\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_Land_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                    e = squeeze(ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'e'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]))/3600; %% /3600 to convert from J.m-2 >> W.m-2
                    e(e<=-32767) = nan;
                    e = e(24:24:length(e(1,1,:))); % era5-land is cumulative ; value at 00:00 [or even ~2300] is thus the total daily ET
%                     e = nanmean(reshape(e,24,[]));
                    ET_pt.ET = -e*1000;clear e %*1000 m to mm % -e : "Therefore, negative values indicate evaporation and positive values indicate condensation." - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land?tab=overview

                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'time');

                    % save point struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ERA5_Land\ET\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_Land_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end        
        end
    end
end


%% ERA5-Land : DAILY latent heat flux [J.m-2]

ERA5_Land_files = dir([indir era5_land_le_dir]);
for i=3:length(ERA5_Land_files)
    if contains([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'.nc')
        lat = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'latitude');
        lon = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'longitude');
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                    % total ET - denoted 'slhf' - daily LE
                    try
                        le = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'slhf'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                    catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                        le = squeeze(ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'slhf'...
                            ,[lon_ind(1) lat_ind(1) 1 1]...
                            ,[length(lon_ind) length(lat_ind) 1 inf]));
                    end
                    le(le<=-32767) = nan;%le(le<=-999)=nan;
                    le = le/3600; %% /3600 to convert from J.m-2 >> W.m-2
                    le = permute(le,[2 1 3]); %% rotate/re-orient LE array
                    le = le(:,:,24:24:length(le(1,1,:))); % era5-land is cumulative ; value at 00:00 [or even ~2300] is thus the total daily LE
%                     le = squeeze(nanmean(reshape(le,size(le,1),size(le,2),24,[]),3));
                    ET.LE = le;clear le
                    
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ERA5_Land\LR\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_Land_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                    le = squeeze(ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'slhf'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                    le(le<=-32767) = nan;
                    le = le/3600; %% /3600 to convert from J.m-2 >> W.m-2
                    le=le(24:24:length(le(1,1,:))); % era5-land is cumulative ; value at 00:00 [or even ~2300] is thus the total daily LE
%                     le = nanmean(reshape(le,24,[]));
                    ET_pt.LE = le;clear le

                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([ERA5_Land_files(i).folder '\' ERA5_Land_files(i).name],'time');

                    % save point struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ERA5_Land\LE\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir ERA5_Land_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end        
        end
    end
end


%% HIGH-GENERALIZABILITY Land ET : MONTHLY ET

HG_files = dir([indir hg_dir]);
for i=3:length(HG_files)
    if contains([HG_files(i).folder '\' HG_files(i).name],'.nc')
        lat = ncread([HG_files(i).folder '\' HG_files(i).name],'lat');
        lon = ncread([HG_files(i).folder '\' HG_files(i).name],'lon');
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                    % total ET - denoted 'LE' - monthly LE from 1982-2018
                    le = ncread([HG_files(i).folder '\' HG_files(i).name],'LE'...
                        ,[lon_ind(1) lat_ind(1) 1]...
                        ,[length(lon_ind) length(lat_ind) inf]);

                    % uncertainty - denoted 'LE_std' - standard deviation of monthly le from 1980-2018
                    le_sd = ncread([HG_files(i).folder '\' HG_files(i).name],'LE_std'...
                        ,[lon_ind(1) lat_ind(1) 1]...
                        ,[length(lon_ind) length(lat_ind) inf]);
                    
                    ET.ET = flipud(permute(le,[2 1 3])); %% rotate/re-orient LE array 
                    ET.ET_sd = flipud(permute(le_sd,[2 1 3])); %% rotate/re-orient SD array 
                    
                    ET.coord.lat = flipud(lat(lat_ind)); % flip to start from north southwards
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([HG_files(i).folder '\' HG_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\HG_Land\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir HG_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                    ET_pt.ET = squeeze(ncread([HG_files(i).folder '\' HG_files(i).name],'LE'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]));

                    % uncertainty - denoted 'LE_std' - standard deviation of monthly le from 1982-2018
                    ET_pt.ET_sd = squeeze(ncread([HG_files(i).folder '\' HG_files(i).name],'LE'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                    
                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([HG_files(i).folder '\' HG_files(i).name],'time');

                    % save point struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\HG_Land\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir HG_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end        
        end
    end
end


%% MERRA : 'EVAP - [kg m-2 s-1]' | 'EFLUX - [W m-2]'
indir_merra=[indir merra_dir]; % merra_dir defined further up as 'MERRAv2'

merra_dirs = dir(indir_merra);
for i_merraYR=3:length(merra_dirs)
    if ~isfolder([merra_dirs(i_merraYR).folder '\' merra_dirs(i_merraYR).name]), continue; end
    merra_ncfls = dir([merra_dirs(i_merraYR).folder '\' merra_dirs(i_merraYR).name]);
    for i_flds=1:length(fields)
        ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
        ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
        for i=3:length(merra_ncfls)
            if contains([merra_ncfls(i).folder '\' merra_ncfls(i).name],'.nc')
                
                lat = ncread([merra_ncfls(i).folder '\' merra_ncfls(i).name],'lat');
                lon = ncread([merra_ncfls(i).folder '\' merra_ncfls(i).name],'lon');
        
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'ET' - monthly ET from 1980
                        le = ncread([merra_ncfls(i).folder '\' merra_ncfls(i).name],'EFLUX'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                        le(le>9999)=nan;
                        le = nanmean(le,3)/28.4; % for daily ave. latent energy converted to ET in mm/d                    
                        le = flipud(le'); %% rotate/re-orient array 
    
                        ET.ET = cat(3,ET.ET,le);clear le;
                        
                        ET.coord.lat = flipud(lat(lat_ind)); % flip to start from north southwards
                        ET.coord.lon = lon(lon_ind);
                        ET.time = [ET.time;merra_ncfls(i).name(end-11:end-8)];
%                         ET.time = ncread([merra_ncfls(i).folder '\' merra_ncfls(i).name],'time');
    
                    case 'point'
                        pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                        pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                        % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                        ET_pt.ET = squeeze(ncread([merra_ncfls(i).folder '\' merra_ncfls(i).name],'EFLUX'...
                            ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                            ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                        ET_pt.ET(ET_pt.ET>9999) = nan;
                        ET_pt.ET = nanmean(ET_pt.ET)/28.4; %#ok % for daily ave. latent energy converted to ET in mm/d 

                        ET_pt.coord.lat = lat(pt_lat_ind);
                        ET_pt.coord.lon = lon(pt_lon_ind);
                        ET_pt.time = [ET_pt.time;merra_ncfls(i).name(end-11:end-8)];
%                         ET_pt.time = ncread([merra_ncfls(i).folder '\' merra_ncfls(i).name],'time');
                end        
        
            end
        end
        % save subset struct
        switch extract_what
                case 'area'
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' merra_dir '\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir '\' merra_ncfls(i).name(1:end-12) '.mat'],'-struct','ET')
                case 'point'                        
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\' merra_dir '\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir '\' merra_ncfls(i).name(1:end-12) '.mat'],'-struct','ET_pt')
        end
        clear ET_pt ET
    end
end


%% GLDAS CLSM025 : ''Evap_tavg' - [kg m-2 s-1]' | 'Qle_tavg - [W m-2]'
indir_gldas=[indir gldasclsm_dir]; % gldasclsm_dir defined further up as 'GLDAS_CLSM025'

gldas_dirs = dir(indir_gldas);
for i_gldasYR=3:length(gldas_dirs)
    if ~isfolder([gldas_dirs(i_gldasYR).folder '\' gldas_dirs(i_gldasYR).name]), continue; end
    gldas_ncfls = dir([gldas_dirs(i_gldasYR).folder '\' gldas_dirs(i_gldasYR).name]);
    for i_flds=1:length(fields)
        ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
        ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
        for i=3:length(gldas_ncfls)
            if contains([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'.nc')
                
                lat = ncread([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'lat');
                lon = ncread([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'lon');
        
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'ET' - monthly ET from 1980
                        le = ncread([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'Qle_tavg'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                        le(le==-9999)=nan;
                        le = le/28.4; % for daily ave. latent energy converted to ET in mm/d                    
                        le = flipud(le'); %% rotate/re-orient array 
    
                        ET.ET = cat(3,ET.ET,le);clear le;
                        
                        ET.coord.lat = flipud(lat(lat_ind)); % flip to start from north southwards
                        ET.coord.lon = lon(lon_ind);
                        ET.time = [ET.time;gldas_ncfls(i).name(end-11:end-8)];                        
    
                    case 'point'
                        pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                        pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                        % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                        ET_pt.ET = squeeze(ncread([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'Qle_tavg'...
                            ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                            ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                        ET_pt.ET = ET_pt.ET/28.4; % for daily ave. latent energy converted to ET in mm/d 
                        
                        ET_pt.coord.lat = lat(pt_lat_ind);
                        ET_pt.coord.lon = lon(pt_lon_ind);
                        ET_pt.time = gldas_ncfls(i).name(end-11:end-8);%ncread([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'time');
                end        
        
            end
        end
        % save subset struct
        switch extract_what
                case 'area'
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\' gldasclsm_dir '\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir '\' gldas_ncfls(i).name(1:end-12) '.mat'],'-struct','ET')
                case 'point'                        
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\' gldasclsm_dir '\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir '\' gldas_ncfls(i).name(1:end-12) '.mat'],'-struct','ET_pt')
        end
        clear ET_pt ET
    end
end


%% GLDAS_NOAH ['Evap_tavg kg m-2 s-1']
% indir=['F:\RS_data\ET\' 'SSEBop\SSEBop_v5\global_decadal\'];
indir_gldasnoah=[indir gldas_dir];
gldasnoah_files=dir(indir_gldasnoah);

ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
for i=3:length(gldasnoah_files)
    if contains([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'.nc')
        lat = ncread([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'lat');
        lon = ncread([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'lon');
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                    % total ET - denoted 'ET' - monthly ET from 1980
                    et = ncread([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'EFLUX'...
                        ,[lon_ind(1) lat_ind(1) 1]...
                        ,[length(lon_ind) length(lat_ind) inf]);
                    et = et*3600*3; % for 3-hourly ET in mm/3hr
                    
                    ET.ET = flipud(et'); %% rotate/re-orient array 
                    
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'time');

                    % save subset struct
                    out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\GLDAS_NOAH\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir gldasnoah_files(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                    ET_pt.ET = squeeze(ncread([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'E'...
                        ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                        ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                    
                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([gldasnoah_files(i).folder '\' gldasnoah_files(i).name],'time');

                    % save point struct
                    out_dir = ['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\GLDAS_NOAH\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir gldasnoah_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end        
        end
    end
end


%% SSEBop v5 - global decadal [10-day] datasets
% indir=['F:\RS_data\ET\' 'SSEBop\SSEBop_v5\global_decadal\'];
indir_sebbop=[indir 'SSEBop\SSEBop_v5\global_decadal\'];
cd(indir_sebbop);zips=dir('*.zip');
mkdir ALL.SSEBop
for i=1:length(zips)
    unzip(zips(i).name,'ALL.SSEBop');
end

cd ([indir_sebbop 'ALL.SSEBop']);
geotiffs=dir('*.tif');
cd('\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts')

yrs = 2003:2020;
i_yr=1;
        
    % subset to .mat
    save_now=false;

    ET_subset.ET = []; ET_subset.coord.lat = []; ET_subset.coord.lon = []; ET_subset.time = [];
    ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];

    for i=1:length(geotiffs)
    
        if ~contains(geotiffs(i).name(1:5),num2str(yrs(i_yr))),i_yr=i_yr+1;ET=ET_subset;ET_subset.ET=[];ET_subset.time=[];save_now=true;end
    
        [sebbop_et,R]=geotiffread([geotiffs(i).folder '\' geotiffs(i).name]);%#ok        
     
        % approximate pixel coordinates
        if i==1
            lat = fliplr(R.LatitudeLimits(1):(R.LatitudeLimits(2)-R.LatitudeLimits(1))/(length(sebbop_et(:,1))-1):R.LatitudeLimits(2)); % flip to start from north southwards
            lon = R.LongitudeLimits(1):(R.LongitudeLimits(2)-R.LongitudeLimits(1))/(length(sebbop_et(1,:))-1):R.LongitudeLimits(2);
        end
    
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);

                    % decadal ET subset
                    et = sebbop_et(lat_ind,lon_ind);
                    et = double(et);et(et==255) = nan;
                    ET_subset.ET = cat(3,ET_subset.ET,et);clear et;

                    ET_subset.coord.lat = lat(lat_ind);
                    ET_subset.coord.lon = lon(lon_ind);
                    ET_subset.time = [ET_subset.time;geotiffs(i).name(6:8)];                    
            end

            if save_now   
                %% save subset struct per year
                out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\SSEBop_v5_decadal\'];
                if ~isfolder(out_dir), mkdir(out_dir),end
                save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr-1)) '.mat'],'-struct','ET')            
                save_now = false;
            elseif i==length(geotiffs) 
                ET = ET_subset; clear ET_subset
                save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr)) '.mat'],'-struct','ET')
            end

        end
           
        if save_now   
            %% save subset struct per year
            out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\SSEBop_v5_decadal\'];
            if ~isfolder(out_dir), mkdir(out_dir),end
            save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr-1)) '.mat'],'-struct','ET')            
            save_now = false;
        elseif i==length(geotiffs) 
            ET = ET_subset; clear ET_subset
            save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr)) '.mat'],'-struct','ET')
        end   
    end




% % % %% SSEBop v5 - global decadal [10-day] datasets
% % % % indir=['F:\RS_data\ET\' 'SSEBop\SSEBop_v5\global_decadal\'];
% % % indir_sebbop=[indir 'SSEBop\SSEBop_v5\global_decadal\'];
% % % cd(indir_sebbop);zips=dir('*.zip');
% % % mkdir ALL.SSEBop
% % % for i=1:length(zips)
% % %     unzip(zips(i).name,'ALL.SSEBop');
% % % end
% % % 
% % % cd ([indir_sebbop 'ALL.SSEBop']);
% % % geotiffs=dir('*.tif');
% % % cd('\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts')
% % % 
% % % yrs = 2003:2020;
% % % i_yr=1;
% % %         
% % %     % whole/global images to .mat
% % %     save_now=false;
% % %     sebbop_ET.ET = []; sebbop_ET.coord.lat = []; sebbop_ET.coord.lon = []; sebbop_ET.time = [];
% % %     for i=1:length(geotiffs)
% % %     
% % %         if ~contains(geotiffs(i).name(1:5),num2str(yrs(i_yr))),i_yr=i_yr+1;ET=sebbop_ET;sebbop_ET.ET=[];sebbop_ET.time=[];save_now=true;end
% % %     
% % %         [sebbop_et,R]=geotiffread([geotiffs(i).folder '\' geotiffs(i).name]);%#ok        
% % % %         sebbop_et=double(sebbop_et);
% % % %         sebbop_et(sebbop_et==255)=nan; % fill missing values with nans
% % %         sebbop_ET.ET=cat(3,sebbop_ET.ET,sebbop_et);
% % %     
% % %             % approximate pixel coordinates
% % %             if i==1
% % %                 lat = fliplr(R.LatitudeLimits(1):(R.LatitudeLimits(2)-R.LatitudeLimits(1))/(length(sebbop_et(:,1))-1):R.LatitudeLimits(2)); % flip to start from north southwards
% % %                 lon = R.LongitudeLimits(1):(R.LongitudeLimits(2)-R.LongitudeLimits(1))/(length(sebbop_et(1,:))-1):R.LongitudeLimits(2);
% % %             end
% % %     
% % %         sebbop_ET.coord.lat=lat;
% % %         sebbop_ET.coord.lon=lon;
% % %         sebbop_ET.time = [sebbop_ET.time;geotiffs(i).name(6:8)];
% % %     
% % %         if save_now   
% % %             %% save whole .tif - global decadal et in .mat per year
% % %             out_dir = [indir_sebbop 'mat\'];
% % %             if ~isdir(out_dir),mkdir(out_dir);end
% % %             save([out_dir '\' 'SEBBop_v5_' num2str(yrs(i_yr-1)) '.mat'],'-struct','ET')
% % %             save_now = false;
% % %         elseif i==length(geotiffs)
% % %             ET=sebbop_ET;clear sebbop_ET;
% % %             save([out_dir '\' 'SEBBop_v5_' num2str(yrs(i_yr)) '.mat'],'-struct','ET')
% % %         end   
% % %     end
% % % 
% % % % SUBSETTING .mat to within AOIs
% % % 
% % % indir_sebbop_mat=[indir_sebbop 'mat\'];
% % % SEBBop_fls=what(sebbop_dir_mat);
% % % 
% % % ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
% % % ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
% % % for i=1:length(SEBBop_fls)
% % %     % load global data for subsetting
% % %     sebbop_et=load([indir_sebbop_mat SEBBop_fls(i)],'ET');
% % %     sebbop_time=load([indir_sebbop_mat SEBBop_fls(i)],'time');
% % %     lat=load([indir_sebbop_mat SEBBop_fls(i)],'coord');lat=lat.lat;
% % %     lon=load([indir_sebbop_mat SEBBop_fls(i)],'coord');lon=lon.lon;
% % %     for i_flds=1:length(fields)
% % %             switch extract_what
% % %                 case 'area'
% % %                     tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
% % %                     RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
% % %                     lat_ind = find(lat<=tOP & lat>=bTtm);
% % %                     lon_ind = find(lon<=RigHT & lon>=leFT);
% % % 
% % %                     % decadal ET subset                    
% % %                     ET.ET = double(sebbop_et(lat_ind,lon_ind,:));
% % %                     ET.ET(ET.ET==255)=nan;
% % % 
% % %                     ET.coord.lat=lat(lat_ind);
% % %                     ET.coord.lon=lon(lon_ind);
% % %                     ET.time=sebbop_time;
% % % 
% % %                     % save subset struct
% % %                     out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\SSEBop_v5_decadal\'];
% % %                     if ~isfolder(out_dir), mkdir(out_dir),end
% % %                     save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr)) '.mat'],'-struct','ET')                    
% % %                     clear ET
% % % 
% % %                     save([strrep(geotiffs(i).folder,'ALL.SSEBop','ALL.mat') '\' strrep(geotiffs(i).name,'.tif','.mat')],'-struct','ET')
% % %             end
% % %     end
% % %     clear sebbop_et
% % % end



%%

%% ALL - POINT
paths = {'\point\CAMELE';...
    '\point\FLUXCOM\EnergyFluxes\RS\ensemble\720_360\8daily';...
    '\point\FLUXCOM\EnergyFluxes\RS\ensemble\720_360\monthly';...
    '\point\FLUXCOM\EnergyFluxes\RS\ensemble\4320_2160\8daily';...
    '\point\FLUXCOM\EnergyFluxes\RS\ensemble\4320_2160\monthly';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\ALL\daily';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\ALL\monthly';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\daily';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\monthly';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\daily';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\monthly';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\GSWP3\daily';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\GSWP3\monthly';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\WFDEI\daily';...
    '\point\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\WFDEI\monthly';...
    '\point\GLEAM\v3.7b\daily';...
    '\point\GLEAM\v3.8a\daily';...
    '\point\MSG_MDMETv3';...
    '\point\MSG_METREF'};
for i_flds=1:length(fields)
    for i=1:length(paths)
        ET_ALL.ET=[];ET_ALL.coord=[];ET_ALL.time=[];ET_ALL_025.ET=[];ET_ALL_025.coord=[];ET_ALL_025.time=[];
        fls = what(['ET_' ROIsites.(char(fields(i_flds))).site_nm char(paths(i))]);
        if contains(char(paths(i)),'CAMELE'),bool_01 = contains(fls.mat,'.01.');else,bool_01=[];end
        for i_fls=1:length(fls.mat)
            if contains(char(fls.mat(i_fls)),'ET_ALL'),continue;end
            ETdat = load(['ET_' ROIsites.(char(fields(i_flds))).site_nm char(paths(i)) '\' char(fls.mat(i_fls))]);
            if ischar(ETdat.time),ETdat.time=str2num(ETdat.time);end%#ok
            if (contains(char(paths(i)),'CAMELE') && bool_01(i_fls)) || ~contains(char(paths(i)),'CAMELE') % applies to all products except CAMELE 0.25� (0.1� & 0.25� mixed in same dir)
                ET_ALL.ET=[ET_ALL.ET;ETdat.ET];ET_ALL.time=[ET_ALL.time;ETdat.time];
                if i_fls==1,ET_ALL.coord=ETdat.coord;end
            elseif contains(char(paths(i)),'CAMELE') && ~bool_01(i_fls)
                ET_ALL_025.ET=[ET_ALL_025.ET;ETdat.ET];ET_ALL_025.time=[ET_ALL_025.ET;ETdat.time];
                ET_ALL_025.coord=ETdat.coord;
            end                
        end
        % save ALL
        save(['ET_' ROIsites.(char(fields(i_flds))).site_nm char(paths(i)) '\' 'ET_ALL'  strrep(char(paths(i)),'\','_') '.mat'],'-struct','ET_ALL')
        save(['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_ALL' strrep(char(paths(i)),'\','_') '.mat'],'-struct','ET_ALL')
        if contains(char(paths(i)),'CAMELE') && ~bool_01(i_fls)
            save(['ET_' ROIsites.(char(fields(i_flds))).site_nm char(paths(i)) '\' 'ET_ALL_025'  strrep(char(paths(i)),'\','_') '.mat'],'-struct','ET_ALL_025')
            save(['ET_' ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_ALL_025'  strrep(char(paths(i)),'\','_') '.mat'],'-struct','ET_ALL_025')
        end
    end
end


%% ################################################################################## %%
%%                                                                                    %%
%% REFERENCE DATA - ICOS, FLUXNET , ...                                               %%
%%                                                                                    %%
%% ################################################################################## %%
clearvars ETref ETdum

% cd('F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE')
cd('\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE')

% root_dir='F:\RS_data\ET\insitu\FR\';
root_dir='\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\RS\ET\insitu\FR\';
rt_dirs=dir(root_dir);
ETdum = [];
for i_rt=3:length(rt_dirs)
    dirs=dir([rt_dirs(i_rt).folder '\' rt_dirs(i_rt).name]);
    for i_dirs=3:length(dirs)
        if rt_dirs(i_rt).name=="icos"
%             load([dirs(i_dirs).folder '\' dirs(i_dirs).name '\matFLUXICOS.mat']);            
%             csvFLUX=csvFLUXICOS;
            csvFLUX=load([dirs(i_dirs).folder '\' dirs(i_dirs).name '\matDlyET_FLUXICOS.mat']);
            site_nm=dirs(i_dirs).name(9:14);
        else
%             load([dirs(i_dirs).folder '\' dirs(i_dirs).name '\matFLUXNET.mat']);
%             csvFLUX=csvFLUXNET;
            csvFLUX=load([dirs(i_dirs).folder '\' dirs(i_dirs).name '\matDlyET_FLUXNET.mat']);
            site_nm=dirs(i_dirs).name(5:10);
        end
        site_nm=strrep(site_nm,'-','_');
        try
            ETdd.ET=table;
            ETdd.ET.Time = csvFLUX.ETdd.Time;
            ETdd.ET.Year = floor(ETdd.ET.Time/10000);
            ETdd.ET.Month = floor(ETdd.ET.Time/100)-ETdd.ET.Year*100;
            ETdd.ET.Day = ETdd.ET.Time-ETdd.ET.Year*10000-ETdd.ET.Month*100;
            ETdd.ET.DoY = day(datetime(ETdd.ET.Year,ETdd.ET.Month,ETdd.ET.Day),'dayofyear');
            
            ETdd.ET.ET_MDS=csvFLUX.ETdd.ET_F_MDS;
            ETdd.ET.ET_CORR = csvFLUX.ETdd.ET;
            if all(isnan(csvFLUX.ETdd.ET)) %% most likely SEB closure correction did not work                
                ETdd.ET.ET=csvFLUX.ETdd.ET_F_MDS; ETdd.corr = false;
            else
                ETdd.ET.ET = csvFLUX.ETdd.ET;ETdd.corr = true;
            end
            
            ETdd.ET.ET_MDS(ETdd.ET.ET_MDS<-100 | ETdd.ET.ET_MDS>600)=nan;
            ETdd.ET.ET_CORR(ETdd.ET.ET_CORR<-100 | ETdd.ET.ET_CORR>600)=nan;
            ETdd.ET.ET(ETdd.ET.ET<-100 | ETdd.ET.ET>600)=nan;
        catch
            continue
        end
        eval(['ETdum.' site_nm '.' rt_dirs(i_rt).name '= ETdd;']);
    end
end

ETdum = orderfields(ETdum);%fields_ref = fieldnames(ETdum);

%%% make sure these are always consistent with everywhere else (i.e. fields/site_nm in var ROIsites in the following section)
fields_sitenm = {'FR_Aur' 'Aurade';...
    'FR_Bil' 'Bilos';...
    'FR_EM2' 'EstreesMons';...
    'FR_FBn' 'Fontblanche';...
    'FR_Fon' 'FontainebleauB';...
    'FR_Gri' 'Grignon';...
    'FR_Hes' 'Hesse';...
    'FR_LBr' 'LeBray';...
    'FR_LGt' 'LaGuette';...
    'FR_Lam' 'Lamasquere';...
    'FR_Mej' 'Mejusseaume';...
    'FR_Pue' 'Puechabon';...
    'FR_Tou' 'Toulouse'};

    %%% modified0804 : combine all data ---xxx---remove fields with shortest timeseries (between fluxnet, icos, drought and warmwinter) --- to modify accordingly ! i.e. combine all data
    ETdumm=[];
    for i_flds=1:length(fields_sitenm(:,1))
        fields_refver = fieldnames(ETdum.(fields_sitenm{i_flds,1}));
        sz_ET = [];min_yr=[];max_yr=[];
        for i_ver=1:length(fields_refver)
            sz_ET = [sz_ET;size(ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver}).ET,1)];%#ok
            min_yr=[min_yr;min(ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver}).ET.Year)];%#ok
            max_yr=[max_yr;max(ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver}).ET.Year)];%#ok
        end
        ind=sz_ET==max(sz_ET);
%         ETdumm.(fields_sitenm{i_flds,1}) = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{ind});
        ETdumm.(fields_sitenm{i_flds,1}) = [];
        ET_longest = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{ind});
        ET_min.ET = [];ET_max.ET = [];
        ET_combined.ET = [ET_min.ET;ET_longest.ET;ET_max.ET];
        for i_ver=1:length(fields_refver)
            if ind(i_ver),continue;end
            
            if min_yr(i_ver)<min(ET_combined.ET.Year)%min_yr(ind)
                if max_yr(i_ver)<min(ET_combined.ET.Year)%min_yr(ind)
                    ET_min = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver});
                else
                    ind_minmx=find(ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver}).ET.Year<min(ET_combined.ET.Year),1,'last');
                    ET_min = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver});
                    ET_min.ET(ind_minmx+1:end,:)=[];
                end
            else
                ET_min.ET = [];
            end
            
            if max_yr(i_ver)>max(ET_combined.ET.Year)%max_yr(ind)
                if min_yr(i_ver)>max(ET_combined.ET.Year)%max_yr(ind)
                    ET_max = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver});
                else
                    ind_maxmn=find(ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver}).ET.Year>max(ET_combined.ET.Year),1,'first');
                    ET_max = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver});
                    ET_max.ET(1:ind_maxmn-1,:)=[];
                end
            else
                ET_max.ET = [];
            end
            ET_combined.ET = [ET_min.ET;ET_combined.ET;ET_max.ET];clear ET_max ET_min
            
            if ~all(ismember(unique(ETdum.(fields_sitenm{i_flds,1}).(fields_refver{i_ver}).ET.Year),unique(ET_combined.ET.Year))) %% where above logic fails - i.e. years missing in-between
                keyboard
            end
            
        end
        ETdumm.(fields_sitenm{i_flds,1}) = ETdum.(fields_sitenm{i_flds,1}).(fields_refver{ind});
        ETdumm.(fields_sitenm{i_flds,1}).ET = ET_combined.ET;%[ET_min.ET;ET_longest.ET;ET_max.ET];

        clear ET_min ET_longest ET_max
    end
    ETdum=ETdumm; clear ETdumm
    %%%

%%% prepare array - [1950-2023]
ly=@(yr)~rem(yr,400)|(rem(yr,100)&~rem(yr,4));

yrs=1950:2023;
ly_yrs=ly(yrs);

all_yrsdoys=[yrs;ly_yrs]';
all_yrsdoys(ly_yrs,3)=366;ly_mths=[ones(31,1);ones(29,1)*2;ones(31,1)*3;ones(30,1)*4;ones(31,1)*5;ones(30,1)*6;ones(31,1)*7;ones(31,1)*8;ones(30,1)*9;ones(31,1)*10;ones(30,1)*11;ones(31,1)*12];
all_yrsdoys(~ly_yrs,3)=365;nly_mths=[ones(31,1);ones(28,1)*2;ones(31,1)*3;ones(30,1)*4;ones(31,1)*5;ones(30,1)*6;ones(31,1)*7;ones(31,1)*8;ones(30,1)*9;ones(31,1)*10;ones(30,1)*11;ones(31,1)*12];

yrs_doys_mths.DLY=[];yrs_doys_mths.MTHLY=[];yrs_doys_mths.YRLY=[];
for i=1:length(yrs)
    if all_yrsdoys(i,3)==366;mths=ly_mths;else,mths=nly_mths;end
    yr_doys_mths=[ones(all_yrsdoys(i,3),1)*yrs(i) (1:all_yrsdoys(i,3))' mths];
    yrs_doys_mths.DLY=[yrs_doys_mths.DLY;yr_doys_mths];
%     yrs_doys_mths.MTHLY=[yrs_doys_mths.MTHLY;[ones(12,1)*yrs(i) (1:12)']];
%     yrs_doys_mths.YRLY=[yrs_doys_mths.YRLY;yrs(i)];
end
%%% prepare array

for i_flds=1:length(fields_sitenm(:,1))
    
    ETref.(fields_sitenm{i_flds,2}).ET = table;
    ETref.(fields_sitenm{i_flds,2}).ET.year = yrs_doys_mths.DLY(:,1);
    ETref.(fields_sitenm{i_flds,2}).ET.doy = yrs_doys_mths.DLY(:,2);
    ETref.(fields_sitenm{i_flds,2}).ET.month = yrs_doys_mths.DLY(:,3);
    ETref.(fields_sitenm{i_flds,2}).ET.ET = yrs_doys_mths.DLY(:,1)*nan;
    ETref.(fields_sitenm{i_flds,2}).ET.ET_MDS = yrs_doys_mths.DLY(:,1)*nan;
    ETref.(fields_sitenm{i_flds,2}).ET.ET_CORR = yrs_doys_mths.DLY(:,1)*nan;
    
    et=ETdum.(fields_sitenm{i_flds,1}).ET.ET;
    et_mds=ETdum.(fields_sitenm{i_flds,1}).ET.ET_MDS;
    et_corr=ETdum.(fields_sitenm{i_flds,1}).ET.ET_CORR;
    
    ind = ismember((yrs_doys_mths.DLY(:,1)*1000+yrs_doys_mths.DLY(:,2))...
        ,(ETdum.(fields_sitenm{i_flds,1}).ET.Year*1000+ETdum.(fields_sitenm{i_flds,1}).ET.DoY));
    
    ETref.(fields_sitenm{i_flds,2}).ET.ET(ind) = et;
    ETref.(fields_sitenm{i_flds,2}).ET.ET_MDS(ind) = et_mds;
    ETref.(fields_sitenm{i_flds,2}).ET.ET_CORR(ind) = et_corr;
%     eval(['ETref.' fields_sitenm{i_flds,2} '= ETdum.' fields_sitenm{i_flds,1} ';']);
end
save('ET_reference_AllSites_SouthFrance.mat','ETref')

% % % REPLACED WITH THE [MUCH] SIMPLER CODE ABOVE
% % %
% % % for i_flds=1:length(fields_sitenm(:,1))
% % %     
% % %     ETref.(fields_sitenm{i_flds,2}).ET = table;
% % %     ETref.(fields_sitenm{i_flds,2}).ET.year = yrs_doys_mths.DLY(:,1);
% % %     ETref.(fields_sitenm{i_flds,2}).ET.doy = yrs_doys_mths.DLY(:,2);
% % %     ETref.(fields_sitenm{i_flds,2}).ET.month = yrs_doys_mths.DLY(:,3);
% % %     
% % %     
% % %     yrs_ref = ETdum.(fields_sitenm{i_flds,1}).ET.Year;
% % %     yrs_ind = ismember(yrs,unique(yrs_ref));
% % %         yrs_ref_uniq = all_yrsdoys(yrs_ind,1);
% % %         doys_ref = all_yrsdoys(yrs_ind,3);    
% % %     
% % %     %%% construct ET array
% % %         % initial years without data - assigned nans
% % %         init1 = find(yrs_ind==1,1,'first');
% % %         init0s = nan(sum(all_yrsdoys(1:init1-1,3)),1); % daily
% % %         % last years without data - assigned nans
% % %         last1 = find(yrs_ind==1,1,'last');
% % %         last0s = nan(sum(all_yrsdoys((last1+1):end,3)),1); % daily
% % %         
% % %     et = init0s;et_mds = init0s;et_corr = init0s;
% % %     for i_yr=1:length(yrs_ref_uniq)
% % %         
% % %         % gaps in timeseries', e.g 2019, 2020 , 2022 
% % %         if i_yr>1 && yrs_ref_uniq(i_yr)-yrs_ref_uniq(i_yr-1)>1
% % %             yrs_missd = yrs_ref_uniq(i_yr-1):yrs_ref_uniq(i_yr);
% % %             yrs_missd(yrs_missd==yrs_ref_uniq(i_yr-1) | yrs_missd==yrs_ref_uniq(i_yr))=[];
% % %             dys_missd=yrs_missd*nan;
% % %             dys_missd(ly(yrs_missd))=366;dys_missd(~ly(yrs_missd))=365;
% % %             et = [et;nan(sum(dys_missd),1)];%#ok
% % %             et_mds = [et_mds;nan(sum(dys_missd),1)];%#ok
% % %             et_corr = [et_corr;nan(sum(dys_missd),1)];%#ok    
% % %         end
% % %         
% % %         yrs_ref_ind = ismember(yrs_ref,yrs_ref_uniq(i_yr));
% % %         if sum(yrs_ref_ind)==doys_ref(i_yr)
% % %             et_=ETdum.(fields_sitenm{i_flds,1}).ET.ET(yrs_ref_ind);
% % %             et__mds=ETdum.(fields_sitenm{i_flds,1}).ET.ET_MDS(yrs_ref_ind);
% % %             et__corr=ETdum.(fields_sitenm{i_flds,1}).ET.ET_CORR(yrs_ref_ind);
% % %         else
% % % %                 keyboard
% % % %                 yr_=[yr_;yrs_pdct_uniq(i_yr)];
% % % %                 pdct_miss{i_miss,1}=et_fields{i};pdct_miss{i_miss,2}=yr_;i_miss=i_miss+1;
% % % 
% % %             time=ETdum.(fields_sitenm{i_flds,1}).ET.DoY;            
% % % 
% % %             if ly(yrs_ref_uniq(i_yr)),time_ind=ismember(1:366,round(time(yrs_ref_ind)));et_=nan(366,1);else,time_ind=ismember(1:365,round(time(yrs_ref_ind)));et_=nan(365,1);end                   
% % %             et__mds=et_;et__corr=et_;
% % %             et_(time_ind)=ETdum.(fields_sitenm{i_flds,1}).ET.ET(yrs_ref_ind);
% % %             et__mds(time_ind)=ETdum.(fields_sitenm{i_flds,1}).ET.ET_MDS(yrs_ref_ind);
% % %             et__corr(time_ind)=ETdum.(fields_sitenm{i_flds,1}).ET.ET_CORR(yrs_ref_ind);
% % % 
% % %         end
% % %         et = [et;et_];%#ok
% % %         et_mds = [et_mds;et__mds];%#ok
% % %         et_corr = [et_corr;et__corr];%#ok
% % % %         eval(['ETref.' fields_sitenm{i_flds,2} '.ET.ET(yrs_pdct_ind) = et_;']);
% % %     end
% % %     et = [et;last0s];%#ok
% % %     et_mds = [et_mds;last0s];%#ok
% % %     et_corr = [et_corr;last0s];%#ok
% % %     ETref.(fields_sitenm{i_flds,2}).ET.ET = et;
% % %     ETref.(fields_sitenm{i_flds,2}).ET.ET_MDS = et_mds;
% % %     ETref.(fields_sitenm{i_flds,2}).ET.ET_CORR = et_corr;
% % % %     eval(['ETref.' fields_sitenm{i_flds,2} '= ETdum.' fields_sitenm{i_flds,1} ';']);
% % % end
% ET_reference.ET = ETref;
% ET_reference.fields_sitenm =fields_sitenm;


% % % save('ET_reference_AllSites_SouthFrance.mat','ETref')


%% ################################################################################## %%
%%                                                                                    %%
%% ALL FLUX POINTS - FROM SUBSET GLOBAL ET DATA [FRANCE EVALUATIONS]                  %%
%%                                                                                    %%
%% ################################################################################## %%
clear

% indir = '\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE'; % France subset
% indir = 'F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE';
indir = '\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\EXTRACTS\France'; % France subset
cd(indir)

ly=@(yr)~rem(yr,400)|(rem(yr,100)&~rem(yr,4));

var_dir = '\ET_subset_France';% ET,PPT,LWE
extract_what = ['area' var_dir]; % 'point' or 'area'

paths = {['\' extract_what '\CAMELE\01'];...
    ['\' extract_what '\CAMELE\025'];...
    ['\' extract_what '\DOLCE\DOLCE_v2.1'];...
    ['\' extract_what '\DOLCE\DOLCE_v3.0'];...
    ['\' extract_what '\ERA5'];...
    ['\' extract_what '\ERA5_Land'];...
    ['\' extract_what '\ETMonitor'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS\ensemble\720_360\8daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS\ensemble\720_360\monthly'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS\ensemble\4320_2160\8daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS\ensemble\4320_2160\monthly'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\ALL\daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\ALL\monthly'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CERES_GPCP\monthly'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\CRUNCEP_v8\monthly'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\GSWP3\daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\GSWP3\monthly'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\WFDEI\daily'];...
    ['\' extract_what '\FLUXCOM\EnergyFluxes\RS_METEO\ensemble\WFDEI\monthly'];...
    ['\' extract_what '\GLDAS_CLSM025'];...
    ['\' extract_what '\GLDAS_NOAH025'];...
    ['\' extract_what '\GLEAM\v3.7b\daily'];...
    ['\' extract_what '\GLEAM\v3.8a\daily'];...
    ['\' extract_what '\HG_Land'];...    
    ['\' extract_what '\MCD16\MOD'];...
    ['\' extract_what '\MCD16\MYD'];...
    ['\' extract_what '\MERRAv2'];...
    ['\' extract_what '\MSG_MDMETv3'];...%['\' extract_what '\MSG_METREF'];...
    ['\' extract_what '\SSEBop_v5_decadal']};%['\' extract_what '\SSEBop_v5_global_decadal']};

ET_nm ={'CAMELE01_DLY',...
    'CAMELE025_DLY',...
    'DOLCE2_1_MTHLY',...
    'DOLCE3_0_MTHLY',...
    'ERA5_DLY',...
    'ERA5_Land_DLY',...
    'ETMonitor_DLY',...
    'FCOM_RS_720x360_8D',...
    'FCOM_RS_720x360_MTHLY',...
    'FCOM_RS_4320x2160_8D',...
    'FCOM_RS_4320x2160_MTHLY',...
    'FCOM_RSMET_ALL_DLY',...
    'FCOM_RSMET_ALL_MTHLY',...
    'FCOM_RSMET_CERES_DLY',...
    'FCOM_RSMET_CERES_MTHLY',...
    'FCOM_RSMET_CRUNCEP_DLY',...
    'FCOM_RSMET_CRUNCEP_MTHLY',...
    'FCOM_RSMET_GSWP3_DLY',...
    'FCOM_RSMET_GSWP3_MTHLY',...
    'FCOM_RSMET_WFDEI_DLY',...
    'FCOM_RSMET_WFDEI_MTHLY',...    
    'GLDAS_CLSM025_DLY',...
    'GLDAS_NOAH025_DLY',...
    'GLEAM3_7b_DLY',...
    'GLEAM3_8a_DLY',...
    'HG_Land_MTHLY',...
    'MOD16_YR',...
    'MYD16_YR',...
    'MERRA2_DLY',...
    'MSG_DLY',...
    'SSEBOP5_10D'};

clear ET_ALL ROIsites

        % All French sites % LATLON

        %%% Avignon
        % "Remote sensing and flux site" of INRAe
        ROIsites.FR_Avignon.lat_pt = 43.9168; % N
        ROIsites.FR_Avignon.lon_pt = 4.8781; % E
        ROIsites.FR_Avignon.site_nm = 'Avignon';

        % Crau-Camargue (Avignon) site
        ROIsites.FR_Crau_Camargue.lat_pt = 43.5586; % N
        ROIsites.FR_Crau_Camargue.lon_pt = 4.8623; % E
        ROIsites.FR_Crau_Camargue.site_nm = 'CrauCamargue';

        % Crau-dmnMerie (Avignon) site
        ROIsites.FR_Crau_dmnMerie.lat_pt = 43.6423; % N
        ROIsites.FR_Crau_dmnMerie.lon_pt = 5.0073; % E
        ROIsites.FR_Crau_dmnMerie.site_nm = 'CrauMerle';


        %%% FluxNet2015
        % FR-Fon: Fontainebleau-Barbeau - https://fluxnet.org/sites/siteinfo/FR-Fon
        ROIsites.FR_FontainebleauB.lat_pt = 48.4764; % N
        ROIsites.FR_FontainebleauB.lon_pt = 2.7801; % E
        ROIsites.FR_FontainebleauB.site_nm = 'FontainebleauB';

        % FR-Gri: Grignon - https://fluxnet.org/sites/siteinfo/FR-Gri
        ROIsites.FR_Grignon.lat_pt = 48.8442; % N
        ROIsites.FR_Grignon.lon_pt = 1.9519; % E
        ROIsites.FR_Grignon.site_nm = 'Grignon';

        % FR-LBr: Le Bray - https://fluxnet.org/sites/siteinfo/FR-LBr
        ROIsites.FR_LeBray.lat_pt = 44.7171; % N
        ROIsites.FR_LeBray.lon_pt = -0.7693; % W
        ROIsites.FR_LeBray.site_nm = 'LeBray';

        % FR-Pue: Puechabon - https://fluxnet.org/sites/siteinfo/FR-Pue
        ROIsites.FR_Puechabon.lat_pt = 43.7413; % N
        ROIsites.FR_Puechabon.lon_pt = 3.5957; % E
        ROIsites.FR_Puechabon.site_nm = 'Puechabon';

        % FR-Fontblanche
        ROIsites.FR_Fontblanche.lat_pt = 43.24079; % N
        ROIsites.FR_Fontblanche.lon_pt = 5.67865; % E
        ROIsites.FR_Fontblanche.site_nm = 'Fontblanche';

        % FR-Tour du Valat
        ROIsites.FR_Tour_du_Valat.lat_pt = 43.4888; % N
        ROIsites.FR_Tour_du_Valat.lon_pt = 4.6654; % E
        ROIsites.FR_Tour_du_Valat.site_nm = 'Tour_du_Valat';

        % FR-Larzac
        ROIsites.FR_Larzac.lat_pt = 43.9704; % N
        ROIsites.FR_Larzac.lon_pt = 3.2228; % E
        ROIsites.FR_Larzac.site_nm = 'Larzac';

        % FR-Toulouse
        ROIsites.FR_Toulouse.lat_pt = 43.572857; % N
        ROIsites.FR_Toulouse.lon_pt = 1.37474; % E
        ROIsites.FR_Toulouse.site_nm = 'Toulouse';

        % FR-Lamasqu�re
        ROIsites.FR_Lamasquere.lat_pt = 43.496437; % N
        ROIsites.FR_Lamasquere.lon_pt = 1.237878; % E
        ROIsites.FR_Lamasquere.site_nm = 'Lamasquere';

        % FR-Aurade
        ROIsites.FR_Aurade.lat_pt = 43.54965; % N
        ROIsites.FR_Aurade.lon_pt = 1.106103; % E
        ROIsites.FR_Aurade.site_nm = 'Aurade';

        % FR-Bilos
        ROIsites.FR_Bilos.lat_pt = 44.493652; % N
        ROIsites.FR_Bilos.lon_pt = -0.956092; % W
        ROIsites.FR_Bilos.site_nm = 'Bilos';

        fields = fieldnames(ROIsites);

for i=1:length(paths)    
    fls = what([indir paths{i}]);    
    for i_fls=1:length(fls.mat)        

        ETdat = load([indir paths{i} '\' fls.mat{i_fls}]);
        if ischar(ETdat.time),ETdat.time=str2num(ETdat.time);end%#ok
        if size(ETdat.time,2)~=1,ETdat.time=ETdat.time';end

        lat = ETdat.coord.lat;
        lon = ETdat.coord.lon;
        
        if contains(ET_nm{i},'GLEAM')
            yr = repmat(str2num(fls.mat{i_fls}(3:6)),[length(ETdat.time) 1]);%#ok
        elseif contains(ET_nm{i},'HG_Land')
            yr = repmat(1982:2018,[12 1]); yr = yr(:);
        elseif contains(ET_nm{i},'ERA5') && ~contains(ET_nm{i},'ERA5_Land')
            yrs = str2num(fls.mat{i_fls}(end-12:end-9)):str2num(fls.mat{i_fls}(end-7:end-4));
            ly_bl = ly(yrs);doys_yrs=yrs;doys_yrs(ly_bl) = 366;doys_yrs(~ly_bl) = 365;
            yr = [];doy_yr=[];
            for i_yr=1:length(yrs)
                yr = [yr;ones(doys_yrs(i_yr),1)*yrs(i_yr)]; %#ok
                doy_yr = [doy_yr;(1:doys_yrs(i_yr))'];
            end
            ETdat.time = doy_yr; clear doy_yr
        elseif contains(ET_nm{i},'ERA5_Land')
            ETdat.time = ETdat.time(24:24:length(ETdat.time));
            yr = repmat(str2num(fls.mat{i_fls}(end-7:end-4)),[length(ETdat.time) 1]);%#ok
        else
            yr = repmat(str2num(fls.mat{i_fls}(end-7:end-4)),[length(ETdat.time) 1]);%#ok
        end
        
        for i_flds=1:length(fields)
            
            if i_fls==1
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).ET=[];
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).coord=[];
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).time=[];
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).year=[];
                if contains(ET_nm{i},'HG_Land') || contains(ET_nm{i},'DOLCE')
                    ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).ET_sd=[];
                end
            end            

            pt_lat_ind = find(ROIsites.(fields{i_flds}).lat_pt >= lat,1,'first');
            pt_lon_ind = find(ROIsites.(fields{i_flds}).lon_pt >= lon,1,'last');
                if abs(ROIsites.(fields{i_flds}).lat_pt - lat(pt_lat_ind)) < abs(ROIsites.(fields{i_flds}).lat_pt - lat(pt_lat_ind - 1))
                    pt_lat_ind = pt_lat_ind;
                else
                    pt_lat_ind = pt_lat_ind - 1;
                end
                if  pt_lon_ind~=length(lon)
                    if abs(ROIsites.(fields{i_flds}).lon_pt - lon(pt_lon_ind)) < abs(ROIsites.(fields{i_flds}).lon_pt - lon(pt_lon_ind + 1))
                        pt_lon_ind = pt_lon_ind;
                    else
                        pt_lon_ind = pt_lon_ind + 1;
                    end
                end
            if isempty(pt_lon_ind) || pt_lon_ind==1 || pt_lon_ind==length(lon),continue;end % for spurious extremes in h17v04 and h18v04 modis tiles

            et=squeeze(ETdat.ET(pt_lat_ind,pt_lon_ind,:));if size(et,2)~=1,et=et';end
            %%%%% comment out once monthly fluxcom ET is equal to TOTAL NOT AVE from above-when constructing ETdat .mat files
            if contains(ET_nm{i},'FCOM') && contains(ET_nm{i},'_MTHLY')
                if ly(yr(1))
                    et = et.*[31;29;31;30;31;30;31;31;30;31;30;31];
                elseif ly(~yr(1))
                    et = et.*[31;28;31;30;31;30;31;31;30;31;30;31];
                end
            end
            %%%%%
            ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).ET...
                =[ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).ET;et];

            if contains(ET_nm{i},'HG_Land') || contains(ET_nm{i},'DOLCE')
                et_sd=squeeze(ETdat.ET(pt_lat_ind,pt_lon_ind,:));if size(et_sd,2)~=1,et_sd=et_sd';end
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).ET_sd...
                    =[ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).ET_sd;et_sd];                    
            end

            ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).time...
                =[ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).time;ETdat.time];
            ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).year...
                =[ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).year;yr];
            if i_fls==1
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).coord.lat=[ROIsites.(fields{i_flds}).lat_pt ETdat.coord.lat(pt_lat_ind)];
                ET_ALL.(ROIsites.(fields{i_flds}).site_nm).(ET_nm{i}).coord.lon=[ROIsites.(fields{i_flds}).lon_pt ETdat.coord.lon(pt_lon_ind)];
            end

        end
        
    end
end
% save ALL
save('\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_Products_AllSites_SouthFrance.mat','ET_ALL')



%% ################################################################################## %%
%%                                                                                    %%
%% PREPARE/COMPILE ALL DATA WITH CONSISTENT TIME-STEPS [FOR CONSISTENT EVALUATIONS]   %%
%%                                                                                    %%
%% ################################################################################## %%

%%% first prepare point data using ET_extraction.m [SEE ABOVE]

clear

%% load data
try
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_Products_AllSites_SouthFrance.mat
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_reference_AllSites_SouthFrance.mat
catch
    load F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_Products_AllSites_SouthFrance.mat
    load F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_reference_AllSites_SouthFrance.mat
end
fields = fieldnames(ET_ALL);
et_fields=fieldnames(ET_ALL.(fields{1}));

%% init
% ly=@(yr)~rem(yr,400)|rem(yr,100)&~rem(yr,4);
ly=@(yr)~rem(yr,400)|(rem(yr,100)&~rem(yr,4));

yrs=1950:2023;%1950:2024; % ETref runs till 2023 - updated here for consistency and to avoid errors below
ly_yrs=ly(yrs);

all_yrsdoys=[yrs;ly_yrs]';
all_yrsdoys(ly_yrs,3)=366;ly_mths=[ones(31,1);ones(29,1)*2;ones(31,1)*3;ones(30,1)*4;ones(31,1)*5;ones(30,1)*6;ones(31,1)*7;ones(31,1)*8;ones(30,1)*9;ones(31,1)*10;ones(30,1)*11;ones(31,1)*12];
all_yrsdoys(~ly_yrs,3)=365;nly_mths=[ones(31,1);ones(28,1)*2;ones(31,1)*3;ones(30,1)*4;ones(31,1)*5;ones(30,1)*6;ones(31,1)*7;ones(31,1)*8;ones(30,1)*9;ones(31,1)*10;ones(30,1)*11;ones(31,1)*12];

yrs_doys_mths.DLY=[];yrs_doys_mths.MTHLY=[];yrs_doys_mths.YRLY=[];
for i=1:length(yrs)
    if all_yrsdoys(i,3)==366;mths=ly_mths;else,mths=nly_mths;end
    yr_doys_mths=[ones(all_yrsdoys(i,3),1)*yrs(i) (1:all_yrsdoys(i,3))' mths];
    yrs_doys_mths.DLY=[yrs_doys_mths.DLY;yr_doys_mths];
    yrs_doys_mths.MTHLY=[yrs_doys_mths.MTHLY;[ones(12,1)*yrs(i) (1:12)']];
    yrs_doys_mths.YRLY=[yrs_doys_mths.YRLY;yrs(i)];
end


%% struct with tables to hold all product data [DAILY PRODUCTS]
for i_st=1:length(fields)
    % daily ET
    ETpdct_yrs_doy_mth=table;
    ETpdct_yrs_doy_mth.year=yrs_doys_mths.DLY(:,1);
    ETpdct_yrs_doy_mth.doy=yrs_doys_mths.DLY(:,2);
    ETpdct_yrs_doy_mth.month=yrs_doys_mths.DLY(:,3);
        % column for reference data
        ETpdct_yrs_doy_mth.Reference = ETpdct_yrs_doy_mth.year*nan;
        ETpdct_yrs_doy_mth.Reference_MDS = ETpdct_yrs_doy_mth.year*nan;
        ETpdct_yrs_doy_mth.Reference_CORR = ETpdct_yrs_doy_mth.year*nan;
    
    % monthly ET from daily ET
    ETpdct_yrs_mth=table;
    ETpdct_yrs_mth.year=yrs_doys_mths.MTHLY(:,1);    
    ETpdct_yrs_mth.month=yrs_doys_mths.MTHLY(:,2);
        % column for reference data
        ETpdct_yrs_mth.Reference = ETpdct_yrs_mth.year*nan;
        ETpdct_yrs_mth.Reference_MDS = ETpdct_yrs_mth.year*nan;
        ETpdct_yrs_mth.Reference_CORR = ETpdct_yrs_mth.year*nan;
    
    % yearly ET from daily ET
    ETpdct_yrs=table;
    ETpdct_yrs.year=yrs_doys_mths.YRLY(:,1);    
        % column for reference data
        ETpdct_yrs.Reference = ETpdct_yrs.year*nan;
        ETpdct_yrs.Reference_MDS = ETpdct_yrs.year*nan;
        ETpdct_yrs.Reference_CORR = ETpdct_yrs.year*nan;
        
    for i=1:length(et_fields)
        if ~contains(et_fields{i},'_DLY'),continue;end
        % for daily ET
        ETpdct_yrs_doy_mth.(et_fields{i})=nan(length(yrs_doys_mths.DLY(:,1)),1);
        % for monthly ET aggregation
        ETpdct_yrs_mth.(et_fields{i})=nan(length(yrs_doys_mths.MTHLY(:,1)),1);
        % for yearly ET aggregation
        ETpdct_yrs.(et_fields{i})=nan(length(yrs_doys_mths.YRLY(:,1)),1);
    end
    ETpdct.(fields{i_st}).DLY=ETpdct_yrs_doy_mth;
    ETpdct.(fields{i_st}).MTHLY=ETpdct_yrs_mth;
    ETpdct.(fields{i_st}).YRLY=ETpdct_yrs;
end

% add ET data [mm/d] | [mm/mth] | [mm/yr]
% i_miss=1;pdct_miss={};
for i_st=1:length(fields)
    
    %%% Reference data - update ET struct>>table with the Reference data
    try
        %%% daily ET
        ETref_st = ETref.(fields{i_st}).ET.ET;
        ETrefmds_st = ETref.(fields{i_st}).ET.ET_MDS;
        ETrefcorr_st = ETref.(fields{i_st}).ET.ET_CORR;
%         eval(['ETpdct.' fields{i_st} '.DLY.Reference=ETref.' fields{i_st} '.ET.ET;']);
        ETpdct.(fields{i_st}).DLY.Reference=ETref_st;
        ETpdct.(fields{i_st}).DLY.Reference_MDS=ETrefmds_st;
        ETpdct.(fields{i_st}).DLY.Reference_CORR=ETrefcorr_st;
        %%% aggregate to monthly and yearly
        yrs_ref_uniq = unique(ETref.(fields{i_st}).ET.year); % should be equivalent to yrs i.e., 1950-2023
        for i_yr=1:length(yrs_ref_uniq)
            yrs_ref_ind=ismember(ETref.(fields{i_st}).ET.year,yrs_ref_uniq(i_yr));
            % monthly ET [mm/mth]
            for i_mth=1:12
                mth_ref_ind=ismember(ETref.(fields{i_st}).ET.month,i_mth);
                ETref_st_mth = nansum(ETref_st(yrs_ref_ind & mth_ref_ind));ETref_st_mth(ETref_st_mth<=0)=nan;
                ETrefmds_st_mth = nansum(ETrefmds_st(yrs_ref_ind & mth_ref_ind));ETrefmds_st_mth(ETrefmds_st_mth<=0)=nan;
                ETrefcorr_st_mth = nansum(ETrefcorr_st(yrs_ref_ind & mth_ref_ind));ETrefcorr_st_mth(ETrefcorr_st_mth<=0)=nan;
                eval(['ETpdct.' fields{i_st} '.MTHLY.Reference(' num2str((i_yr-1)*12+i_mth) ')=ETref_st_mth;']);
                eval(['ETpdct.' fields{i_st} '.MTHLY.Reference_MDS(' num2str((i_yr-1)*12+i_mth) ')=ETrefmds_st_mth;']);
                eval(['ETpdct.' fields{i_st} '.MTHLY.Reference_CORR(' num2str((i_yr-1)*12+i_mth) ')=ETrefcorr_st_mth;']);
            end
            % annual ET [mm/yr]
            ETref_st_yr = nansum(ETref_st(yrs_ref_ind));ETref_st_yr(ETref_st_yr<=0)=nan;
            ETrefmds_st_yr = nansum(ETrefmds_st(yrs_ref_ind));ETrefmds_st_yr(ETrefmds_st_yr<=0)=nan;
            ETrefcorr_st_yr = nansum(ETrefcorr_st(yrs_ref_ind));ETrefcorr_st_yr(ETrefcorr_st_yr<=0)=nan;
            eval(['ETpdct.' fields{i_st} '.YRLY.Reference(' num2str(i_yr) ')=ETref_st_yr;']);
            eval(['ETpdct.' fields{i_st} '.YRLY.Reference_MDS(' num2str(i_yr) ')=ETrefmds_st_yr;']);
            eval(['ETpdct.' fields{i_st} '.YRLY.Reference_CORR(' num2str(i_yr) ')=ETrefcorr_st_yr;']);
        end
    catch
    end
    
    %%% Product data - update ET struct>>table with global product[s] data
    for i=1:length(et_fields)
        if ~contains(et_fields{i},'_DLY'),continue;end
%         yr_=[];
        % yrs with data
        yrs_pdct = ET_ALL.(fields{i_st}).(et_fields{i}).year;
%             yrs_pdct_uniq = unique(yrs_pdct);
        yrs_ind = ismember(yrs,unique(yrs_pdct));
            yrs_pdct_uniq = all_yrsdoys(yrs_ind,1);
            doys_pdct = all_yrsdoys(yrs_ind,3);

        %% construct ET array
        % initial years without data - assigned nans
        init1 = find(yrs_ind==1,1,'first');
        init0s = nan(sum(all_yrsdoys(1:init1-1,3)),1); % daily
            try
                init0s_mth = nan(12*(init1-1),1); % monthly
            catch
                init0s_mth = [];
            end
        % last years without data - assigned nans
        last1 = find(yrs_ind==1,1,'last');
        last0s = nan(sum(all_yrsdoys((last1+1):end,3)),1); % daily
            try
                last0s_mth = nan(12*length(yrs(last1+1):yrs(end)),1); % monthly
            catch
                last0s_mth = [];
            end

        et = init0s;
        et_mth = init0s_mth;
        et_yr =nan(init1-1,1);
        for i_yr=1:length(yrs_pdct_uniq)
            yrs_pdct_ind = ismember(yrs_pdct,yrs_pdct_uniq(i_yr));
            if sum(yrs_pdct_ind)==doys_pdct(i_yr)
                et_=ET_ALL.(fields{i_st}).(et_fields{i}).ET(yrs_pdct_ind);
            else
%                 keyboard
%                 yr_=[yr_;yrs_pdct_uniq(i_yr)];
%                 pdct_miss{i_miss,1}=et_fields{i};pdct_miss{i_miss,2}=yr_;i_miss=i_miss+1;
                
                time=ET_ALL.(fields{i_st}).(et_fields{i}).time;
                if contains(et_fields{i},'GLDAS') || contains(et_fields{i},'MERRA') % MERRA condition NOT required here as it falls under >>>if sum(yrs_pdct_ind)==doys_pdct(i_yr)<<< condition above : will leave it here anyway !
                    % remember to change code below if var time is loaded from the .nc products instead - currently day and month read from the filename !
                    if contains(et_fields{i},'NOAH'),time=time-yrs_pdct*10000;end%noah time var includes year
                    time_mths=floor(time/100);
                    time_days = time - time_mths*100;
                    time = day(datetime(yrs_pdct,time_mths,time_days,'Format','dd-MMM-yyyy HH:mm:ss'),'dayofyear');
                elseif contains(et_fields{i},'ETMonitor')
                    time=time-yrs_pdct*1000; % etmonitor time is 'yyyydoy' not mmdd like above
                end

                if ly(yrs_pdct_uniq(i_yr)),time_ind=ismember(1:366,round(time(yrs_pdct_ind)));et_=nan(366,1);else,time_ind=ismember(1:365,round(time(yrs_pdct_ind)));et_=nan(365,1);end                   
                et_(time_ind)=ET_ALL.(fields{i_st}).(et_fields{i}).ET(yrs_pdct_ind);
                
            end
            
                    % interpolate for missing nans ?
                    if any(isnan(et_)) && ~all(isnan(et_))
                        x=find(~isnan(et_));xii=find(isnan(et_));
                        y=et_(x);
                        yi1_int = interp1(x,y,xii,'linear');
                        et_(xii) = yi1_int;
                    end
                    
            et = [et;et_];%#ok
            % aggregate to monthly
            if ly(yrs_pdct_uniq(i_yr)),mths=ly_mths;else,mths=nly_mths;end
            for i_mth=1:12
                if length(et_)==doys_pdct(i_yr)%sum(yrs_pdct_ind)==doys_pdct(i_yr)
                    mth_ind=ismember(mths,i_mth);
%                     mth_pdct_ind=yrs_pdct_ind;
%                     mth_pdct_ind(yrs_pdct_ind)=mth_ind;
%                     et_mth = [et_mth;nansum(ET_ALL.(fields{i_st}).(et_fields{i}).ET(mth_pdct_ind))]; %#ok
                    et_mth_ = nansum(et_(mth_ind));
                    et_mth = [et_mth;et_mth_];%#ok
                end
            end
            % aggregate to yearly
            et_yr = [et_yr;nansum(ET_ALL.(fields{i_st}).(et_fields{i}).ET(yrs_pdct_ind))]; %#ok
        end
        
        try %% could fail if length(yrs(last1+1) !< yrs(end)
            et_yr = [et_yr;nan(length(yrs(last1+1):yrs(end)),1)]; %#ok
        catch
            et_yr = [et_yr;[]]; %#ok
        end        
        et_mth = [et_mth;last0s_mth]; %#ok
        et = [et;last0s]; if length(et)~=27028,continue;end %#ok
        
        % update ET struct>>table with data
        ETpdct.(fields{i_st}).DLY.(et_fields{i})=et;
        ETpdct.(fields{i_st}).MTHLY.(et_fields{i})=et_mth;
        ETpdct.(fields{i_st}).YRLY.(et_fields{i})=et_yr;
    end    
end


%% struct with tables to hold all product data [MONTHLY PRODUCTS]
for i_st=1:length(fields)
    
    % monthly ET - continue using ETpdct_yrs_mth table created above [i.e. aggregated from daily ET products]    
    for i=1:length(et_fields)
        if ~contains(et_fields{i},'_MTHLY'),continue;end        
        eval(['ETpdct.' fields{i_st} '.MTHLY.' et_fields{i} '=nan(length(yrs_doys_mths.MTHLY(:,1)),1);']);
    end    
end

% add ET data [mm/mth] | [mm/yr]
for i_st=1:length(fields)
    for i=1:length(et_fields)
        if ~contains(et_fields{i},'_MTHLY'),continue;end        
        % yrs with data
        yrs_pdct = ET_ALL.(fields{i_st}).(et_fields{i}).year;
%             yrs_pdct_uniq = unique(yrs_pdct);
        yrs_ind = ismember(yrs,unique(yrs_pdct));
            yrs_pdct_uniq = all_yrsdoys(yrs_ind,1);
            doys_pdct = all_yrsdoys(yrs_ind,3);

        %% construct ET array
        % initial years without data - assigned nans
        init1 = find(yrs_ind==1,1,'first');        
            try
                init0s_mth = nan(12*(init1-1),1); % monthly
            catch
                init0s_mth = [];
            end
        % last years without data - assigned nans
        last1 = find(yrs_ind==1,1,'last');        
            try
                last0s_mth = nan(12*length(yrs(last1+1):yrs(end)),1); % monthly
            catch
                last0s_mth = [];
            end
        
        et_mth = init0s_mth;
        et_yr =nan(init1-1,1);
        for i_yr=1:length(yrs_pdct_uniq)
            yrs_pdct_ind = ismember(yrs_pdct,yrs_pdct_uniq(i_yr));
            
            % monthly ET            
            for i_mth=1:12                
                mth_ind=ismember(1:12,i_mth);
                mth_pdct_ind=yrs_pdct_ind;
                mth_pdct_ind(yrs_pdct_ind)=mth_ind;
                et_mth = [et_mth;ET_ALL.(fields{i_st}).(et_fields{i}).ET(mth_pdct_ind)]; %#ok                
            end
            % aggregate to yearly
            et_yr = [et_yr;nansum(ET_ALL.(fields{i_st}).(et_fields{i}).ET(yrs_pdct_ind))]; %#ok
        end
        try
            et_yr = [et_yr;nan(length(yrs(last1+1):yrs(end)),1)]; %#ok
        catch
            et_yr = [et_yr;[]]; %#ok
        end
        et_mth = [et_mth;last0s_mth]; %#ok        
        
        % update ET struct>>table with data        
        ETpdct.(fields{i_st}).MTHLY.(et_fields{i})=et_mth;
        ETpdct.(fields{i_st}).YRLY.(et_fields{i})=et_yr;
    end    
end


%% struct with tables to hold all product data [ANNUAL PRODUCTS]
for i_st=1:length(fields)
    
    % monthly ET - continue using ETpdct_yrs table created above [i.e. aggregated from daily ET products]    
    for i=1:length(et_fields)
        if ~contains(et_fields{i},'_YR'),continue;end        
        eval(['ETpdct.' fields{i_st} '.YRLY.' et_fields{i} '=nan(length(yrs_doys_mths.YRLY(:,1)),1);']);
    end    
end

% add ET data [mm/yr]
for i_st=1:length(fields)
    for i=1:length(et_fields)
        if ~contains(et_fields{i},'_YR'),continue;end        
        % yrs with data
        yrs_pdct = ET_ALL.(fields{i_st}).(et_fields{i}).year;
%             yrs_pdct_uniq = unique(yrs_pdct);
        yrs_ind = ismember(yrs,unique(yrs_pdct));
            yrs_pdct_uniq = all_yrsdoys(yrs_ind,1);
            doys_pdct = all_yrsdoys(yrs_ind,3);

        %% construct ET array
        % initial years without data - assigned nans
        init1 = find(yrs_ind==1,1,'first'); 
        % last years without data - assigned nans
        last1 = find(yrs_ind==1,1,'last');           
                
        et_yr =nan(init1-1,1);
        for i_yr=1:length(yrs_pdct_uniq)
            yrs_pdct_ind = ismember(yrs_pdct,yrs_pdct_uniq(i_yr));            
            et_yr = [et_yr;nansum(ET_ALL.(fields{i_st}).(et_fields{i}).ET(yrs_pdct_ind))]; %#ok
        end
        et_yr = [et_yr;nan(length(yrs(last1+1):yrs(end)),1)]; %#ok
                
        % update ET struct>>table with data        
        ETpdct.(fields{i_st}).YRLY.(et_fields{i})=et_yr;
    end    
end
% save F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat ETpdct
save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat ETpdct

%% ################################################################################## %%
%%                                                                                    %%
%% EVASPA ESTIMATES - interpolation for missing data using daily radiation            %%
%%                                                                                    %%
%% ################################################################################## %%

clear
clc

interpolate_ET = true;

try
    load F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat
    basepath_EVASPA = 'F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\EVASPA_database\';
catch
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat
    basepath_EVASPA = '\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\EVASPA_database\';
    % basepath_EVASPA = 'E:\smwangi\Evaluation_Benchmarking\EVASPA_database\';
end

fields = fieldnames(ETpdct);

EVASPA_DBdirs = {'Database_SouthEast_FR_h18v04','Database_SouthWest_FR_h17n18v04'};
lst_est_dirs = {'AQUA11','AQUA21','TERRA11','TERRA21','VIIRS21'};
    
    %%% read .mat filenames and struct fieldnames
    ET_fls = what([basepath_EVASPA EVASPA_DBdirs{1} '\result\' lst_est_dirs{1} '_LST\ET_pts\']); % OK : naming shld be the same for all lst_est_dirs but changes with EVASPA_DBdirs
    Rad_fls = what([basepath_EVASPA EVASPA_DBdirs{1} '\result\' lst_est_dirs{1} '_LST\rs_daily\']);  % OK : naming shld be the same for all lst_est_dirs but changes with EVASPA_DBdirs
    
        load([basepath_EVASPA EVASPA_DBdirs{1} '\result\' lst_est_dirs{1} '_LST\ET_pts\' ET_fls.mat{1}]);    
        % this changes with EVASPA_DBdirs, i.e. in-situ sites per AOI
            fields1 = fieldnames(ETEC_pt); 
        % these do not
            fields2 = fieldnames(ETEC_pt.(char(fields1(1)))); % state variable [ET here] & latlon
            fields3 = fieldnames(ETEC_pt.(char(fields1(1))).(char(fields2(3)))); % radiation
            fields4 = fieldnames(ETEC_pt.(char(fields1(1))).(char(fields2(3))).(char(fields3(1)))); % EF method
            fields5 = fieldnames(ETEC_pt.(char(fields1(1))).(char(fields2(3))).(char(fields3(1))).(char(fields4(1)))); % G method

%%% compile arrays>>structs with ref, product and EVASPA ET data    
for i_DBdirs=1:length(EVASPA_DBdirs)
    
    ET_fls = what([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{1} '_LST\ET_pts\']); % OK : naming shld be the same for all lst_est_dirs    
    %%% load point EVASPA data for field1 -- sites per EVASPAdatabase do change
    load([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{1} '_LST\ET_pts\' ET_fls.mat{1}])
    fields1 = fieldnames(ETEC_pt);

    %%
    for i_lst=1:length(lst_est_dirs) % aqua/terra 11/21 | viirs21

        ET_fls = what([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{i_lst} '_LST\ET_pts\']); % OK : naming shld be the same for all lst_est_dirs : VIIRS starts from 2012 though !
        Rad_fls = what([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{i_lst} '_LST\rs_daily\']);  % OK : naming shld be the same for all lst_est_dirs but changes with EVASPA_DBdirs     

        for i_yr=1:length(ET_fls.mat)-1%-1 to run till 2023 --- update to include 2024 % 2004-2021 | 2012-2021 for viirs         

            %%%
            yr = ET_fls.mat{i_yr}(end-7:end-4);
            
            load([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{i_lst} '_LST\ET_pts\' ET_fls.mat{i_yr}])
            load([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{i_lst} '_LST\rs_daily\' Rad_fls.mat{i_yr}])
    
            tmlgth=length(ETEC_pt.(char(fields1(1))).(char(fields2(3))).(char(fields3(1))).(char(fields4(1))).(char(fields5(1))));
        
            rs_img_era5=[];
            rs_img_msg=[];
            rs_img_merra=[];
            for i=1:tmlgth%length(rs_mean_img)
                rs_img_era5=cat(3,rs_img_era5,rs_mean_img{i}(:,:,1));
                rs_img_msg=cat(3,rs_img_msg,rs_mean_img{i}(:,:,2));
                rs_img_merra=cat(3,rs_img_merra,rs_mean_img{i}(:,:,3));
            end
            %%%
            
            %%    
           for i1=1:length(fields1)-1
                
                %%% Reference & Product data
                        %%% daily ET
                    st_ind = contains(fields,fields1{i1}(1:5)); % Bilos is the shortest st nm
                    %% to update - by rerunning evaspa_pt_extraction.m - done 081024
                    if fields1{i1}=="Crau2",st_ind = contains(fields,"CrauC");end

%                     if any(st_ind),continue;end
%                     ETref_st = ETpdct.(fields{st_ind}).DLY;
                if i_yr==1
                %%% evaspa mean & median
                    ETpdct.(fields{st_ind}).DLY.(['EVASPA_Mean_' lst_est_dirs{i_lst}]) = ETpdct.(fields{st_ind}).DLY.year*nan;
                    ETpdct.(fields{st_ind}).DLY.(['EVASPA_Median_' lst_est_dirs{i_lst}]) = ETpdct.(fields{st_ind}).DLY.year*nan;

                %%% EVASPA ET - initialize structs
                
                    %%arrays/structs to hold all data
                    ET_array_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];
                    ET_array_albedo_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];ET_array_ndvi_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];
                    ET_array_era5_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];ET_array_msg_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];ET_array_merra_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];
                    % ET_array_Rad_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];
                    % ET_array_EF_G_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];%ET_array_EF_G.G=[];
                    % ET_array_Rad_EF_G_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];
                end
                            
                %%%
                if tmlgth==366
                    DoYs.leapyeardates(:,3)=str2num(yr);
%                     x_dates=datenum(DoYs.leapyeardates(:,3),DoYs.leapyeardates(:,5),DoYs.leapyeardates(:,4));
                elseif tmlgth==365
                    DoYs.nonleapyeardates(:,3)=str2num(yr);
%                     x_dates=datenum(DoYs.nonleapyeardates(:,3),DoYs.nonleapyeardates(:,5),DoYs.nonleapyeardates(:,4));
                end   
                           
                ET_array=[];
                ET_array_albedo=[];ET_array_ndvi=[];
                ET_array_era5=[];ET_array_msg=[];ET_array_merra=[];
                ET_array_Rad=[];
                ET_array_EF_G=[];%ET_array_EF_G.G=[];
                % ET_array_Rad_EF_G=[];
                for i2=length(fields2)
                    for i3=1:length(fields3)
                        %%% rs for ET interpolation
                        if i3==1
                            rs_img_site=squeeze(rs_img_era5(ETEC_pt.(fields1{i1}).lat_ind,ETEC_pt.(fields1{i1}).lon_ind,:));
                        elseif i3==2
                            rs_img_site=squeeze(rs_img_msg(ETEC_pt.(fields1{i1}).lat_ind,ETEC_pt.(fields1{i1}).lon_ind,:));
                        elseif i3==3
                            rs_img_site=squeeze(rs_img_merra(ETEC_pt.(fields1{i1}).lat_ind,ETEC_pt.(fields1{i1}).lon_ind,:));
                        end
    
                        if class(rs_img_site)=="int16",rs_img_site=double(rs_img_site);rs_img_site(rs_img_site==-999)=nan;end
    
                        for i4=1:length(fields4)                    
                            for i5=1:length(fields5)
                                                 
                                ET_ens = ETEC_pt.(fields1{i1}).(fields2{i2}).(fields3{i3}).(fields4{i4}).(fields5{i5});
                                
                                if class(ET_ens)=="int16",ET_ens=double(ET_ens);ET_ens(ET_ens==-999)=nan;ET_ens=ET_ens*0.01;ET_ens(ET_ens>20)=nan;end
                                
                                if interpolate_ET                                    
                                    %%interpolation
                                    yii = ET_ens./rs_img_site;
                                    xii = find(isnan(yii));
                                    x = find(~isnan(yii));%if isempty(x),continue;end
                                    if isempty(x)
                                        ET_ens=yii*nan;
                                    else
                                        y = yii(x);
                                        yi1_int = interp1(x,y,xii,'linear');
                                        yii(xii) = yi1_int;
                                        ET_ens = yii.*rs_img_site;
                                        ET_ens(ET_ens<0)=nan;yii(isnan(ET_ens))=nan;
                                                %%% let's try to fill the/any new nans again !
                                                if ~isempty(isnan(yii)) && isempty(isnan(rs_img_site))
                                                    xii = find(isnan(yii));
                                                    x = find(~isnan(yii));
                                                    y = yii(x);
                                                    yi1_int = interp1(x,y,xii,'linear');
                                                    yii(xii) = yi1_int;
                                                    ET_ens = yii.*rs_img_site;
                                                    ET_ens(ET_ens<0)=nan;
                                                end
                                    end
                                else
                                    ET_ens(ET_ens<0)=nan;
                                end
        
        %                         if contains(char(fields4(i4)),'Ndvi'),clr='.g';else,clr='.g';end
        
                                ET_array=[ET_array;ET_ens']; %#ok
                                if contains(char(fields4(i4)),'Ndvi'),ET_array_ndvi=[ET_array_ndvi;ET_ens'];else,ET_array_albedo=[ET_array_albedo;ET_ens'];end%#ok
                                if contains(char(fields3(i3)),'ERA5'),ET_array_era5=[ET_array_era5;ET_ens'];elseif contains(char(fields3(i3)),'MSG'),ET_array_msg=[ET_array_msg;ET_ens'];elseif contains(char(fields3(i3)),'MERRA'),ET_array_merra=[ET_array_merra;ET_ens'];end%#ok
                                    
                                    %%% Rad-specific array
                                    
        %                             if i4==1 && i5==1,ET_array_Rad.(['Rad' num2str(i3)])=[];end
        %                             ET_array_Rad.(['Rad' num2str(i3)])=[ET_array_Rad.(['Rad' num2str(i3)]);ET_ens'];
                                    fldnm=fields3{i3};fldnm=strrep(fldnm,'_netRad','');
                                    if i4==1 && i5==1,ET_array_Rad.([fldnm])=[];end%#ok
                                    ET_array_Rad.([fldnm])=[ET_array_Rad.([fldnm]);ET_ens'];%#ok
                                
                                    %%% EF-specific array
    %                                 if i3==1 && i5==1,ET_array_EF_G.(['EFa' num2str(i4)])=[];ET_array_EF_G.(['EFn' num2str(i4)])=[];end
                                    if contains(char(fields4(i4)),'Ndvi')
                                        if i3==1 && i5==1,ET_array_EF_G.(['EFn' num2str(i4)])=[];end
                                        ET_array_EF_G.(['EFn' num2str(i4)])=[ET_array_EF_G.(['EFn' num2str(i4)]);ET_ens'];
                                    else
                                        if i3==1 && i5==1,ET_array_EF_G.(['EFa' num2str(i4)])=[];end
                                        ET_array_EF_G.(['EFa' num2str(i4)])=[ET_array_EF_G.(['EFa' num2str(i4)]);ET_ens'];
                                    end
                                    
                                    %%% G-specific array
                                    if i3==1 && i4==1,ET_array_EF_G.(['G' num2str(i5)])=[];end
                                    ET_array_EF_G.(['G' num2str(i5)])=[ET_array_EF_G.(['G' num2str(i5)]);ET_ens'];
                            end
                        end
                    end
                end
        
                stats=[];
                stats(1,:)=nanmean(ET_array);
                stats(2,:)=nanmedian(ET_array);
                stats(3,:)=nanstd(ET_array);
                stats(4,:)=-nanstd(ET_array);
                stats(5,:)=nanmax(ET_array);
                stats(6,:)=nanmin(ET_array);
                
                stats(7,:)=nanmean(ET_array_ndvi);
                stats(8,:)=nanmean(ET_array_albedo);
                
                stats(9,:)=nanmean(ET_array_era5);
                stats(10,:)=nanmean(ET_array_msg);
                stats(11,:)=nanmean(ET_array_merra);

                %%compile all annual ensembles PER SITE
                ET_array_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array'];
                ET_array_albedo_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_albedo_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_albedo'];
                ET_array_ndvi_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_ndvi_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_ndvi'];
                ET_array_era5_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_era5_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_era5'];
                ET_array_msg_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_msg_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_msg'];
                ET_array_merra_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_merra_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_merra'];
                % ET_array_Rad_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_Rad_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_Rad'];
                % ET_array_EF_G_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[ET_array_EF_G_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1});ET_array_EF_G'];%ET_array_EF_G.G=[];
                % ET_array_Rad_EF_G_ALLYRS.(lst_est_dirs{i_lst}).(fields1{i1})=[];
                
                ETpdct.(fields{st_ind}).DLY.(['EVASPA_Mean_' lst_est_dirs{i_lst}])(ETpdct.(fields{st_ind}).DLY.year==str2num(yr))=stats(1,:);           
                ETpdct.(fields{st_ind}).DLY.(['EVASPA_Median_' lst_est_dirs{i_lst}])(ETpdct.(fields{st_ind}).DLY.year==str2num(yr))=stats(2,:);clear st_ind
           end % st
%            keyboard
        end % yrs
%         keyboard
    end % lst
%     keyboard
%    ET_ref_pdct_evaspa.(EVASPA_DBdirs{i_DBdirs})=ETpdct;    
end % evaspa DB

if interpolate_ET
    ET_ref_pdct_evaspa=ETpdct;
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa.mat ET_ref_pdct_evaspa
    save F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa.mat ET_ref_pdct_evaspa
else
    ET_ref_pdct_evaspa_woInterpolation=ETpdct;
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa_woInterpolation.mat ET_ref_pdct_evaspa_woInterpolation
    save F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa_woInterpolation.mat ET_ref_pdct_evaspa_woInterpolation
end

%% ################################################################################## %%
%%                                                                                    %%
%% COMPILE/EXTRACT [ALL] OTHER VATIABLES PER SITE - INPUTS[double]/OUTPUTS[int16]     %%
%%                                                                                    %%
%% ################################################################################## %%


%% All Variables - without interpolation
clear

if exist('F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\')
    basepath_EVASPA = 'F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\EVASPA_database\';
else
    basepath_EVASPA = '\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\EVASPA_database\';
    basepath_EVASPA = 'E:\smwangi\Evaluation_Benchmarking\EVASPA_database\';
end


EVASPA_DBdirs = {'Database_SouthEast_FR_h18v04','Database_SouthWest_FR_h17n18v04'};

yrs = {'2004','2005','2006','2007','2008','2009',...
    '2010','2011','2012','2013','2014','2015','2016','2017','2018','2019',...
    '2020','2021','2022','2023','2024'};

%%% inputs
in_vars = {{'Albedo_pt_','EMM_pt_','LAI_pt_','LST_pt_','TIME_pt_','VZA_pt_','NDVI_pt_','EVI_pt_','Ra_pt_','Rs_dayave_pt_','Rs_pt_','RH_pt_','TA_pt_'}... % matfile/struct name [prefix]
    ,{'Albedo_pts\','EMM_pts\','LAI_pts\','LST_pts\','TIME_pts\','VZA_pts\','NDVI_pts\','EVI_pts\','Ra_pts\','Rs_dayave_pts\','Rs_pts\','MET_pts\RH\','MET_pts\TA\'},...% directory
    {'Albedo_pt','EMM_pt','LAI_pt','LST_pt','TIME_pt','VZA_pt','NDVI_pt','EVI_pt','Ra_pt','Rs_dayave_pt','Rs_pt','RH_pt','TA_pt'}};         % var name [in struct]

%%% outputs
out_vars = {{'ETd_pt_','G_pt_','LE_pt_','Rn_pt_'}... % matfile/struct name [prefix]
    ,{'ET_pts\','G_pts\','LE_pts\','Rn_pts\'},...% directory
    {'ETEC_pt','G_pt','LE_pt','Rn_pt'}};         % var name [in struct]

lst_est_dirs = {'AQUA11','AQUA21','TERRA11','TERRA21','VIIRS21'};

inout = {'INPUTS','OUTPUTS'};

for i_DBdirs = 1:length(EVASPA_DBdirs) %% AOI
    for i_io=2%1:length(inout) %% INPUTS, OUTPUTS
        if i_io==1
        %% INPUTS
            for i_var=1:length(in_vars{1}) %% STATE VARIABLE
                for i_yr=1:length(yrs) %% YEAR
                    yr = char(yrs(i_yr));
                    %%% load file
                    load([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\INPUTS_POINT\' in_vars{2}{i_var} in_vars{1}{i_var} strrep(EVASPA_DBdirs{i_DBdirs},'Database_','') '_' yr '.mat'])
                    fields1 = fieldnames(eval(in_vars{3}{i_var}));
                    %% save inputs into one struct
                    for i1=1:length(fields1) % SITES
                        if ~contains(in_vars{3}{i_var},'LST') && ~contains(in_vars{3}{i_var},'EMM') && ~contains(in_vars{3}{i_var},'TIME') && ~contains(in_vars{3}{i_var},'VZA') && ~contains(in_vars{3}{i_var},'Ra_pt') && ~contains(in_vars{3}{i_var},'Rs_pt') && ~contains(in_vars{3}{i_var},'RH_pt') && ~contains(in_vars{3}{i_var},'TA_pt') %% all other inputs except lst/emissivity and instantaneous radiations
                            VARS_ALL_LSTs.(inout{i_io}).(in_vars{3}{i_var}).(fields1{i1}).(['YR_' yr])...
                                = eval([in_vars{3}{i_var} '.' (fields1{i1})]);
                        else
                            for i_lst=1:length(lst_est_dirs) %% LSTs
                                try
                                    VARS_ALL_LSTs.(inout{i_io}).(in_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst})...
                                        = eval([in_vars{3}{i_var} '.' (fields1{i1}) '.' (lst_est_dirs{i_lst})]);
                                catch
                                    continue; % viirs starts from 2012
                                end
                            end %% LSTs
                        end
                    end % SITES
                end %% YEAR
            end %% STATE VARIABLE
    %                 keyboard
        elseif i_io==2
        %% STATE VARIABLES / OUTPUT - EVASPA : INT16
            for i_var=1:length(out_vars{1}) %% STATE VARIABLE
                for i_yr=1:length(yrs) %% YEAR
                    yr = char(yrs(i_yr));            
                    for i_lst=1:length(lst_est_dirs) %% LSTs  

                        %%% load file
                        try
                            load([basepath_EVASPA EVASPA_DBdirs{i_DBdirs} '\result\' lst_est_dirs{i_lst} '_LST\' out_vars{2}{i_var} out_vars{1}{i_var} strrep(EVASPA_DBdirs{i_DBdirs},'Database_','') '_' yr '.mat'])
                        catch
                            continue; % viirs starts from 2012
                        end

                        % keyboard

                        fields1 = fieldnames(eval(out_vars{3}{i_var}));
                        fields2 = fieldnames(eval([out_vars{3}{i_var} '.' fields1{1}]));
                        fields3 = fieldnames(eval([out_vars{3}{i_var} '.' fields1{1} '.' fields2{3}]));
                        fields4 = fieldnames(eval([out_vars{3}{i_var} '.' fields1{1} '.' fields2{3} '.' fields3{1}]));
                        fields5 = fieldnames(eval([out_vars{3}{i_var} '.' fields1{1} '.' fields2{3} '.' fields3{1} '.' fields4{1}]));

                        % tmlgth=length(eval([vars{3}{i_var} '.' fields1{1} '.' fields2{3} '.' fields3{1} '.' fields4{1} '.' fields5{1}]));

                        for i1=1:length(fields1)-1 % SITES : last field is bool

                            if i_lst==1
                                VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).AquaTerra_1121.VAR_array = [];
                            end

                            VAR_array=[];
                            VAR_array_albedo=[];VAR_array_ndvi=[];
                            VAR_array_era5=[];VAR_array_msg=[];VAR_array_merra=[];
                            VAR_array_Rad=[];
                            VAR_array_EF_G=[];%ET_array_EF_G.G=[];
                            VAR_array_Rad_EF_G=[];
                            for i2=length(fields2) %% STATE VARIABLE IN STRUCT : last field contains the VAR
                                for i3=1:length(fields3) %% RAD
                                    for i4=1:length(fields4) %% EF                   
                                        for i5=1:length(fields5) %% G

                                            VAR_ens = eval([out_vars{3}{i_var} '.' fields1{i1} '.' fields2{i2} '.' fields3{i3} '.' fields4{i4} '.' fields5{i5}]);

                                            % LEAVE AS INT16 : DOUBLE TOO BIG !
                                            % if class(VAR_ens)=="int16",VAR_ens=double(VAR_ens);VAR_ens(VAR_ens==-999)=nan;if contains(fields2{i2},'ETd'),VAR_ens=VAR_ens*0.01;end;end

                                            % EV_plt0=plot(x_dates,ET_ens,'g','LineWidth',2);
                                            VAR_array=[VAR_array;VAR_ens']; %#ok
                                            if contains(char(fields4(i4)),'Ndvi'),VAR_array_ndvi=[VAR_array_ndvi;VAR_ens'];else,VAR_array_albedo=[VAR_array_albedo;VAR_ens'];end%#ok
                                            if contains(char(fields3(i3)),'ERA5'),VAR_array_era5=[VAR_array_era5;VAR_ens'];elseif contains(char(fields3(i3)),'MSG'),VAR_array_msg=[VAR_array_msg;VAR_ens'];elseif contains(char(fields3(i3)),'MERRA'),VAR_array_merra=[VAR_array_merra;VAR_ens'];end%#ok

                                                %%% Rad-specific array

                    %                             if i4==1 && i5==1,ET_array_Rad.(['Rad' num2str(i3)])=[];end
                    %                             ET_array_Rad.(['Rad' num2str(i3)])=[ET_array_Rad.(['Rad' num2str(i3)]);ET_ens'];
                                                fldnm=char(fields3(i3));fldnm=strrep(fldnm,'_netRad','');
                                                if i4==1 && i5==1,VAR_array_Rad.([fldnm])=[];end%#ok
                                                VAR_array_Rad.([fldnm])=[VAR_array_Rad.([fldnm]);VAR_ens'];%#ok

                                                %%% EF-specific array
                    %                                 if i3==1 && i5==1,ET_array_EF_G.(['EFa' num2str(i4)])=[];ET_array_EF_G.(['EFn' num2str(i4)])=[];end
                                                if contains(char(fields4(i4)),'Ndvi')
                                                    if i3==1 && i5==1,VAR_array_EF_G.(['EFn' num2str(i4)])=[];end
                                                    VAR_array_EF_G.(['EFn' num2str(i4)])=[VAR_array_EF_G.(['EFn' num2str(i4)]);VAR_ens'];
                                                else
                                                    if i3==1 && i5==1,VAR_array_EF_G.(['EFa' num2str(i4)])=[];end
                                                    VAR_array_EF_G.(['EFa' num2str(i4)])=[VAR_array_EF_G.(['EFa' num2str(i4)]);VAR_ens'];
                                                end

                                                %%% G-specific array
                                                if i3==1 && i4==1,VAR_array_EF_G.(['G' num2str(i5)])=[];end
                                                VAR_array_EF_G.(['G' num2str(i5)])=[VAR_array_EF_G.(['G' num2str(i5)]);VAR_ens'];
                                        end %% G
                                    end %% EF
                                end %% Rad
                            end %% state variable in struct : last field

                            %% save into one struct
                            VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst}).VAR_array = VAR_array;
                            
                            if contains(out_vars{1}(i_var),'ETd') || contains(out_vars{1}(i_var),'LE')
                                VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst}).VAR_array_Rad = VAR_array_Rad;
                                VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst}).VAR_array_EF_G = VAR_array_EF_G;
                            end
                            %                     VAR_ALL_LSTs.(vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst}).VAR_array = VAR_array;
                                %%% combine LSTs
                                try
                                    VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).AquaTerra_1121.VAR_array=...
                                        [VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).AquaTerra_1121.VAR_array;...
                                        VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst}).VAR_array];
                                catch % viirs 2024 seems to have some prob - 365 instead of 366 : TO ADDRESS !
                                    VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).AquaTerra_1121.VAR_array=...
                                        [VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).AquaTerra_1121.VAR_array;...
                                        [VARS_ALL_LSTs.(inout{i_io}).(out_vars{3}{i_var}).(fields1{i1}).(['YR_' yr]).(lst_est_dirs{i_lst}).VAR_array int16(zeros(length(fields3)*length(fields4)*length(fields5),1)-999)]];
                                end
                        end %% sites
                    end %% LSTs
                end %% year
            end %% state variable / output    
        end %% IF STMT - INOUT/OUTPUT
    end %% AOI
end

save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\VARS_ALL_LSTs VARS_ALL_LSTs -v7.3

    %%
    field_nms = fieldnames(VARS_ALL_LSTs.OUTPUTS.ETEC_pt);
    field_nms = sort(field_nms);
    yrs = fieldnames(VARS_ALL_LSTs.OUTPUTS.ETEC_pt.(field_nms{1}));
    
    ET_All = []; %% only AQUA/TERRA 11/21
    for i=1:length(field_nms)
        for i_yr=1:length(yrs)
            ET_All = [ET_All VARS_ALL_LSTs.OUTPUTS.ETEC_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1:972,:)];
        end
    end
    ET_All=double(ET_All);
    ET_All(ET_All==-999)=nan;
    ET_All=ET_All*.01;
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All ET_All
    
            ET_All_wVIIRS = []; %% add viirs data
            for i=1:length(field_nms)
                for i_yr=1:length(yrs)
                    try
                        ET_All_wVIIRS = [ET_All_wVIIRS VARS_ALL_LSTs.OUTPUTS.ETEC_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1:1215,:)];
                    catch
                        dy_lngth = length(VARS_ALL_LSTs.OUTPUTS.ETEC_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1,:));
                        ET_All_wVIIRS = [ET_All_wVIIRS [VARS_ALL_LSTs.OUTPUTS.ETEC_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1:972,:);...
                            int16(zeros(243,dy_lngth)-999)]];
                    end
                end
            end
            ET_All_wVIIRS=double(ET_All_wVIIRS);
            ET_All_wVIIRS(ET_All_wVIIRS==-999)=nan;
            ET_All_wVIIRS=ET_All_wVIIRS*.01;
            save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All_wVIIRS ET_All_wVIIRS

        
        %% Rn
        field_nms = fieldnames(VARS_ALL_LSTs.OUTPUTS.Rn_pt);
        field_nms = sort(field_nms);
        yrs = fieldnames(VARS_ALL_LSTs.OUTPUTS.Rn_pt.(field_nms{1}));
        
        Rn_All = []; %% only AQUA/TERRA 11/21
        for i=1:length(field_nms)
            for i_yr=1:length(yrs)
                Rn_All = [Rn_All VARS_ALL_LSTs.OUTPUTS.Rn_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1:972,:)];
            end
        end
        Rn_All=double(Rn_All);
        Rn_All(Rn_All==-999)=nan;
        Rn_All=Rn_All;
        save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\Rn_All Rn_All

        %% G
        field_nms = fieldnames(VARS_ALL_LSTs.OUTPUTS.G_pt);
        field_nms = sort(field_nms);
        yrs = fieldnames(VARS_ALL_LSTs.OUTPUTS.G_pt.(field_nms{1}));
        
        G_All = []; %% only AQUA/TERRA 11/21
        for i=1:length(field_nms)
            for i_yr=1:length(yrs)
                G_All = [G_All VARS_ALL_LSTs.OUTPUTS.G_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1:972,:)];
            end
        end
        G_All=double(G_All);
        G_All(G_All==-999)=nan;
        G_All=G_All;
        save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\G_All G_All

        %% LE
        field_nms = fieldnames(VARS_ALL_LSTs.OUTPUTS.LE_pt);
        field_nms = sort(field_nms);
        yrs = fieldnames(VARS_ALL_LSTs.OUTPUTS.LE_pt.(field_nms{1}));
        
        LE_All = []; %% only AQUA/TERRA 11/21
        for i=1:length(field_nms)
            for i_yr=1:length(yrs)
                LE_All = [LE_All VARS_ALL_LSTs.OUTPUTS.LE_pt.(field_nms{i}).(yrs{i_yr}).AquaTerra_1121.VAR_array(1:972,:)];
            end
        end
        LE_All=double(LE_All);
        LE_All(LE_All==-999)=nan;
        LE_All=LE_All;
        save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\LE_All LE_All

    %% ALL INPUTS INTO ETpdct STRUCT/TABLE
    clear

    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\VARS_ALL_LSTs
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat

    fields = fieldnames(ETpdct); % sites
    vars = fieldnames(VARS_ALL_LSTs.INPUTS);
    fields1 = fieldnames(VARS_ALL_LSTs.INPUTS.(vars{1})); % sites
    fields2 = fieldnames(VARS_ALL_LSTs.INPUTS.(vars{1}).(fields1{1})); % yrs
    
    for i_var=1:length(vars) %% input variables
        var_nm = strrep(vars{i_var},'_pt','');
        fields1 = fieldnames(VARS_ALL_LSTs.INPUTS.(vars{i_var})); % sites CrauC is written Crau2 in RH and TA - to address :\   
        for i_st=1:length(fields1) %% sites
            st_ind = contains(fields,fields1{i_st}(1:5)); % Bilos is the shortest st nm

            if i_var==1
                % add 366 rows for 2024 : the ET products file only runs till 2023
                ETpdct.(fields{st_ind}).DLY.year(end+1:end+366) = ETpdct.(fields{st_ind}).DLY.year(ETpdct.(fields{st_ind}).DLY.year==2004)+20; % 2024 like 2004 is a leap yr %%% zeros written into all other cols
                % keyboard
                ETpdct.(fields{st_ind}).DLY.doy(end-365:end) = ETpdct.(fields{st_ind}).DLY.doy(ETpdct.(fields{st_ind}).DLY.year==2004); % ~
                ETpdct.(fields{st_ind}).DLY.month(end-365:end) = ETpdct.(fields{st_ind}).DLY.month(ETpdct.(fields{st_ind}).DLY.year==2004); % ~
                ETpdct.(fields{st_ind}).DLY(end-365:end,4:end) = {nan}; % replace zeros in other cols with nans
            end
            
            %% to update - by rerunning evaspa_pt_extraction.m - done 081024 -- RH and TA still remain :|
            if fields1{i_st}=="Crau2",st_ind = contains(fields,"CrauC");end

            if i_var==1
                ETpdct.(fields{st_ind}).INPUTS = table;
                ETpdct.(fields{st_ind}).INPUTS.year = ETpdct.(fields{st_ind}).DLY.year;
                ETpdct.(fields{st_ind}).INPUTS.doy = ETpdct.(fields{st_ind}).DLY.doy;
                ETpdct.(fields{st_ind}).INPUTS.month = ETpdct.(fields{st_ind}).DLY.month;
            end
            
            for i_yr=1:length(fields2) % 2004-2024 | 2012-2024 for viirs
                yr = fields2{i_yr}(end-3:end);
                if contains(vars{i_var},'LST') || contains(vars{i_var},'EMM') || contains(vars{i_var},'TIME') || contains(vars{i_var},'VZA') || contains(vars{i_var},'Rs_pt') || contains(vars{i_var},'Ra_pt') || contains(vars{i_var},'RH_pt') || contains(vars{i_var},'TA_pt')
                    %%% LST/E, TIME, VZA INPUTS and inst. rad
                    fields_lse = fieldnames(VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{1}).(fields2{i_yr}));
                    for i_lst=1:length(fields_lse) %% LST/Es
                        var_nm_lse = [var_nm '_' fields_lse{i_lst}];
                        if ~any(contains(fieldnames(ETpdct.(fields{st_ind}).INPUTS),var_nm_lse)) && ~(contains(vars{i_var},'Rs_') || contains(vars{i_var},'Ra_'))
                            %%% initialize input columns
                            ETpdct.(fields{st_ind}).INPUTS.(var_nm_lse) = ETpdct.(fields{st_ind}).DLY.year*nan;
                        elseif ~any(contains(fieldnames(ETpdct.(fields{st_ind}).INPUTS),var_nm_lse)) && (contains(vars{i_var},'Rs_') || contains(vars{i_var},'Ra_'))
                            %%% radiation data [4 columns, i.e. era5, msg, merra, era5]
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_ERA5L']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_MSG']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_MERRA']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_ERA5']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                        end

                        %%compile all LSTE inputs PER SITE
                        if ~(contains(vars{i_var},'Rs_') || contains(vars{i_var},'Ra_'))
                            ETpdct.(fields{st_ind}).INPUTS.(var_nm_lse)(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr}).(fields_lse{i_lst});
                        elseif (contains(vars{i_var},'Rs_') || contains(vars{i_var},'Ra_'))
                            %%% radiation data [3 columns, i.e. era5, msg, merra
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_ERA5L'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr}).(fields_lse{i_lst})(:,1);
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_MSG'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr}).(fields_lse{i_lst})(:,2);
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_MERRA'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr}).(fields_lse{i_lst})(:,3);
                            try % Rs_dayave_pt has 3 columns
                                ETpdct.(fields{st_ind}).INPUTS.([var_nm_lse '_ERA5'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr}).(fields_lse{i_lst})(:,4);
                            end
                        end
                    end
                else
                    %%% OTHER INPUTS                        
                    if i_yr==1
                        %% initialize input columns                        
                        if contains(vars{i_var},'Rs_dayave') || contains(vars{i_var},'Ra_dayave')
                            %%% radiation data [3 columns, i.e. era5, msg, merra
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm '_ERA5L']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm '_MSG']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                            ETpdct.(fields{st_ind}).INPUTS.([var_nm '_MERRA']) = ETpdct.(fields{st_ind}).DLY.year*nan;
                        else
                            ETpdct.(fields{st_ind}).INPUTS.(var_nm) = ETpdct.(fields{st_ind}).DLY.year*nan;
                        end

                    end
    
                    %compile all inputs PER SITE
                    if contains(vars{i_var},'Rs_') || contains(vars{i_var},'Ra_')
                        %%% radiation data [3 columns, i.e. era5, msg, merra
                        ETpdct.(fields{st_ind}).INPUTS.([var_nm '_ERA5L'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr})(:,1);
                        ETpdct.(fields{st_ind}).INPUTS.([var_nm '_MSG'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr})(:,2);
                        ETpdct.(fields{st_ind}).INPUTS.([var_nm '_MERRA'])(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr})(:,3);
                    else
                        ETpdct.(fields{st_ind}).INPUTS.(var_nm)(ETpdct.(fields{st_ind}).INPUTS.year==str2num(yr))=VARS_ALL_LSTs.INPUTS.(vars{i_var}).(fields1{i_st}).(fields2{i_yr});
                    end
                end
            end
        end
    end

    ETpdct_inputs = ETpdct;
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_inputs.mat ETpdct_inputs

    %% interpolation (repeated using data above - 4 LSTs AQUA/TERRA 11/21)

    field_nms = fieldnames(ETpdct_inputs);
    field_nm=sort(field_nms);
    field_nm(6)=[];field_nm(7)=[];
    rad_flds = {'Rs_dayave_ERA5L','Rs_dayave_MSG','Rs_dayave_MERRA'};
    
    % ind_2004_2021 = 19724:26298;
    ind_2004_2024 = 19724:27394;
    ind_rad = [1:81 (1:81)+243*1 (1:81)+243*2 (1:81)+243*3]; %% for the 4 LSTs
    
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All
    
    ET_All=ET_All';ET_All(ET_All<0)=nan;
    
    ET_All_int = ET_All*nan;
    
    for i_st=1:length(field_nm)    
        for i_rad=1:length(rad_flds)
    
            ET_ensAll = ET_All((1:length(ind_2004_2024))+(i_st-1)*length(ind_2004_2024),ind_rad+(81*(i_rad-1)));
    
            rs_img_site = ETpdct_inputs.(field_nm{i_st}).INPUTS.(rad_flds{i_rad})(ind_2004_2024);
    
            ET_ens_interpl = [];
    
            for i_ens = 1:length(ET_ensAll(1,:))
                ET_ens = ET_ensAll(:,i_ens);
                %%interpolation
                yii = ET_ens./rs_img_site;
                xii = find(isnan(yii));                
                x1=find(~isnan(ET_ens));
                x = find(~isnan(yii));%if isempty(x),continue;end
                % if length(x1)~=length(x),keyboard;end % tested>>it's possible e.g. MSG in Puechabon
                if isempty(x)
                    ET_ens=yii*nan;
                else
                    y = yii(x);
                    yi1_int = interp1(x,y,xii,'linear');
                    yii(xii) = yi1_int;
                    ET_ens = yii.*rs_img_site;
                    ET_ens(x1) = ET_ensAll(x1,i_ens);
                    ET_ens(ET_ens<0)=nan;yii(isnan(ET_ens))=nan;
                        %%% let's try to fill the/any new nans again !
                        if ~isempty(isnan(yii)) && isempty(isnan(rs_img_site))
                            xii = find(isnan(yii));
                            x = find(~isnan(yii));
                            y = yii(x);
                            yi1_int = interp1(x,y,xii,'linear');
                            yii(xii) = yi1_int;
                            ET_ens = yii.*rs_img_site;
                            ET_ens(x1) = ET_ensAll(x1,i_ens);
                            ET_ens(ET_ens<0)=nan;
                        end
                end
    
                ET_ens_interpl = [ET_ens_interpl ET_ens];
    
            end
    
            % keyboard
    
            ET_All_int((1:length(ind_2004_2024))+(i_st-1)*length(ind_2004_2024),ind_rad+(81*(i_rad-1)))...
                = ET_ens_interpl;
    
        end
    end
    save ET_All_int ET_All_int
            
                %% interpolation (repeated using data above - 5 LSTs AQUA/TERRA 11/21 VIIRS)
                field_nms = fieldnames(ETpdct_inputs);
                field_nm=sort(field_nms);
                field_nm(6)=[];field_nm(7)=[];
                rad_flds = {'Rs_dayave_ERA5L','Rs_dayave_MSG','Rs_dayave_MERRA'};                
                % ind_2004_2021 = 19724:26298;
                ind_2004_2024 = 19724:27394;
                ind_rad = [1:81 (1:81)+243*1 (1:81)+243*2 (1:81)+243*3 (1:81)+243*4]; %% for the 4 LSTs    
                load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All_wVIIRS    
                ET_All_wVIIRS=ET_All_wVIIRS';ET_All_wVIIRS(ET_All_wVIIRS<0)=nan;    
                ET_All_int_wVIIRS = ET_All_wVIIRS*nan;    
                for i_st=1:length(field_nm)    
                    for i_rad=1:length(rad_flds)    
                        ET_ensAll = ET_All_wVIIRS((1:length(ind_2004_2024))+(i_st-1)*length(ind_2004_2024),ind_rad+(81*(i_rad-1)));    
                        rs_img_site = ETpdct_inputs.(field_nm{i_st}).INPUTS.(rad_flds{i_rad})(ind_2004_2024);    
                        ET_ens_interpl = [];    
                        for i_ens = 1:length(ET_ensAll(1,:))
                            ET_ens = ET_ensAll(:,i_ens);
                            %%interpolation
                            yii = ET_ens./rs_img_site;
                            xii = find(isnan(yii));                
                            x1=find(~isnan(ET_ens));
                            x = find(~isnan(yii));%if isempty(x),continue;end
                            % if length(x1)~=length(x),keyboard;end % tested>>it's possible e.g. MSG in Puechabon
                            if isempty(x)
                                ET_ens=yii*nan;
                            else
                                y = yii(x);
                                yi1_int = interp1(x,y,xii,'linear');
                                yii(xii) = yi1_int;
                                ET_ens = yii.*rs_img_site;
                                ET_ens(x1) = ET_ensAll(x1,i_ens);
                                ET_ens(ET_ens<0)=nan;yii(isnan(ET_ens))=nan;
                                    %%% let's try to fill the/any new nans again !
                                    if ~isempty(isnan(yii)) && isempty(isnan(rs_img_site))
                                        xii = find(isnan(yii));
                                        x = find(~isnan(yii));
                                        y = yii(x);
                                        yi1_int = interp1(x,y,xii,'linear');
                                        yii(xii) = yi1_int;
                                        ET_ens = yii.*rs_img_site;
                                        ET_ens(x1) = ET_ensAll(x1,i_ens);
                                        ET_ens(ET_ens<0)=nan;
                                    end
                            end    
                            ET_ens_interpl = [ET_ens_interpl ET_ens];
                
                        end    
                        % keyboard
                
                        ET_All_int_wVIIRS((1:length(ind_2004_2024))+(i_st-1)*length(ind_2004_2024),ind_rad+(81*(i_rad-1)))...
                            = ET_ens_interpl;    
                    end
                end
                save ET_All_int_wVIIRS ET_All_int_wVIIRS


    %% LANDSAT EVASPA ET ESTIMATES
    clear var_pt
    % compile all var_pt
    res_dir = 'W:\smwangi\RS\Evaluation_Benchmarking\EVASPA_database\LANDSAT\'; % landsat results folder
    dirs = dir(res_dir);dirs(1:2)=[];
    dirs = {'196030' '197030' '198030_199030' '200029'};
    for i=1:length(dirs)
        load([res_dir dirs{i} '\result\ETd_' dirs{i}]);
        field_nms = fieldnames(VAR_pt);
        for ii=1:length(field_nms)
            var_pt.(field_nms{ii}) = VAR_pt.(field_nms{ii});
        end        
    end
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_Landsat_pt.mat var_pt

    clear
    % load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_inputs
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa_woInterpolation
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_Landsat_pt

    field_nms = sort(fieldnames(var_pt));
    fld_nms = sort(fieldnames(ET_ref_pdct_evaspa));fld_nms(6)=[];fld_nms(7)=[]; % consistent with field_nms above
    for i=1:length(field_nms)
        % init        
        ET_ref_pdct_evaspa.(fld_nms{i}).DLY.EVASPA_Mean_LANDSAT = ET_ref_pdct_evaspa.(fld_nms{i}).DLY.year*nan;
        ET_ref_pdct_evaspa_woInterpolation.(fld_nms{i}).DLY.EVASPA_Mean_LANDSAT = ET_ref_pdct_evaspa.(fld_nms{i}).DLY.year*nan;

        % add to table
        doy_ind = ismember(ET_ref_pdct_evaspa.(fld_nms{i}).DLY.year*1000+ET_ref_pdct_evaspa.(fld_nms{i}).DLY.doy,var_pt.(field_nms{i}).DOY);
        et = var_pt.(field_nms{i}).ETd_rs'; et(et<0) = nan; et = nanmean(et);        
        ET_ref_pdct_evaspa.(fld_nms{i}).DLY.EVASPA_Mean_LANDSAT(doy_ind) = et;
        ET_ref_pdct_evaspa_woInterpolation.(fld_nms{i}).DLY.EVASPA_Mean_LANDSAT(doy_ind) = et;
    end
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa_ModisViirsLandsat ET_ref_pdct_evaspa
    save \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa_woInterpolation_ModisViirsLandsat ET_ref_pdct_evaspa_woInterpolation

        %% plotting
        ETpdct_inputs=orderfields(ETpdct_inputs);
        fields = fieldnames(ETpdct_inputs);
        fields([6 8])=[];% remove fontB & grignon
        vars = fieldnames(ETpdct_inputs.(fields{1}).INPUTS);
        vars(end-2:end)=[];
        vars(1:3)=[];
        refALL=[];
        perf_array.R = nan(length(vars),length(fields)+1);%% +1 for global [ALL] metrics
        perf_array.D = perf_array.R;

            %%% anon
            willmottD = @(x,y) 1 - nansum((x-y).^2)./nansum((abs(y-nanmean(x)) + abs(x-nanmean(x))).^2);

        %%% per site
        for i=1:length(fields)
            if ~isfield(ETpdct_inputs.(fields{i}),'INPUTS'),continue;end %% skip sites with missing inputs
            ref=ETpdct_inputs.(fields{i}).DLY.Reference;
            refALL=[refALL;ref];
            for i_var=1:length(vars)
                if i==1,estALL.(vars{i_var})=[];end
                est=ETpdct_inputs.(fields{i}).INPUTS.(vars{i_var});
                corrcoef(ref,est,'rows','pairwise');
                perf_array.R(i_var,i)=ans(2);
                perf_array.D(i_var,i)=willmottD((ref-nanmin(ref))./(nanmax(ref)-nanmin(ref))...
                    ,(est-nanmin(est))./(nanmax(est)-nanmin(est))); %% normalized quantities : 0-1                
                %%% all input variables
                estALL.(vars{i_var})=[estALL.(vars{i_var});est];
            end
        end
        %%% global [all sites combined]
        for i_var=1:length(vars)
            corrcoef(refALL,estALL.(vars{i_var}),'rows','pairwise');
            perf_array.R(i_var,end)=ans(2);
            perf_array.D(i_var,end)=willmottD((refALL-nanmin(refALL))/(nanmax(refALL)-nanmin(refALL))...
                ,(estALL.(vars{i_var})-nanmin(estALL.(vars{i_var})))/(nanmax(estALL.(vars{i_var}))-nanmin(estALL.(vars{i_var})))); %% normalized quantities
        end

        %%% heatmaps
        fields_=cell(length(fields)+1,1);
        fields_(1:end-1)=fields;
        fields_(end)={'Global'};
        figure
        subplot(1,2,1)
        heatmap(fields_,vars,perf_array.R,'celllabelcolor','none','missingdatacolor','white','interpreter','none');set(gca,'colormap',flipud(jet(64)));%#ok
        set(gca,'grid','off')
        xlabel('Ground Evapotranspiration')
        title('Correlation Matrix')
        subplot(1,2,2)
        heatmap(fields_,vars,perf_array.D,'celllabelcolor','none','missingdatacolor','white','interpreter','none');set(gca,'colormap',flipud(jet(64)));%#ok
        set(gca,'grid','off')
        xlabel('Ground Evapotranspiration')
        title('Willmott''s D Matrix')

            %% INPUTS UNCERTAINTY
            %%%
            load('\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\puechabon_evaspa_bayesPF.mat', 'x_dates')
            %%% LST
            figure
            N=[8 10];
            j=1;
            for i=1:length(N)
                n=N(i);
                dat=[ETpdct_inputs.Puechabon.INPUTS.(vars{n})(ETpdct_inputs.Puechabon.INPUTS.year==2008)';...
                    ETpdct_inputs.Puechabon.INPUTS.(vars{n+1})(ETpdct_inputs.Puechabon.INPUTS.year==2008)';...
                ];
                subplot(2,2,(j-1)*2+2)
                set(gca,'box','on')
                % area(x_dates,nanmax(dat)-nanmin(dat),'edgecolor','none','facecolor','r') 
                plot(x_dates,nanmax(dat)-nanmin(dat),'b:')
                hold on
                area(x_dates,nanstd(dat),'edgecolor','none','facecolor','b')
                datetick('x','mmm/yy','keepticks');
                ylabel('[K]')
                title(vars{n}(1:end-2),'interpreter','none')    
                if i==1,legend('MAX-MIN','SD');end
                j=j+1;
            end
            
            %%% RAD [AQUA11]
            % N=[14 17 20]; %% ra, rs_dayave, rs [era5l, msg, merra]
            N=[15 30 33]; %% ra, rs_dayave, rs [era5l, msg, merra]
            j=1;
            for i=1:length(N)
                n=N(i);    
                dat=[ETpdct_inputs.Puechabon.INPUTS.(vars{n})(ETpdct_inputs.Puechabon.INPUTS.year==2008)';...
                    ETpdct_inputs.Puechabon.INPUTS.(vars{n+1})(ETpdct_inputs.Puechabon.INPUTS.year==2008)';...
                ETpdct_inputs.Puechabon.INPUTS.(vars{n+2})(ETpdct_inputs.Puechabon.INPUTS.year==2008)';...
                ];
                subplot(3,2,(j-1)*2+1)
                set(gca,'box','on')
                % area(x_dates,nanmax(dat)-nanmin(dat),'edgecolor','none','facecolor','r')
                plot(x_dates,nanmax(dat)-nanmin(dat),'b:')
                hold on
                area(x_dates,nanstd(dat),'edgecolor','none','facecolor','b')
                datetick('x','mmm/yy','keepticks');
                ylabel('[W.m^-^2]')
                title(vars{n}(1:end-6),'interpreter','none')
                if i==1,legend('MAX-MIN','SD');end
                j=j+1;    
            end


%% ################################################################################## %%
%%                                                                                    %%
%% PLOTTING - HEATMAPS, Taylor Diagrams (TD), ...                                     %%
%%                                                                                    %%
%% ################################################################################## %%


clear
close all
warning off

outdir = '\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\plots\ET_products_eval\';%F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\plots\ET_products_eval\';
save_img = false;
mkdir(outdir)

% load F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat
load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ETpdct_1950thru2023_AllSites_SouthFrance.mat
fields=fieldnames(ETpdct);
fields_prd = fieldnames(ETpdct.(fields{1}));

% dly_et_flds = {'CAMELE01';'CAMELE025';'ERA5';'FCOM.RSMET.ALL';'FCOM.RSMET.CERES';'FCOM.RSMET.CRUNCEP';'FCOM.RSMET.GSWP3';'FCOM.RSMET.WFDEI';'GLDAS.CLSM';'GLEAM3.7b';'GLEAM3.8a';'MERRA2';'MSG'};
% mthly_et_flds = {'CAMELE01';'CAMELE025';'ERA5';'FCOM.RSMET.ALL';'FCOM.RSMET.CERES';'FCOM.RSMET.CRUNCEP';'FCOM.RSMET.GSWP3';'FCOM.RSMET.WFDEI';'GLDAS.CLSM';'GLEAM3.7b';'GLEAM3.8a';'MERRA2';'MSG';'[M]DOLCE2.1';'[M]DOLCE3.0';'[M]FCOM.RS.720x360';'[M]FCOM.RS.4320x2160';'[M]FCOM.RSMET.ALL';'[M]FCOM.RSMET.CERES';'[M]FCOM.RSMET.CRUNCEP';'[M]FCOM.RSMET.GSWP3';'[M]FCOM.RSMET.WFDEI';'[M]HG.Land'};
% yrly_et_flds = {'CAMELE01';'CAMELE025';'ERA5';'FCOM.RSMET.ALL';'FCOM.RSMET.CERES';'FCOM.RSMET.CRUNCEP';'FCOM.RSMET.GSWP3';'FCOM.RSMET.WFDEI';'GLDAS.CLSM';'GLEAM3.7b';'GLEAM3.8a';'MERRA2';'MSG';'[M]DOLCE2.1';'[M]DOLCE3.0';'[M]FCOM.RS.720x360';'[M]FCOM.RS.4320x2160';'[M]FCOM.RSMET.ALL';'[M]FCOM.RSMET.CERES';'[M]FCOM.RSMET.CRUNCEP';'[M]FCOM.RSMET.GSWP3';'[M]FCOM.RSMET.WFDEI';'[M]HG.Land';'[Y]MOD16';'[Y]MYD16'};

% dly_et_flds = {'I';'II';'III';'IV';'V';'VI';'VII';'VIII';'IX';'X';'XI';'XII';'XIII'};
% mthly_et_flds = {'I';'II';'III';'IV';'V';'VI';'VII';'VIII';'IX';'X';'XI';'XII';'XIII';'I[M]';'II[M]';'III[M]';'IV[M]';'V[M]';'VI[M]';'VII[M]';'VIII[M]';'IX[M]';'X[M]'};
% yrly_et_flds = {'I';'II';'III';'IV';'V';'VI';'VII';'VIII';'IX';'X';'XI';'XII';'XIII';'I[M]';'II[M]';'III[M]';'IV[M]';'V[M]';'VI[M]';'VII[M]';'VIII[M]';'IX[M]';'X[M]';'I[Y]';'II[Y]'};

% dly_et_flds = {'Reference';'1: CAMELE01';'2: CAMELE025';'3: ERA5';'4: FCOM.RSMET.ALL';'5: FCOM.RSMET.CERES';'6: FCOM.RSMET.CRUNCEP';'7: FCOM.RSMET.GSWP3';'8: FCOM.RSMET.WFDEI';'9: GLDAS.CLSM';'10: GLEAM3.7b';'11: GLEAM3.8a';'12: MERRA2';'13: MSG'};

% dly_et_flds = {'Ref';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13'};
% mthly_et_flds = {'Ref';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'1[M]';'2[M]';'3[M]';'4[M]';'5[M]';'6[M]';'7[M]';'8[M]';'9[M]';'10[M]'};
% yrly_et_flds = {'Ref';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'1[M]';'2[M]';'3[M]';'4[M]';'5[M]';'6[M]';'7[M]';'8[M]';'9[M]';'10[M]';'1[Y]';'2[Y]'};

dly_et_flds = {'Ref';'RefM';'RefC';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15';'16'};%'EVSP1';'EVSP2';'EVSP3';'EVSP4';'EVSP5';'EVSP6';'EVSP7';'EVSP8'};
mthly_et_flds = {'Ref';'RefM';'RefC';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15';'16';'1[M]';'2[M]';'3[M]';'4[M]';'5[M]';'6[M]';'7[M]';'8[M]';'9[M]';'10[M]'};
yrly_et_flds = {'Ref';'RefM';'RefC';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15';'16';'1[M]';'2[M]';'3[M]';'4[M]';'5[M]';'6[M]';'7[M]';'8[M]';'9[M]';'10[M]';'1[Y]';'2[Y]'};

et_fldnms.DLY = fieldnames(ETpdct.Avignon.DLY);et_fldnms.DLY(end-2:end)=[];et_fldnms.DLY(1:3)=[];
et_fldnms.MTHLY = fieldnames(ETpdct.Avignon.MTHLY);et_fldnms.MTHLY(end-2:end)=[];et_fldnms.MTHLY(1:2)=[];
et_fldnms.YRLY = fieldnames(ETpdct.Avignon.YRLY);et_fldnms.YRLY(end-2:end)=[];et_fldnms.YRLY(1)=[];

%%% Sites in Southern France - AS PER EVASPA RUNS
% fields1={'Avignon';'CrauCamargue';'CrauMerle';'LeBray';'Puechabon';'Fontblanche';'Tour_du_Valat';'Larzac';'Toulouse';'Lamasquere';'Aurade';'Bilos'};
fields1={'Avignon';'CrauCamargue';'CrauMerle';'LeBray';'Puechabon';'Fontblanche';'Tour_du_Valat';'Larzac';'Toulouse';'Lamasquere';'Aurade';'Bilos'};

%% HEATMAPS - ET Products
hm_matrix = true; % triangular HM
pdct_only = true; % HM comparing products only
ET_glob_dly=[];ET_glob_mthly=[];ET_glob_yrly=[];
Performance_Metrics=[];
for i_st = 1:length(fields)
    if all(~ismember(fields1,fields{i_st})),continue;end
    figure('Name',fields{i_st},'Renderer','painters','Position',[20 20 1280*1.25 1280*6],'visible','off');
    for i_prd=1:length(fields_prd) %% DLY, MTHLY, YRLY 
            %%% tables to hold all metrics
            Performance_Metrics.(fields_prd{i_prd}).(fields{i_st})=table;
        
%         if i_prd==1,ind=4;elseif i_prd==2,ind=3;else,ind=2;end
        ind = (length(fields_prd) - i_prd) + 2; %%% [[[+ 3 TO OMIT REFERENCE]]] &&& CHANGE dly_et_flds/mthly_et_flds/yrly_et_flds ACCORDINGLY BY REMOVING 'Ref'
        ET_pdcts = table2array(ETpdct.(fields{i_st}).(fields_prd{i_prd})(:,ind:end));
        
        try
        %%% global arrays + ...
        if i_prd==1
            ET_glob_dly=[ET_glob_dly;ET_pdcts];%#ok
            fields_et=dly_et_flds;ttl = [fields{i_st} ' - Daily ET'];
        elseif i_prd==2
            ET_glob_mthly=[ET_glob_mthly;ET_pdcts];%#ok
            fields_et=mthly_et_flds;ttl = [fields{i_st} ' - Monthly ET'];
        else
            ET_glob_yrly=[ET_glob_yrly;ET_pdcts];%#ok
            fields_et=yrly_et_flds;ttl = [fields{i_st} ' - Yearly ET'];
        end
        catch
            continue
        end
                
        % correlation
        correl = corrcoef(ET_pdcts,'rows','pairwise');        
        % rmsd / bias / willmott's D
        holder = ET_pdcts';%holder(holder<0)=nan;
        rmsd=[];bias=[];willmottD=[];mae=[];
        for i=1:length(ET_pdcts(1,:))
            ref=holder(i,:);
            rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
            bias(i,:)=-nanmean(ref-holder,2);%#ok   % - to define it as est-ref
            mae(i,:)=nanmean(abs(ref-holder),2);%#ok
            willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok 
            
            %%% write perf. metrics vs reference data in table
            % if field_nm{i_st} == "LeBray" || field_nm{i_st} == "Lamasquere" || field_nm{i_st} == "Toulouse",ind_i = 2;else,ind_i = 1;end
            if i_st == 6 || i_st == 12 || i_st == 11,ind_i = 2;else,ind_i = 1;end % use ref_MDS data else ref_CORR
            if i==ind_i%i==1
                % Performance_Metrics.(fields_prd{i_prd}).(fields{i_st}).rmsd=rmsd(i,:)';%table(rmsd,D,R,bias,mae,'rownames',fields_evaspa);
                % Performance_Metrics.(fields_prd{i_prd}).(fields{i_st}).D=willmottD(i,:)';
                % Performance_Metrics.(fields_prd{i_prd}).(fields{i_st}).R=correl(:,i);
                % Performance_Metrics.(fields_prd{i_prd}).(fields{i_st}).bias=bias(i,:)';
                % Performance_Metrics.(fields_prd{i_prd}).(fields{i_st}).mae=mae(i,:)';
                RMSD = rmsd(i,:)';D = willmottD(i,:)';R = correl(:,i);Bias = bias(i,:)'; MAE = mae(i,:)';
                Performance_Metrics.(fields_prd{i_prd}).(fields{i_st}) = table(RMSD,D,R,Bias,MAE,'rownames',et_fldnms.(fields_prd{i_prd}));
            end
            
            if hm_matrix
                correl(i,i:end)=nan;
                bias(i,i:end)=nan;%#ok
                mae(i,i:end)=nan;%#ok
                rmsd(i,i:end)=nan;%#ok
                willmottD(i,i:end)=nan;%#ok                
            end

        end

        if pdct_only
            correl(1:3,:)=[];correl(:,1:3)=[];
            bias(1:3,:)=[];bias(:,1:3)=[];
            mae(1:3,:)=[];mae(:,1:3)=[];
            rmsd(1:3,:)=[];rmsd(:,1:3)=[];
            willmottD(1:3,:)=[];willmottD(:,1:3)=[];
            fields_et(1:3)=[];
        end
        
        subplot(3,3,i_prd);set(gca,'box','on');
        h=heatmap(fields_et,fields_et,bias,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
        title(ttl);if hm_matrix, set(h,'grid','off');end
        s=struct(h);s.XAxis.Visible='off';
        if i_prd==1,ylabel('BIAS');end        
        subplot(3,3,i_prd+3);set(gca,'box','on');
%         h=heatmap(fields_et,fields_et,correl,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));%#ok
        h=heatmap(fields_et,fields_et,willmottD,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));%#ok
        s=struct(h);s.XAxis.Visible='off';if hm_matrix, set(h,'grid','off');end
        if i_prd==1,ylabel('Willmott''s D');end        
        subplot(3,3,i_prd+6);set(gca,'box','on');
        h=heatmap(fields_et,fields_et,rmsd,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
        if i_prd==1,ylabel('RMSD');end;if hm_matrix, set(h,'grid','off');end
    end
    if save_img,saveas(gca,[outdir fields{i_st} ' - Metrics.png']);end;close
end

    % Global metrics
    figure('Name','All Sites','Renderer','painters','Position',[20 20 1280*1.25 1280*6],'visible','off');
    for i_prd=1:length(fields_prd) %% DLY, MTHLY, YRLY
            %%% tables to hold all Global metrics
            Performance_Metrics.(fields_prd{i_prd}).Global=table;
        if i_prd==1
            ET_glob=ET_glob_dly;fields_et=dly_et_flds;ttl = 'All Sites - Daily ET';
        elseif i_prd==2
            ET_glob=ET_glob_mthly;fields_et=mthly_et_flds;ttl = 'All Sites - Monthly ET';
        elseif i_prd==3
            ET_glob=ET_glob_yrly;fields_et=yrly_et_flds;ttl = 'All Sites - Yearly ET';
        end
        % correlation
        correl = corrcoef(ET_glob,'rows','pairwise');        
        % rmsd / bias / willmott's D
        holder = ET_glob';rmsd=[];bias=[];willmottD=[];mae=[];
        for i=1:length(ET_glob(1,:))
            ref=holder(i,:);
            rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
            bias(i,:)=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
            mae(i,:)=nanmean(abs(ref-holder),2);%#ok
            willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
            
            %%% write perf. metrics vs reference data in table
            % if field_nm{i_st} == "LeBray" || field_nm{i_st} == "Lamasquere" || field_nm{i_st} == "Toulouse",ind_i = 2;else,ind_i = 1;end
            if i_st == 6 || i_st == 12 || i_st == 11,ind_i = 2;else,ind_i = 1;end % use ref_MDS data else ref_CORR
            if i==ind_i%i==1
                % Performance_Metrics.(fields_prd{i_prd}).Global.rmsd=rmsd(i,:)';
                % Performance_Metrics.(fields_prd{i_prd}).Global.D=willmottD(i,:)';
                % Performance_Metrics.(fields_prd{i_prd}).Global.R=correl(:,i);
                % Performance_Metrics.(fields_prd{i_prd}).Global.bias=bias(i,:)';
                % Performance_Metrics.(fields_prd{i_prd}).Global.mae=mae(i,:)';
                RMSD = rmsd(i,:)';D = willmottD(i,:)';R = correl(:,i);Bias = bias(i,:)'; MAE = mae(i,:)';
                Performance_Metrics.(fields_prd{i_prd}).Global = table(RMSD,D,R,Bias,MAE,'rownames',et_fldnms.(fields_prd{i_prd}));
            end
            
            if hm_matrix
                correl(i,i:end)=nan;
                bias(i,i:end)=nan;%#ok
                mae(i,i:end)=nan;%#ok
                rmsd(i,i:end)=nan;%#ok
                willmottD(i,i:end)=nan;%#ok                
            end            
            
        end

        if pdct_only
            correl(1:3,:)=[];correl(:,1:3)=[];
            bias(1:3,:)=[];bias(:,1:3)=[];
            mae(1:3,:)=[];mae(:,1:3)=[];
            rmsd(1:3,:)=[];rmsd(:,1:3)=[];
            willmottD(1:3,:)=[];willmottD(:,1:3)=[];
            fields_et(1:3)=[];
        end
        
        subplot(3,3,i_prd);set(gca,'box','on');
        h=heatmap(fields_et,fields_et,bias,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
        title(ttl);if hm_matrix, set(h,'grid','off');end
        s=struct(h);s.XAxis.Visible='off';
        if i_prd==1,ylabel('BIAS');end        
        subplot(3,3,i_prd+3);set(gca,'box','on');
%         h=heatmap(fields_et,fields_et,correl,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));%#ok
        h=heatmap(fields_et,fields_et,willmottD,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));%#ok
        s=struct(h);s.XAxis.Visible='off';if hm_matrix, set(h,'grid','off');end
        if i_prd==1,ylabel('Willmott''s D');end        
        subplot(3,3,i_prd+6);set(gca,'box','on');
        h=heatmap(fields_et,fields_et,rmsd,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
        if i_prd==1,ylabel('RMSD');end; if hm_matrix, set(h,'grid','off');end
    end
    if save_img,saveas(gca,[outdir 'All Sites - Metrics.png']);end;close
    save Performance_Metrics Performance_Metrics

    %% TD
addpath \\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\misc\helpers\plotting.scripts\TD + dscatter +++
symbls = {'ob','xk','+k','sc','dr','^r','<r','*r','>r','xb','vg','og','sb','+m'};
figure
for i_prd=1:length(fields_prd) %% DLY, MTHLY, YRLY
    subplot(2,2,i_prd)
    if i_prd==1
        AllDat = ET_glob_dly';fields_et=dly_et_flds;ttl = 'All Sites - Daily ET';
        symbls_ = symbls(1:size(AllDat,1));
    elseif i_prd==2
        AllDat = ET_glob_mthly';fields_et=mthly_et_flds;ttl = 'All Sites - Monthly ET';
    elseif i_prd==3
        AllDat = ET_glob_yrly';fields_et=yrly_et_flds;ttl = 'All Sites - Yearly ET';
    end
    
    for ii = 2:size(AllDat,1)
        C = allstats(AllDat(1,:),AllDat(ii,:));        
        statm(ii,:) = C(:,2);%#ok        
    end
    statm(1,:) = C(:,1);    
    taylordiag(squeeze(statm(:,2)),squeeze(statm(:,3)),squeeze(statm(:,4)),symbls_,fields_et)
    title(ttl)
end

warning on

   %% [g]SCATTER DIAGRAMS
figure;
clf;set(gca,'box','on')
% plot([-1 10],[-1 10],'k');hold on
plot([-100 1500],[-100 1500],'k');hold on
% xlim([-1 10]);ylim([-1 10]);
% xlim([-10 200]);ylim([-10 200]);
xlim([20 1200]);ylim([20 1200]);
axis square
for i=2:size(ET_glob_dly,2)
%     plot(ET_glob_dly(:,1),ET_glob_dly(:,i),symbls{i},'markersize',2)
%     plot(ET_glob_mthly(:,1),ET_glob_mthly(:,i),symbls{i},'markersize',2)
    plot(ET_glob_yrly(:,1),ET_glob_yrly(:,i),symbls{i},'markersize',6)
end
title('All Sites - Annual ET [mm/yr]')
xlabel('Reference ET');ylabel('Product ET Estimate');

    %% Density Scatter
figure;
for i=2:size(ET_glob_dly,2)
    subplot(4,4,i-1);hold on
    plot([-100 1500],[-100 1500],'k');set(gca,'box','on')
    xlim([-1 10]);ylim([-1 10]);
    axis square

%     plot(ET_glob_dly(:,1),ET_glob_dly(:,i),symbls{i},'markersize',2)
%     plot(ET_glob_mthly(:,1),ET_glob_mthly(:,i),symbls{i},'markersize',2)
%     plot(ET_glob_yrly(:,1),ET_glob_yrly(:,i),symbls{i},'markersize',6)
    dscatter(ET_glob_dly(:,1),ET_glob_dly(:,i));%colorbar;
    title([dly_et_flds{i} '- DLY ET [mm/d]'])
    xlabel('Reference ET');ylabel('Product ET Estimate');
end


%% EVASPA Performance

clear

try
    load F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa.mat
catch
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_evaspa.mat
end
%% anons
rmsdfxn = @(x,y) sqrt(nanmean((x-y).^2));
biasfxn = @(x,y) -nanmean(x-y);
maefxn = @(x,y) nanmean(abs(x-y));
willmottD = @(x,y) 1 - nansum((x-y).^2)./nansum((abs(y-nanmean(x)) + abs(x-nanmean(x))).^2);
            
%%% metrics
fields = fieldnames(ET_ref_pdct_evaspa);
lst_est_dirs = {'AQUA11','AQUA21','TERRA11','TERRA21','VIIRS21'};
ref_dat = {'Reference','Reference_MDS','Reference_CORR'};

viirs_bl=false;
if viirs_bl
    ind_2012_2021 = 22646:26298;%viirs starts from 2012
    errordlg('metrics will be for VIIRS period - 2012-2021')
end

%% For HESS, skip to '%% ranked metrics' below

for i_ref=1:length(ref_dat)
    XAll.(ref_dat{i_ref})=[];    
    AllPerfMetrics.(ref_dat{i_ref}) = [];
    for i_lst = 1:length(lst_est_dirs)
        if i_ref==1
            YAll.(lst_est_dirs{i_lst})=[];
        end
        rmsd=[];bias=[];D=[];R=[];mae=[];
        flds_espa_ind=1;clear fields_evaspa
        for i_fld = 1:length(fields)
            x = ET_ref_pdct_evaspa.(fields{i_fld}).DLY.(ref_dat{i_ref});
            try
                y = ET_ref_pdct_evaspa.(fields{i_fld}).DLY.(['EVASPA_Mean_' lst_est_dirs{i_lst}]);
                fields_evaspa{flds_espa_ind} = fields{i_fld}; %#ok
                flds_espa_ind=flds_espa_ind+1;
            catch
                continue
            end
            if viirs_bl,x=x(ind_2012_2021);y=y(ind_2012_2021);end
            rmsd = [rmsd;rmsdfxn(x,y)]; %#ok
            bias = [bias;biasfxn(x,y)]; %#ok
            mae = [mae;maefxn(x,y)]; %#ok
            D = [D;willmottD(x,y)]; %#ok
                correl = corrcoef(x,y,'rows','pairwise');
            R = [R;correl(1,2)]; %#ok
            
            %% all/global ref. and est. data
            if i_lst==1
                XAll.(ref_dat{i_ref})=[XAll.(ref_dat{i_ref});x];
            end
            if i_ref==1
                YAll.(lst_est_dirs{i_lst})=[YAll.(lst_est_dirs{i_lst});y];
            end
        end
        AllPerfMetrics.(ref_dat{i_ref}).(lst_est_dirs{i_lst}) = table(rmsd,D,R,bias,mae,'rownames',fields_evaspa);
    end
end

    %%% global metrics
    XAll.Reference_MDS(isnan(XAll.Reference_MDS))=XAll.Reference(isnan(XAll.Reference_MDS));
    for i_ref=1:length(ref_dat)
        rmsd=[];bias=[];D=[];R=[];mae=[];
        x = XAll.(ref_dat{i_ref});
        for i_lst = 1:length(lst_est_dirs)
            y = YAll.(lst_est_dirs{i_lst});
            rmsd = [rmsd;rmsdfxn(x,y)]; %#ok
            bias = [bias;biasfxn(x,y)]; %#ok
            mae = [mae;maefxn(x,y)]; %#ok
            D = [D;willmottD(x,y)]; %#ok
                correl = corrcoef(x,y,'rows','pairwise');
            R = [R;correl(1,2)]; %#ok
        end
        AllPerfMetrics.(['Global_' ref_dat{i_ref}]) = table(rmsd,D,R,bias,mae,'rownames',lst_est_dirs);
    end

%% ranked metrics

    clear AllPerfMetrics
    load('\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_ref_pdct_inputs.mat')
    load('\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All_int.mat')
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All
    load('\\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All_int_wVIIRS')
    load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All_wVIIRS
    
    field_nms = fieldnames(ETpdct_inputs);
    field_nm=sort(field_nms);
    field_nm(6)=[];field_nm(7)=[];
    fld_cover = {'c','c','f','g','g','f','c','g','f','f','g','g'};

ind_2004_2024 = 19724:27394;

        % seasons
        mths_2004_2024=ETpdct_inputs.Avignon.DLY.month(ind_2004_2024);
        seas_ind.winter = mths_2004_2024==12 | mths_2004_2024==1 | mths_2004_2024==2;
        seas_ind.spring = mths_2004_2024==3 | mths_2004_2024==4 | mths_2004_2024==5;
        seas_ind.summer = mths_2004_2024==6 | mths_2004_2024==7 | mths_2004_2024==8;
        seas_ind.autumn = mths_2004_2024==9 | mths_2004_2024==10 | mths_2004_2024==11;

ref=[];
for i_st=1:length(field_nm)
    if field_nm{i_st} == "LeBray" || field_nm{i_st} == "Lamasquere" || field_nm{i_st} == "Toulouse"
        ref=[ref;ETpdct_inputs.(field_nm{i_st}).DLY.Reference_MDS(ind_2004_2024)];
    else
        ref=[ref;ETpdct_inputs.(field_nm{i_st}).DLY.Reference(ind_2004_2024)];
    end
end
ref=ref';

        % intpl_bl=true;wVIIRS_bl = false;%wVIIRS_bl = true;
        clear intpl_bl wVIIRS_bl
        intpl_ = questdlg('Gap filled or noninterpolated ?','Gapfilled or Uninterpolated ?','gapfilled','uninterpolated','gapfilled');if intpl_=="gapfilled",intpl_bl=true;elseif intpl_=="uninterpolated",intpl_bl=false;end
        wVIIRS_ = questdlg('with VIIRS data ?','Yes or No ?','yes','no','no');if wVIIRS_=="yes",wVIIRS_bl=true;elseif wVIIRS_=="no",wVIIRS_bl=false;end
    if intpl_bl
        if wVIIRS_bl
            holder=ET_All_int_wVIIRS';holder(holder<0)=nan;lst_vars = 1:5;
        else
            holder=ET_All_int';holder(holder<0)=nan;
            lst_vars = 1:4;
        end
    else
        if wVIIRS_bl
            holder=ET_All_wVIIRS;holder(holder<0)=nan;lst_vars = 1:5;
        else
            holder=ET_All;holder(holder<0)=nan;
            lst_vars = 1:4;
        end
    end

        % lst_vars = 1:4;
        rad_vars = 1:3;
        ef_vars = 1:9;
        g_vars = 1:9;
        vars_arr = fliplr(combvec(g_vars,ef_vars,rad_vars,lst_vars)');

load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\misc\helpers\indices; if wVIIRS_bl, indices = indices.aquaterraviirs;else,indices=indices.aquaterra;end
vars = fieldnames(indices);
histgm = true;
ref_crop = [];holder_crop=[];ref_grass = [];holder_grass=[];ref_for = [];holder_for=[];holder_pervar=[];clear PerfMetrics ALL_SITES
fig=figure('Name',field_nm{1},'Renderer','painters','Position',[120 120 1600 420]);
flds_ind = [1 3 4 6 7 9 10 11];i_plt=0;%1:length(field_nm);
for i=flds_ind%1:length(field_nm)
    st_bool = false(length(ind_2004_2024),length(field_nm));
    st_bool(:,i) = true; %e.g. 10 for puechabon
    st_bool = reshape(st_bool,[],1);
    
    holder0 = holder(:,st_bool);ref0=ref(:,st_bool);

    if fld_cover{i}=='c' %croplands
        ref_crop = [ref_crop ref0];holder_crop=[holder_crop holder0];
    elseif fld_cover{i}=='f'%forests
        ref_for = [ref_for ref0];holder_for=[holder_for holder0];
    elseif fld_cover{i}=='g'%grass
        ref_grass = [ref_grass ref0];holder_grass=[holder_grass holder0];        
    end
    ALL_SITES.(field_nm{i}).ref0 = ref0;
    ALL_SITES.(field_nm{i}).holder0 = nanmean(holder0);
    ALL_SITES.(field_nm{i}).holder0_=nanmean([ET_ref_pdct_evaspa.(field_nm{i}).DLY.(['EVASPA_Mean_' lst_est_dirs{1}])(19724:end)';...
        ET_ref_pdct_evaspa.(field_nm{i}).DLY.(['EVASPA_Mean_' lst_est_dirs{2}])(19724:end)';...
        ET_ref_pdct_evaspa.(field_nm{i}).DLY.(['EVASPA_Mean_' lst_est_dirs{3}])(19724:end)';...
        ET_ref_pdct_evaspa.(field_nm{i}).DLY.(['EVASPA_Mean_' lst_est_dirs{4}])(19724:end)']);
    ALL_SITES.(field_nm{i}).uncert = nanstd(holder0);
    ALL_SITES.(field_nm{i}).ave = nanmean(holder0);
    ALL_SITES.(field_nm{i}).perc75 = prctile(holder0,75);
    ALL_SITES.(field_nm{i}).perc25 = prctile(holder0,25);
    
    % compile per variable
    for i_var=1:length(vars)
        if i_var==1,holder_pervar.(field_nm{i}).ref=ref0;end
        holder_pervar.(field_nm{i}).(vars{i_var})=holder0(indices.(vars{i_var}),:);
        % per land cover, seasons and global values
        if i == flds_ind(end)
            if i_var==1
                holder_pervar.crop.ref=ref_crop;
                holder_pervar.for.ref=ref_for;
                holder_pervar.grass.ref=ref_grass;
                
                holder_pervar.Winter.ref=ref(repmat(seas_ind.winter,[length(field_nm) 1]));
                holder_pervar.Spring.ref=ref(repmat(seas_ind.spring,[length(field_nm) 1]));
                holder_pervar.Summer.ref=ref(repmat(seas_ind.summer,[length(field_nm) 1]));
                holder_pervar.Autumn.ref=ref(repmat(seas_ind.autumn,[length(field_nm) 1]));

                holder_pervar.AllSites.ref=ref; % ref for all other sites == nan, so 92052 vector OK
            end
            holder_pervar.crop.(vars{i_var})=holder_crop(indices.(vars{i_var}),:);
            holder_pervar.for.(vars{i_var})=holder_for(indices.(vars{i_var}),:);
            holder_pervar.grass.(vars{i_var})=holder_grass(indices.(vars{i_var}),:);

            holder_pervar.Winter.(vars{i_var})=holder(indices.(vars{i_var}),repmat(seas_ind.winter,[length(field_nm) 1]));
            holder_pervar.Spring.(vars{i_var})=holder(indices.(vars{i_var}),repmat(seas_ind.spring,[length(field_nm) 1]));
            holder_pervar.Summer.(vars{i_var})=holder(indices.(vars{i_var}),repmat(seas_ind.summer,[length(field_nm) 1]));
            holder_pervar.Autumn.(vars{i_var})=holder(indices.(vars{i_var}),repmat(seas_ind.autumn,[length(field_nm) 1]));

            holder_pervar.AllSites.(vars{i_var})=holder(indices.(vars{i_var}),:);
        end
    end
    % metrics
    rmsd_holder_ref=sqrt(nanmean((ref0-holder0).^2,2));
    rmsd_holder_ref=[rmsd_holder_ref vars_arr];
    rmsd_holder_ref(:,6)=1:length(rmsd_holder_ref);
    
        mae_holder_ref=nanmean(abs(holder0-ref0),2);
        mae_holder_ref=[mae_holder_ref vars_arr];
        mae_holder_ref(:,6)=1:length(mae_holder_ref);
        
        bias_holder_ref=-nanmean(ref0-holder0,2);%#ok % - to define it as est-ref
        bias_holder_ref=[bias_holder_ref vars_arr];
        bias_holder_ref(:,6)=1:length(bias_holder_ref);

        willmottD_holder_ref=1 - nansum((ref0-holder0).^2,2)./nansum((abs(holder0-nanmean(ref0)) + abs(ref0-nanmean(ref0))).^2,2);%#ok
        willmottD_holder_ref=[willmottD_holder_ref vars_arr];
        willmottD_holder_ref(:,6)=1:length(willmottD_holder_ref);
    
    rmsd_h_r=sortrows(rmsd_holder_ref,1);
    mae_h_r=sortrows(mae_holder_ref,1);
    bias_h_r=sortrows(bias_holder_ref,1);
    willmottD_h_r=sortrows(willmottD_holder_ref,1,'descend');

    PerfMetrics.RMSD.(field_nm{i})=rmsd_h_r;
    PerfMetrics.MAE.(field_nm{i})=mae_h_r;
    PerfMetrics.WillmottD.(field_nm{i})=willmottD_h_r;
    PerfMetrics.Bias.(field_nm{i})=bias_h_r;

            %% global metrics - all sites combined
            if i == flds_ind(end) %% add global metrics after all sites
                rmsd_holder_ref=sqrt(nanmean((ref-holder).^2,2));
                rmsd_holder_ref=[rmsd_holder_ref vars_arr];
                rmsd_holder_ref(:,6)=1:length(rmsd_holder_ref);
            
                mae_holder_ref=nanmean(abs(holder-ref),2);
                mae_holder_ref=[mae_holder_ref vars_arr];
                mae_holder_ref(:,6)=1:length(mae_holder_ref);
                
                bias_holder_ref=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
                bias_holder_ref=[bias_holder_ref vars_arr];
                bias_holder_ref(:,6)=1:length(bias_holder_ref);
        
                willmottD_holder_ref=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
                willmottD_holder_ref=[willmottD_holder_ref vars_arr];
                willmottD_holder_ref(:,6)=1:length(willmottD_holder_ref);
    
                PerfMetrics.RMSD.AllSites=sortrows(rmsd_holder_ref,1);
                PerfMetrics.MAE.AllSites=sortrows(mae_holder_ref,1);
                PerfMetrics.WillmottD.AllSites=sortrows(willmottD_holder_ref,1,'descend');
                PerfMetrics.Bias.AllSites=sortrows(bias_holder_ref,1);            
            end
        
    % subplot(2,6,i)
    i_plt = i_plt+1;
    if length(flds_ind) == length(field_nm)
        subplot(2,6,i)
    else
        subplot(1,length(flds_ind),i_plt)
    end
    hold on;set(gca,'box','on');
    if ~histgm
        plot(rmsd_h_r(:,1),'k','linewidth',1.5)
        ylim([0.5 2])
        if i_plt==1 || i_plt==ceil(length(flds_ind)/2)+1,ylabel('RMSD / MAE [mm/d]');else,set(gca,'yticklabels',[]);end
        if i_plt>ceil(length(flds_ind)/2),xlabel('EVASPA member');else,set(gca,'xticklabels',[]);end
        % yyaxis right
        plot(mae_h_r(:,1),'--b','linewidth',1.5)
        ylim([0.5 2])
    else
        % histogram(rmsd_h_r(:,1),50,'edgecolor','none','facecolor','k')
        % histogram(mae_h_r(:,1),50,'edgecolor','none','facecolor',[0.55,0.55,0.55])
        h1=histogram(rmsd_h_r(:,1),'edgecolor','none','facecolor','k');h1.BinWidth = 0.009;
        h2=histogram(mae_h_r(:,1),'edgecolor','none','facecolor',[0.55,0.55,0.55]);h2.BinWidth = 0.009;
        xlim([0.5 2]);ylim([0 65])
        if length(flds_ind) == length(field_nm)
            if i_plt==1 || i_plt==ceil(length(flds_ind)/2)+1,ylabel('Freq. [no.]');else,set(gca,'yticklabels',[]);end
            if i_plt>ceil(length(flds_ind)/2),xlabel('RMSD / MAE [mm/d]');else,set(gca,'xticklabels',[]);end
        else
            if i_plt==1,ylabel('Freq. [no.]');else,set(gca,'yticklabels',[]);end            
        end
    end
    % ylabel('MAE [mm/d]')
    axis square
    set(gca,'box','on','linewidth',1.25,'fontsize',12)

    title(field_nm{i},'interpreter','none')
    if i_plt==1,legend('RMSD','MAE','fontsize',14);end

    handl=axes(fig,'visible','off');
    handl.XLabel.Visible='on';            
    xlabel(handl,'RMSD / MAE [mm/d]','fontsize',14)    
end
% save \\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\misc\helpers\plotting.scripts\Violinplot-Matlab-master\PerfMetrics PerfMetrics

        % metrics - hess
        rmsd=[];bias=[];D=[];R=[];mae=[];uncert = [];ave = [];CV = [];IQR=[];QCD=[];
        uniq_lc=unique(fld_cover);
        for i_fld = flds_ind
            x = ALL_SITES.(field_nm{i_fld}).ref0;y = ALL_SITES.(field_nm{i_fld}).holder0;
                rmsd=[rmsd;rmsdfxn(x,y)];
                bias=[bias;biasfxn(x,y)];          
                mae=[mae;maefxn(x,y)];
                D = [D;willmottD(x,y)]; %#ok
                    correl = corrcoef(x',y','rows','pairwise');
                R = [R;correl(1,2)]; %#ok
                uncert = [uncert;nanmedian(ALL_SITES.(field_nm{i_fld}).uncert)]; %#ok
                ave = [ave;nanmedian(ALL_SITES.(field_nm{i_fld}).ave)]; %#ok
                CV = [CV;nanmedian(ALL_SITES.(field_nm{i_fld}).uncert./ALL_SITES.(field_nm{i_fld}).ave)]; %#ok
                IQR = [IQR;nanmedian(ALL_SITES.(field_nm{i_fld}).perc75 - ALL_SITES.(field_nm{i_fld}).perc25)]; %#ok
                QCD = [QCD;nanmedian((ALL_SITES.(field_nm{i_fld}).perc75 - ALL_SITES.(field_nm{i_fld}).perc25)./(ALL_SITES.(field_nm{i_fld}).perc75 + ALL_SITES.(field_nm{i_fld}).perc25))]; %#ok

            if i_fld == flds_ind(end) %% add per croptype metrics after all sites
                for i =1:length(uniq_lc)
                    if uniq_lc{i}=='c'
                        x = ref_crop;y=nanmean(holder_crop);uncert_=nanmedian(nanstd(holder_crop));ave_=nanmedian(nanmean(holder_crop));CV_=nanmedian(nanstd(holder_crop)./nanmean(holder_crop));IQR_=nanmedian((prctile(holder_crop,75) - prctile(holder_crop,25)));QCD_=nanmedian((prctile(holder_crop,75) - prctile(holder_crop,25))./(prctile(holder_crop,75) + prctile(holder_crop,25)));%#ok
                    elseif uniq_lc{i}=='f'
                        x = ref_for;y=nanmean(holder_for);uncert_=nanmedian(nanstd(holder_for));ave_=nanmedian(nanmean(holder_for));CV_=nanmedian(nanstd(holder_for)./nanmean(holder_for));IQR_=nanmedian((prctile(holder_for,75) - prctile(holder_for,25)));QCD_=nanmedian((prctile(holder_for,75) - prctile(holder_for,25))./(prctile(holder_for,75) + prctile(holder_for,25)));%#ok
                    elseif uniq_lc{i}=='g'
                        x = ref_grass;y=nanmean(holder_grass);uncert_=nanmedian(nanstd(holder_grass));ave_=nanmedian(nanmean(holder_grass));CV_=nanmedian(nanstd(holder_grass)./nanmean(holder_grass));IQR_=nanmedian((prctile(holder_grass,75) - prctile(holder_grass,25)));QCD_=nanmedian((prctile(holder_grass,75) - prctile(holder_grass,25))./(prctile(holder_grass,75) + prctile(holder_grass,25)));%#ok
                    end
                    rmsd=[rmsd;rmsdfxn(x,y)];
                    bias=[bias;biasfxn(x,y)];          
                    mae=[mae;maefxn(x,y)];
                    D = [D;willmottD(x,y)]; %#ok
                        correl = corrcoef(x',y','rows','pairwise');
                    R = [R;correl(1,2)]; %#ok
                    uncert = [uncert;uncert_]; %#ok
                    ave = [ave;ave_]; %#ok
                    CV = [CV;CV_]; %#ok
                    IQR = [IQR;IQR_]; %#ok
                    QCD = [QCD;QCD_]; %#ok
                end
            end
        end

        x = [ref_crop ref_grass ref_for];y=nanmean([holder_crop holder_grass holder_for]);y_uncert = nanstd([holder_crop holder_grass holder_for]);y_ave = nanmean([holder_crop holder_grass holder_for]);y_perc75 = prctile([holder_crop holder_grass holder_for],75);y_perc25 = prctile([holder_crop holder_grass holder_for],25);

            % seasonal performance            
            x_winter = x(repmat(seas_ind.winter,[length(flds_ind) 1]));y_winter = y(repmat(seas_ind.winter,[length(flds_ind) 1]));y_winter_uncert = y_uncert(repmat(seas_ind.winter,[length(flds_ind) 1]));y_winter_ave = y_ave(repmat(seas_ind.winter,[length(flds_ind) 1]));y_winter_perc75 = y_perc75(repmat(seas_ind.winter,[length(flds_ind) 1]));y_winter_perc25 = y_perc25(repmat(seas_ind.winter,[length(flds_ind) 1]));
            x_spring = x(repmat(seas_ind.spring,[length(flds_ind) 1]));y_spring = y(repmat(seas_ind.spring,[length(flds_ind) 1]));y_spring_uncert = y_uncert(repmat(seas_ind.spring,[length(flds_ind) 1]));y_spring_ave = y_ave(repmat(seas_ind.spring,[length(flds_ind) 1]));y_spring_perc75 = y_perc75(repmat(seas_ind.spring,[length(flds_ind) 1]));y_spring_perc25 = y_perc25(repmat(seas_ind.spring,[length(flds_ind) 1]));
            x_summer = x(repmat(seas_ind.summer,[length(flds_ind) 1]));y_summer = y(repmat(seas_ind.summer,[length(flds_ind) 1]));y_summer_uncert = y_uncert(repmat(seas_ind.summer,[length(flds_ind) 1]));y_summer_ave = y_ave(repmat(seas_ind.summer,[length(flds_ind) 1]));y_summer_perc75 = y_perc75(repmat(seas_ind.summer,[length(flds_ind) 1]));y_summer_perc25 = y_perc25(repmat(seas_ind.summer,[length(flds_ind) 1]));
            x_autumn = x(repmat(seas_ind.autumn,[length(flds_ind) 1]));y_autumn = y(repmat(seas_ind.autumn,[length(flds_ind) 1]));y_autumn_uncert = y_uncert(repmat(seas_ind.autumn,[length(flds_ind) 1]));y_autumn_ave = y_ave(repmat(seas_ind.autumn,[length(flds_ind) 1]));y_autumn_perc75 = y_perc75(repmat(seas_ind.autumn,[length(flds_ind) 1]));y_autumn_perc25 = y_perc25(repmat(seas_ind.autumn,[length(flds_ind) 1]));

            rmsd=[rmsd;rmsdfxn(x_winter,y_winter);rmsdfxn(x_spring,y_spring);rmsdfxn(x_summer,y_summer);rmsdfxn(x_autumn,y_autumn)];
            bias=[bias;biasfxn(x_winter,y_winter);biasfxn(x_spring,y_spring);biasfxn(x_summer,y_summer);biasfxn(x_autumn,y_autumn)];          
            mae=[mae;maefxn(x_winter,y_winter);maefxn(x_spring,y_spring);maefxn(x_summer,y_summer);maefxn(x_autumn,y_autumn)];
            D = [D;willmottD(x_winter,y_winter);willmottD(x_spring,y_spring);willmottD(x_summer,y_summer);willmottD(x_autumn,y_autumn)];
                correl = corrcoef(x_winter',y_winter','rows','pairwise');correl1 = corrcoef(x_spring',y_spring','rows','pairwise');correl2 = corrcoef(x_summer',y_summer','rows','pairwise');correl3 = corrcoef(x_autumn',y_autumn','rows','pairwise');
            R = [R;correl(1,2);correl1(1,2);correl2(1,2);correl3(1,2)];
            uncert = [uncert;nanmedian(y_winter_uncert);nanmedian(y_spring_uncert);nanmedian(y_summer_uncert);nanmedian(y_autumn_uncert)];
            ave = [ave;nanmedian(y_winter_ave);nanmedian(y_spring_ave);nanmedian(y_summer_ave);nanmedian(y_autumn_ave)];
            CV = [CV;...
                nanmedian(y_winter_uncert./y_winter_ave);...
                nanmedian(y_spring_uncert./y_spring_ave);...
                nanmedian(y_summer_uncert./y_summer_ave);...
                nanmedian(y_autumn_uncert./y_autumn_ave)];
            IQR = [IQR;...
                nanmedian((y_winter_perc75 - y_winter_perc25));...
                nanmedian((y_spring_perc75 - y_spring_perc25));...
                nanmedian((y_summer_perc75 - y_summer_perc25));...
                nanmedian((y_autumn_perc75 - y_autumn_perc25))];
            QCD = [QCD;...
                nanmedian((y_winter_perc75 - y_winter_perc25)./(y_winter_perc75 + y_winter_perc25));...
                nanmedian((y_spring_perc75 - y_spring_perc25)./(y_spring_perc75 + y_spring_perc25));...
                nanmedian((y_summer_perc75 - y_summer_perc25)./(y_summer_perc75 + y_summer_perc25));...
                nanmedian((y_autumn_perc75 - y_autumn_perc25)./(y_autumn_perc75 + y_autumn_perc25))];

        % global perf        
        rmsd=[rmsd;rmsdfxn(x,y)];
        bias=[bias;biasfxn(x,y)];          
        mae=[mae;maefxn(x,y)];
        D = [D;willmottD(x,y)];
            correl = corrcoef(x',y','rows','pairwise');
        R = [R;correl(1,2)];
        uncert = [uncert;nanmedian(y_uncert)];%#ok
        ave = [ave;nanmedian(y_ave)];%#ok
        CoefVar = uncert./ave;
        CV = [CV;nanmedian(y_uncert./y_ave)];
        IQR = [IQR;nanmedian(y_perc75 - y_perc25)];
        QCD = [QCD;nanmedian((y_perc75 - y_perc25)./(y_perc75 + y_perc25))];
        all_sites = {field_nm{flds_ind},'Crop','Forest','Grass','Winter','Spring','Summer','Autumn','All Sites'};% 'Crop','Forest','Grass' arranged according to uniq_lc : see above        
            if intpl_bl
                if wVIIRS_bl,varnm='gapfilled_wVIIRS';else,varnm='gapfilled_woVIIRS';end
            else
                if wVIIRS_bl,varnm='noninterp1_wVIIRS';else,varnm='noninterp1_woVIIRS';end
            end
        AllPerfMetrics.(varnm).('Global_perf') = table(rmsd,D,R,bias,mae,uncert,ave,CoefVar,CV,IQR,QCD,'rownames',all_sites);

        if length(fieldnames(AllPerfMetrics))==4,save \\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\AllPerfMetrics AllPerfMetrics;end

        %%% violin plots
        addpath \\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\misc\helpers\plotting.scripts
        addpath \\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\misc\helpers\plotting.scripts\Violinplot-Matlab-master
            load PerfMetrics
        flds_ = fieldnames(PerfMetrics);sites=fieldnames(PerfMetrics.(flds_{1}));sites_=sites;sites_{contains(sites_,'CrauCamargue')}='Coussoul';
        ylim_ = {[0.4 2],[0.4 2],[0.35 1],[-1.2 2]};
        figure;subplot = @(m,n,p) subtightplot(m, n, p, [0.04 0.05], [0.2 0.05], [0.1 0.01]);%subplot = @(m,n,p) subtightplot(m, n, p, [0.02 0.05], [0.1 0.01], [0.1 0.01]);
        for i=1:length(flds_)
            dat = [];
            for ii=1:length(sites)
                dat = [dat PerfMetrics.(flds_{i}).(sites{ii})(:,1)];
            end
            subplot(ceil(length(flds_)/2),2,i);box on
            vioplt = violinplot(dat,char(string(1:length(bias_h_r(:,1)))')...
                ,'QuartileStyle','shadow','HalfViolin','left','DataStyle','histogram','ViolinColor',[.4 .4 .4],'ShowMean',true);
            if i>=length(flds_)-1,set(gca,'xticklabels',sites_);else,set(gca,'xticklabels',[]);end
            set(gca,'linewidth',1.25,'fontsize',15)
            ylim(ylim_{i});ylabel(flds_{i})
        end;clear subplot

        % heatmaps - versus obs., uncert.
        sites = fieldnames(holder_pervar);sites_=sites;sites_{contains(sites_,'CrauCamargue')}='Coussoul';sites_{contains(sites_,'for')}='Forest';sites_{contains(sites_,'crop')}='Crop';sites_{contains(sites_,'grass')}='Grass';sites_{end}='All Sites & Seasons';clear metrics_vars
        metrics_vars.RMSD=nan(length(sites),length(vars)+1);metrics_vars.D=nan(length(sites),length(vars)+1);metrics_vars.MAE=nan(length(sites),length(vars)+1);metrics_vars.Bias=nan(length(sites),length(vars)+1);
        for i_st=1:length(sites)
            ref_var = holder_pervar.(sites{i_st}).ref;
            for i_var=1:length(vars)
                metrics_vars.RMSD(i_st,i_var)=rmsdfxn(ref_var,nanmean(holder_pervar.(sites{i_st}).(vars{i_var})));
                metrics_vars.D(i_st,i_var)=willmottD(ref_var,nanmean(holder_pervar.(sites{i_st}).(vars{i_var})));
                metrics_vars.MAE(i_st,i_var)=maefxn(ref_var,nanmean(holder_pervar.(sites{i_st}).(vars{i_var})));
                metrics_vars.Bias(i_st,i_var)=biasfxn(ref_var,nanmean(holder_pervar.(sites{i_st}).(vars{i_var})));
                % uncertainty metrics - SD, CV, QCD
                metrics_vars.SD(i_st,i_var)=nanmedian(nanstd(holder_pervar.(sites{i_st}).(vars{i_var})));
                metrics_vars.CV(i_st,i_var)=nanmedian(nanstd(holder_pervar.(sites{i_st}).(vars{i_var}))./ ...
                    nanmean(holder_pervar.(sites{i_st}).(vars{i_var})));
                metrics_vars.QCD(i_st,i_var)=nanmedian((prctile(holder_pervar.(sites{i_st}).(vars{i_var}),75) - prctile(holder_pervar.(sites{i_st}).(vars{i_var}),25))./ ...
                    (prctile(holder_pervar.(sites{i_st}).(vars{i_var}),75) + prctile(holder_pervar.(sites{i_st}).(vars{i_var}),25)));

                if i_var==length(vars)
                    if ~wVIIRS_bl 
                        holder0 = [holder_pervar.(sites{i_st}).MYD11...
                            ;holder_pervar.(sites{i_st}).MYD21...
                            ;holder_pervar.(sites{i_st}).MOD11...
                            ;holder_pervar.(sites{i_st}).MOD21];
                    else
                        holder0 = [holder_pervar.(sites{i_st}).MYD11...
                            ;holder_pervar.(sites{i_st}).MYD21...
                            ;holder_pervar.(sites{i_st}).MOD11...
                            ;holder_pervar.(sites{i_st}).MOD21...
                            ;holder_pervar.(sites{i_st}).VIIRS21];
                    end
                    metrics_vars.RMSD(i_st,i_var+1)=rmsdfxn(ref_var,nanmean(holder0));
                    metrics_vars.D(i_st,i_var+1)=willmottD(ref_var,nanmean(holder0));
                    metrics_vars.MAE(i_st,i_var+1)=maefxn(ref_var,nanmean(holder0));
                    metrics_vars.Bias(i_st,i_var+1)=biasfxn(ref_var,nanmean(holder0));
                    % uncertainty metrics - SD, CV, QCD
                    metrics_vars.SD(i_st,i_var+1)=nanmedian(nanstd(holder0));
                    metrics_vars.CV(i_st,i_var+1)=nanmedian(nanstd(holder0)./ ...
                        nanmean(holder0));
                    metrics_vars.QCD(i_st,i_var+1)=nanmedian((prctile(holder0,75) - prctile(holder0,25))./ ...
                        (prctile(holder0,75) + prctile(holder0,25)));

                end
            end
        end
            flds_ = fieldnames(metrics_vars);ylim_ = {[0.4 2],[0.35 1],[0.4 1.5],[-1 1]};%ylim_ = {[0.4 2],[0.35 1],[0.4 1.5],[-1.2 2]};
            mae_bl = false;if ~mae_bl,flds_(3) = [];ylim_(3)=[];sub_sz=3;else,sub_sz=4;end
            addpath \\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\misc\helpers\plotting.scripts
            % performance metrics
            figure;subplot = @(m,n,p) subtightplot(m, n, p, [0.04 0.05], [0.1 0.05], [0.1 0.1]);%subplot = @(m,n,p) subtightplot(m, n, p, [0.02 0.05], [0.1 0.01], [0.1 0.01]);
            for i=1:length(flds_)-3 %% excluding SD,CV,QCD
                subplot(sub_sz,1,i)
                metrics_arr=floor(metrics_vars.(flds_{i})*100)/100;
                h=heatmap(metrics_arr,'missingdatacolor','white');clim(ylim_{i})
                h.CellLabelFormat = '%.2f';h.YDisplayLabels = sites_;
                s=struct(h);set(h,'grid','off');if i~=length(flds_)-3,s.XAxis.Visible='off';else,h.XDisplayLabels = [vars ;'Combined'];end
                set(gca,'fontsize',12.5);if i~=2,title([flds_{i} ' [mm/d]']);if i~=length(flds_)-3,set(gca,'colormap',flipud(sky(256)));else,set(gca,'colormap',[sky(floor(abs(ylim_{i}(1)/ylim_{i}(2))*256));flipud(sky(256))]);end;else,title([flds_{i} ' [-]']);end
            end;clear subplot
                % uncertainty metrics -- SD,CV,QCD
                if ~mae_bl,flds_(1:3) = [];else,flds_(1:4) = [];end;sub_sz=3;ylim_ = {[0 1],[0 1],[0 1]};%#ok
                figure;subplot = @(m,n,p) subtightplot(m, n, p, [0.04 0.05], [0.1 0.05], [0.1 0.1]);%subplot = @(m,n,p) subtightplot(m, n, p, [0.02 0.05], [0.1 0.01], [0.1 0.01]);
                for i=1:length(flds_) %% SD,CV,QCD
                    subplot(sub_sz,1,i)
                    metrics_arr=floor(metrics_vars.(flds_{i})*100)/100;
                    h=heatmap(metrics_arr,'missingdatacolor','white');clim(ylim_{i})
                    h.CellLabelFormat = '%.2f';h.YDisplayLabels = sites_;
                    s=struct(h);set(h,'grid','off');if i~=length(flds_),s.XAxis.Visible='off';else,h.XDisplayLabels = [vars ;'Combined'];end
                    set(gca,'fontsize',12.5);set(gca,'colormap',flipud(sky(256)));if i==1,title([flds_{i} ' [mm/d]']);else,title([flds_{i} ' [-]']);end
                end;clear subplot
                
        %% heatmap - within EVASPA ensemble
        load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\ET_All
        load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\Rn_All
        load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\G_All
        load \\147.100.1.28\projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\TEST\ET_subset_FRANCE\LE_All

        distinct_bl=true;
        vars = {'Rn_All','G_All','LE_All','EF_All','ET_All'};EF_All = LE_All./(Rn_All - G_All);EF_All(EF_All>1) = nan;warning off;hm_matrix = true; % triangular HM
        var_ind = {1:81:972,reshape((0:8)' + (1:81:972),[],1),1:972,[1:9:81 (1:9:81)+243 (1:9:81)+243*2 (1:9:81)+243*3],1:972};
        % vars = {'Rn_All','G_All','LE_All','ET_All'};warning off;hm_matrix = true; % triangular HM
        % var_ind = {1:81:972,reshape((0:8)' + (1:81:972),[],1),1:972,1:972};
        % all land covers combined
        figure;sub_cols = length(vars)-1;
        for i_var=1:length(vars)-1
            % correlation
            % correl = corrcoef(ET_All_int,'rows','pairwise');        
            % rmsd / bias / willmott's D
            holder = eval(vars{i_var});%ET_All_int';
            if distinct_bl,holder = holder(var_ind{i_var},:);end
            rmsd=[];bias=[];willmottD=[];mae=[];
            for i=1:length(holder(:,1))
                ref=holder(i,:);
                rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
                bias(i,:)=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
                mae(i,:)=nanmean(abs(ref-holder),2);%#ok
                willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
                                        
                if hm_matrix
                    % correl(i,i:end)=nan;
                    bias(i,i:end)=nan;%#ok
                    mae(i,i:end)=nan;%#ok
                    rmsd(i,i:end)=nan;%#ok
                    willmottD(i,i:end)=nan;%#ok                
                end            
                
            end
            subplot(2,sub_cols,i_var);set(gca,'box','on');axis square
            h=heatmap(willmottD,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));clim([0.5 1])
            s=struct(h);s.XAxis.Visible='on';if hm_matrix, set(h,'grid','off');end
            if i_var==1,ylabel('Willmott''s D');end
            flds=string(1:length(holder(:,1)));fldbl = true(length(holder(:,1)),1);
            if distinct_bl && i_var<=2
                if i_var==1
                    fldbl([1:3 6:3:12])=false;
                elseif i_var == 2                        
                    fldbl([1 9 18 27:27:108])=false;
                end
            else
                if distinct_bl && vars{i_var}=="EF_All"
                    fldbl([1 9:9:36])=false;
                else
                    fldbl([1 9 81 243:243:972])=false;
                end
            end
            flds(fldbl) = '';
            h.XDisplayLabels = flds;h.YDisplayLabels = flds;
            title(strrep(vars{i_var},'_All',''));set(gca,'fontsize',16)
                subplot(2,sub_cols,sub_cols + i_var);set(gca,'box','on');axis square
                h=heatmap(mae,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));if vars{i_var}~="EF_All",clim([0 160]);else,clim([0 0.25]);end
                s=struct(h);s.XAxis.Visible='on';if hm_matrix, set(h,'grid','off');end
                if i_var==1,ylabel('MAE');end
                flds=string(1:length(holder(:,1)));fldbl = true(length(holder(:,1)),1);
                
                if distinct_bl && i_var<=2
                    if i_var==1
                        fldbl([1:3 6:3:12])=false;
                    elseif i_var == 2                        
                        fldbl([1 9 18 27:27:108])=false;
                    end
                else
                    if distinct_bl && vars{i_var}=="EF_All"
                        fldbl([1 9:9:36])=false;
                    else
                        fldbl([1 9 81 243:243:972])=false;
                    end
                end
                flds(fldbl) = '';
                h.XDisplayLabels = flds;h.YDisplayLabels = flds;set(gca,'fontsize',16)
                % keyboard
        end

            % per land cover
            lc_ind = {[1 2 7],[3 6 9 10],[4 5 8 11 12]}; % crop,forest,grass in field_nm
            lc_nm = {'Crop','Forest','Grass'};
            figure%;subplot = @(m,n,p) subtightplot(m, n, p, [0.04 0.05], [0.2 0.05], [0.1 0.01]);
            for i_lc=1:length(lc_nm)
                st_bool = false(length(ind_2004_2024),length(field_nm));
                st_bool(:,lc_ind{i_lc}) = true; %e.g. 10 for puechabon
                st_bool = reshape(st_bool,[],1);
                for i_var=1:length(vars)-1                    
                    holder = eval(vars{i_var});holder = holder(:,st_bool);%ET_All_int';
                    if distinct_bl,holder = holder(var_ind{i_var},:);end
                    rmsd=[];bias=[];willmottD=[];mae=[];
                    for i=1:length(holder(:,1))
                        ref=holder(i,:);
                        rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
                        bias(i,:)=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
                        mae(i,:)=nanmean(abs(ref-holder),2);%#ok
                        willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
                                                
                        if hm_matrix
                            % correl(i,i:end)=nan;
                            bias(i,i:end)=nan;%#ok
                            mae(i,i:end)=nan;%#ok
                            rmsd(i,i:end)=nan;%#ok
                            willmottD(i,i:end)=nan;%#ok                
                        end            
                        
                    end
                    subplot(2*3,sub_cols,i_var + (i_lc-1)*sub_cols*2);set(gca,'box','on');
                    h=heatmap(willmottD,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));clim([0.5 1])
                    s=struct(h);s.XAxis.Visible='off';if hm_matrix, set(h,'grid','off');end
                    if i_var==1,ylabel('Willmott''s D');end
                    flds=string(1:length(holder(:,1)));fldbl = true(length(holder(:,1)),1);
                    if distinct_bl && i_var<=2
                        if i_var==1
                            fldbl([1:3 6:3:12])=false;
                        elseif i_var == 2                        
                            fldbl([1 9 18 27:27:108])=false;
                        end
                    else                        
                        if distinct_bl && vars{i_var}=="EF_All"
                            fldbl([1 9:9:36])=false;
                        else
                            fldbl([1 9 81 243:243:972])=false;
                        end
                    end
                    flds(fldbl) = '';
                    h.XDisplayLabels = flds;h.YDisplayLabels = flds;
                    title([strrep(vars{i_var},'_All','') ' ' lc_nm{i_lc}]);set(gca,'fontsize',12)
                        subplot(2*3,sub_cols,sub_cols + i_var + (i_lc-1)*sub_cols*2);set(gca,'box','on');
                        h=heatmap(mae,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));if vars{i_var}~="EF_All",clim([0 160]);else,clim([0 0.25]);end%       clim([0 160])
                        if i_lc==length(lc_nm),s=struct(h);s.XAxis.Visible='on';else,s=struct(h);s.XAxis.Visible='off';end;if hm_matrix, set(h,'grid','off');end
                        if i_var==1,ylabel('MAE');end
                        flds=string(1:length(holder(:,1)));fldbl = true(length(holder(:,1)),1);
                        
                        if distinct_bl && i_var<=2
                            if i_var==1
                                fldbl([1:3 6:3:12])=false;
                            elseif i_var == 2                        
                                fldbl([1 9 18 27:27:108])=false;
                            end
                        else
                            if distinct_bl && vars{i_var}=="EF_All"
                                fldbl([1 9:9:36])=false;
                            else
                                fldbl([1 9 81 243:243:972])=false;
                            end
                        end
                        flds(fldbl) = '';
                        h.XDisplayLabels = flds;h.YDisplayLabels = flds;set(gca,'fontsize',12)
                        % keyboard
                end
            end%;clear subplot

                % per season
                mths_2004_2024=ETpdct_inputs.Avignon.DLY.month(ind_2004_2024);
                seas_ind.winter = mths_2004_2024==12 | mths_2004_2024==1 | mths_2004_2024==2;
                seas_ind.spring = mths_2004_2024==3 | mths_2004_2024==4 | mths_2004_2024==5;
                seas_ind.summer = mths_2004_2024==6 | mths_2004_2024==7 | mths_2004_2024==8;
                seas_ind.autumn = mths_2004_2024==9 | mths_2004_2024==10 | mths_2004_2024==11;
                    seas_ind.winter = repmat(seas_ind.winter,length(field_nm),1);
                    seas_ind.spring = repmat(seas_ind.spring,length(field_nm),1);
                    seas_ind.summer = repmat(seas_ind.summer,length(field_nm),1);
                    seas_ind.autumn = repmat(seas_ind.autumn,length(field_nm),1);            
                seas = fieldnames(seas_ind);
                for i_seas = 1:length(seas)
                    figure('name',seas{i_seas})
                    for i_var=1:length(vars)-1
                        % correlation
                        % correl = corrcoef(ET_All_int,'rows','pairwise');        
                        % rmsd / bias / willmott's D
                        holder = eval(vars{i_var});%ET_All_int';
                        if distinct_bl,holder = holder(var_ind{i_var},:);end
                        holder = holder(:,seas_ind.(seas{i_seas}));
                        rmsd=[];bias=[];willmottD=[];mae=[];
                        for i=1:length(holder(:,1))
                            ref=holder(i,:);
                            rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
                            bias(i,:)=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
                            mae(i,:)=nanmean(abs(ref-holder),2);%#ok
                            willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
                                                    
                            if hm_matrix
                                % correl(i,i:end)=nan;
                                bias(i,i:end)=nan;%#ok
                                mae(i,i:end)=nan;%#ok
                                rmsd(i,i:end)=nan;%#ok
                                willmottD(i,i:end)=nan;%#ok                
                            end            
                            
                        end
                        subplot(2,sub_cols,i_var);set(gca,'box','on');axis square
                        h=heatmap(willmottD,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));clim([0.5 1])
                        s=struct(h);s.XAxis.Visible='on';if hm_matrix, set(h,'grid','off');end
                        if i_var==1,ylabel('Willmott''s D');end
                        flds=string(1:length(holder(:,1)));fldbl = true(length(holder(:,1)),1);
                        if distinct_bl && i_var<=2
                            if i_var==1
                                fldbl([1:3 6:3:12])=false;
                            elseif i_var == 2                        
                                fldbl([1 9 18 27:27:108])=false;
                            end
                        else
                            if distinct_bl && vars{i_var}=="EF_All"
                                fldbl([1 9:9:36])=false;
                            else
                                fldbl([1 9 81 243:243:972])=false;
                            end
                        end
                        flds(fldbl) = '';
                        h.XDisplayLabels = flds;h.YDisplayLabels = flds;
                        title(strrep(vars{i_var},'_All',''));set(gca,'fontsize',16)
                            subplot(2,sub_cols,sub_cols + i_var);set(gca,'box','on');axis square
                            h=heatmap(mae,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));if vars{i_var}~="EF_All",clim([0 160]);else,clim([0 0.25]);end
                            s=struct(h);s.XAxis.Visible='on';if hm_matrix, set(h,'grid','off');end
                            if i_var==1,ylabel('MAE');end
                            flds=string(1:length(holder(:,1)));fldbl = true(length(holder(:,1)),1);
                            
                            if distinct_bl && i_var<=2
                                if i_var==1
                                    fldbl([1:3 6:3:12])=false;
                                elseif i_var == 2                        
                                    fldbl([1 9 18 27:27:108])=false;
                                end
                            else
                                if distinct_bl && vars{i_var}=="EF_All"
                                    fldbl([1 9:9:36])=false;
                                else
                                    fldbl([1 9 81 243:243:972])=false;
                                end
                            end
                            flds(fldbl) = '';
                            h.XDisplayLabels = flds;h.YDisplayLabels = flds;set(gca,'fontsize',16)
                            % keyboard
                    end
                end

        subplot(1,3,1);set(gca,'box','on');
        h=heatmap(bias,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
        if hm_matrix, set(h,'grid','off');end
        % s=struct(h);s.XAxis.Visible='off';
        ylabel('BIAS')
        flds=string(1:972);fldbl = true(972,1);fldbl([1 9 81 243:243:972])=false;
        flds(fldbl) = '';
        h.XDisplayLabels = flds;h.YDisplayLabels = flds;

        subplot(1,3,2);set(gca,'box','on');
%         h=heatmap(fields_et,fields_et,correl,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));%#ok
        h=heatmap(willmottD,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',flipud(jet(64)));%#ok
        s=struct(h);s.XAxis.Visible='off';if hm_matrix, set(h,'grid','off');end
        ylabel('Willmott''s D')
        flds=string(1:972);fldbl = true(972,1);fldbl([1 9 81 243:243:972])=false;
        flds(fldbl) = '';
        h.XDisplayLabels = flds;h.YDisplayLabels = flds;

        subplot(1,3,3);set(gca,'box','on');
        h=heatmap(rmsd,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
        ylabel('RMSD'); if hm_matrix, set(h,'grid','off');end
        flds=string(1:972);fldbl = true(972,1);fldbl([1 9 81 243:243:972])=false;
        flds(fldbl) = '';
        h.XDisplayLabels = flds;h.YDisplayLabels = flds;

        %% ALL LSTs
        figure        
        % correlation
        correl = corrcoef(ET_All_int,'rows','pairwise');
        lbl = {'AQUA 11','AQUA 21','TERRA 11','TERRA 21'};
        % rmsd / bias / willmott's D
        for i_=1:2
            if i_==1
                ET_All_int_ = ET_All';int_lbl = 'non-interpolated daily ET';
            else
                ET_All_int_ = ET_All_int;int_lbl = 'interpolated daily ET';
            end
            holder = ET_All_int_';rmsd=[];bias=[];willmottD=[];mae=[];
            for i=1:length(ET_All_int_(1,:))
                ref=holder(i,:);
                % rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
                % bias(i,:)=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
                mae(i,:)=nanmean(abs(ref-holder),2);%#ok
                % willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
                                        
                if hm_matrix
                    % correl(i,i:end)=nan;
                    % bias(i,i:end)=nan;%#ok
                    mae(i,i:end)=nan;%#ok
                    % rmsd(i,i:end)=nan;%#ok
                    % willmottD(i,i:end)=nan;%#ok                
                end
                
            end
            subplot(1,2,i_);set(gca,'box','on');
            h=heatmap(mae,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
            caxis([0 1])
            if hm_matrix, set(h,'grid','off');end
            % s=struct(h);s.XAxis.Visible='off';
            title(['MAE - ' int_lbl])
            flds=string(1:972);fldbl = true(972,1);fldbl([1 9 81 243:243:972])=false;
            flds(fldbl) = '';
            h.XDisplayLabels = flds;h.YDisplayLabels = flds;
        end


        %% per LST
        figure        
        % correlation
        correl = corrcoef(ET_All_int,'rows','pairwise');
        lbl = {'AQUA 11','AQUA 21','TERRA 11','TERRA 21'};
        % rmsd / bias / willmott's D
        for i_=1:4
            ET_All_int_ = ET_All_int(:,(1:243)+243*(i_-1));
            holder = ET_All_int_';rmsd=[];bias=[];willmottD=[];mae=[];
            for i=1:length(ET_All_int_(1,:))
                ref=holder(i,:);
                % rmsd(i,:)=sqrt(nanmean((ref-holder).^2,2));%#ok
                % bias(i,:)=-nanmean(ref-holder,2);%#ok % - to define it as est-ref
                mae(i,:)=nanmean(abs(ref-holder),2);%#ok
                % willmottD(i,:)=1 - nansum((ref-holder).^2,2)./nansum((abs(holder-nanmean(ref)) + abs(ref-nanmean(ref))).^2,2);%#ok
                                        
                if hm_matrix
                    % correl(i,i:end)=nan;
                    % bias(i,i:end)=nan;%#ok
                    mae(i,i:end)=nan;%#ok
                    % rmsd(i,i:end)=nan;%#ok
                    % willmottD(i,i:end)=nan;%#ok                
                end
                
            end
            subplot(2,2,i_);set(gca,'box','on');
            h=heatmap(mae,'celllabelcolor','none','missingdatacolor','white');set(gca,'colormap',jet(64));%#ok
            caxis([0 1])
            if hm_matrix, set(h,'grid','off');end
            % s=struct(h);s.XAxis.Visible='off';
            title(['MAE - ' lbl{i_}])
            flds=string(1:243);fldbl = true(243,1);fldbl([1 9 81:81:243])=false;
            flds(fldbl) = '';
            h.XDisplayLabels = flds;h.YDisplayLabels = flds;
        end


        %%
        addpath F:\RS_data\evaspa_mijn\Evaluation_Benchmarking\plots\LST_EMIS_MOD11_21
        LC={'All','Croplands','Forests','Grasslands'};
        flds_lc=[1 1 2 3 3 2 1 1 2 2 3 1]; % 1 - cropland 2 - forest 3 - grasslands
        
        figure
        for i=1:4
            evaspa_et = nanmean(holder);
            XxX = find(flds_lc==i-1);

            st_bool = false(6575,length(field_nm));
            st_bool(:,XxX) = true;
            st_bool = reshape(st_bool,[],1);
            evaspa_et(st_bool)=nan;
            
            corrYX = corrcoef(evaspa_et,ref,'rows','pairwise');

            subplot(2,2,i)
            axis('square')
            hold on;set(gca,'box','on')
            plot([-10 10],[-10 10],'k')
            dscatter_nu(ref,evaspa_et);%colorbar
            xlim([-1 10]);ylim([-1 10]);
            text(7,0,['R: ' num2str(round(corrYX(2),2))]);
            title(LC{i})
        end
                 

