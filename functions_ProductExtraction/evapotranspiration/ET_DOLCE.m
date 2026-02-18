function ET_DOLCE(indir,dolce_dir,outdir,ROIsites,extract_what)
    %% EXTRACT DOLCE ET DATA
    %% DOLCE : MONTHLY ET [W.m-2]
    % NETCDF
    fields = fieldnames(ROIsites);
    for i_dlc=1:length(dolce_dir)
        DOLCE_files = dir([indir dolce_dir{i_dlc}]);
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
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' dolce_dir{i_dlc}];
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
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\' dolce_dir dolce_dir{i_dlc}];
                            if ~isfolder(out_dir), mkdir(out_dir),end
                            save(strrep([out_dir DOLCE_files(i).name],'.nc','.mat'),'-struct','ET_pt')
                            clear ET_pt
                    end        
                end
            end
        end
    end
    
end