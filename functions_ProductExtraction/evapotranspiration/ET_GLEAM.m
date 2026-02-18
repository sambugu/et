function ET_GLEAM(indir,glm_dir,outdir,ROIsites,extract_what)
    %% EXTRACT GLEAM ET DATA
    %% v3.7b && v3.8a %% [NOT future-proof] indices below only specific to these versions - as of 071123
    % NETCDF
    fields = fieldnames(ROIsites);
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
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\GLEAM\' glm_dirs(i).name '\daily\'];
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
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\GLEAM\' glm_dirs(i).name '\daily\'];
                            if ~isfolder(out_dir), mkdir(out_dir),end
                            save(strrep([out_dir '\' nc_files(3).name],'.nc','.mat'),'-struct','ET_pt')
                            clear ET_pt
                    end        
                end
            end
        end
    end
end