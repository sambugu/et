function ET_FLUXCOM(indir,FCOM_dir_RSnRS_METEO,outdir,ROIsites,extract_what)
    %% EXTRACT FLUXCOM ET DATA
    %% FLUXCOM %% NOTE : FLUXCOM data is in MJ/m2/d >> /2.45 to convert to mm/d
    % RS && RS_METEO - %% [NOT future-proof] indices below only specific to these versions - as of 071123
    % NETCDF
    fields = fieldnames(ROIsites);
    for ifxcm=1:length(FCOM_dir_RSnRS_METEO) % RS & RS_METEO    
        nc_files = dir([indir char(FCOM_dir_RSnRS_METEO(ifxcm))]);
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
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' strrep(nc_files(i).folder,indir,'')];
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
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\' strrep(nc_files(i).folder,indir,'')];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save(strrep([out_dir '\' nc_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                        clear ET_pt
                end
            end
        end
    end

end