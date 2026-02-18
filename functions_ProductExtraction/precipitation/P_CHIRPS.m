function P_CHIRPS(indir,chirps_dir,outdir,ROIsites,extract_what)
    %% EXTRACT CHIRPS Land Precip DATA - TOTAL P [mm]
    %% CHIRPS : DAILY P - Total Precip [mm]
    % NETCDF

    fields = fieldnames(ROIsites);
    
    dat_files = dir([indir chirps_dir]);
    for i = 3:length(dat_files)    
        for i_flds=1:length(fields)        
            % if str2num(dat_files(i).name(1:4))~=yrs(i),continue;end
            if contains([dat_files(i).folder '\' dat_files(i).name],'.nc')
                yr = dat_files(i).name(13:16);
                lat = ncread([dat_files(i).folder '\' dat_files(i).name],'latitude');
                lon = ncread([dat_files(i).folder '\' dat_files(i).name],'longitude');            
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'slhf' - daily LE
                        try
                            var = ncread([dat_files(i).folder '\' dat_files(i).name],'precip'...
                                ,[lon_ind(1) lat_ind(1) 1]...
                                ,[length(lon_ind) length(lat_ind) inf]);
                        catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                            var = squeeze(ncread([dat_files(i).folder '\' dat_files(i).name],'precip'...
                                ,[lon_ind(1) lat_ind(1) 1 1]...
                                ,[length(lon_ind) length(lat_ind) 1 inf]));
                        end
                        var(var<0) = nan;%precipitation(precipitation<=-999)=nan;
                        var = flipud(permute(var,[2 1 3]));
                        VAR.VAR = var;

                        VAR.coord.lat = lat(lat_ind);
                        VAR.coord.lon = lon(lon_ind);
                        VAR.time = ncread([dat_files(i).folder '\' dat_files(i).name],'time');
                        VAR.doy = 1:length(var(1,1,:));

                        % save subset struct
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\PPT_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\CHIRPS\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir 'CHIRPS_Precip_' ROIsites.(fields{i_flds}).subset_nm '_' yr],'-struct','VAR')

%                             if stasmask_bl
%                                 STAS_mask_rsz = imresize(STAS_mask,size(VAR.VAR(:,:,1)),'nearest');
%                                 VAR.VAR = STAS_mask_rsz.*VAR.VAR;
% 
%                                 STAS_mask_rsz = imresize(STAS_mask,[200 200],'nearest');
%                                 VAR.VAR_5km = STAS_mask_rsz.*imresize(VAR.VAR,[200 200],'nearest');
% 
%                                 out_dir = strrep(out_dir,'PPT','PPT_STAS');
%                                 if ~isfolder(out_dir), mkdir(out_dir),end
%                                 save([out_dir 'CHIRPS_Precip_' ROIsites.(fields{i_flds}).subset_nm '_' yr],'-struct','VAR')
%                             end

                        clear VAR
                    case 'point'
                        %%%
                end        
            end       
        end
    end
end
