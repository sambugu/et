function ET_ERA5(indir,era5_et_dir,outdir,ROIsites,extract_what)
    %% EXTRACT ERA5 ET DATA
    %% ERA5 : DAILY ET - Total Evap [m]
    % NETCDF
    fields = fieldnames(ROIsites);
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
                        e = squeeze(nansum(reshape(e,size(e,1),size(e,2),24,[]),3)); %#ok
                        ET.ET = -e*1000;clear e %*1000 m to mm % -e : "Therefore, negative values indicate evaporation and positive values indicate condensation." - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=overview
                        
                        ET.coord.lat = lat(lat_ind);
                        ET.coord.lon = lon(lon_ind);
                        ET.time = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'time');
    
                        % save subset struct
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\ERA5\'];
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
                        e = nanmean(reshape(e,24,[])); %#ok
                        ET_pt.ET = -e*1000;clear e %*1000 m to mm % -e : "Therefore, negative values indicate evaporation and positive values indicate condensation." - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=overview
    
                        ET_pt.coord.lat = lat(pt_lat_ind);
                        ET_pt.coord.lon = lon(pt_lon_ind);
                        ET_pt.time = ncread([ERA5_files(i).folder '\' ERA5_files(i).name],'time');
    
                        % save point struct
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\ERA5\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save(strrep([out_dir ERA5_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                        clear ET_pt
                end        
            end
        end
    end
    
end