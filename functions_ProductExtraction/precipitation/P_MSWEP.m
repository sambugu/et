function P_MSWEP(indir,mswep_dir,outdir,ROIsites,extract_what)
    %% EXTRACT MSWEP Precip DATA
    %% MSWEP : DAILY P - Total Precip [mm]
    % NETCDF

    fields = fieldnames(ROIsites);
    
    yrs = 1979:2023;
    dat_files_ALLYRS = dir([mswep_dir]);%dir([indir mswep_dir]); %% MSWEP data not contained in the same indir folder as other precipitation data
    for i_yr = 1:length(yrs)
        dat_files = dat_files_ALLYRS(contains({dat_files_ALLYRS.name},num2str(yrs(i_yr))));
        for i_flds=1:length(fields)
            VAR.VAR = []; VAR.doy = [];
            for i=3:length(dat_files)
                if str2num(dat_files(i).name(1:4))~=yrs(i_yr),continue;end
                if contains([dat_files(i).folder '\' dat_files(i).name],'.nc')
                    lat = ncread([dat_files(i).folder '\' dat_files(i).name],'lat');
                    lon = ncread([dat_files(i).folder '\' dat_files(i).name],'lon');

                    switch extract_what
                        case 'area'
                            tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                            RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                            lat_ind = find(lat<=tOP & lat>=bTtm);
                            lon_ind = find(lon<=RigHT & lon>=leFT);
                            % total ET - denoted 'slhf' - daily LE
                            try
                                var = ncread([dat_files(i).folder '\' dat_files(i).name],'precipitation'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);
                            catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                                var = squeeze(ncread([dat_files(i).folder '\' dat_files(i).name],'precipitation'...
                                    ,[lon_ind(1) lat_ind(1) 1 1]...
                                    ,[length(lon_ind) length(lat_ind) 1 inf]));
                            end
                            var(var<0) = nan;%precipitation(precipitation<=-999)=nan;
                            var = var';
                            VAR.VAR = cat(3,VAR.VAR,var);

                            VAR.coord.lat = lat(lat_ind);
                            VAR.coord.lon = lon(lon_ind);
                            VAR.time = ncread([dat_files(i).folder '\' dat_files(i).name],'time');
                            VAR.doy = [VAR.doy;str2num(dat_files(i).name(5:7))];

    % % %                             % save subset struct
    % % %                             out_dir = ['ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\MSWEP\'];
    % % %                             if ~isfolder(out_dir), mkdir(out_dir),end
    % % %                             save(strrep([out_dir dat_files(i).name],'.nc','.mat'),'-struct','VAR')
    % % %                             clear VAR
                        case 'point'
                            %%%
                    end        
                end
            end
            % save subset struct
            switch extract_what
                case 'area'
                    % save subset struct
                    out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\PPT_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\MSWEP\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir 'MSWEP_Precip_' ROIsites.(fields{i_flds}).subset_nm '_' num2str(yrs(i_yr))],'-struct','VAR')

%                         if stasmask_bl
%                             STAS_mask_rsz = imresize(STAS_mask,size(VAR.VAR(:,:,1)),'nearest');
%                             VAR.VAR = STAS_mask_rsz.*VAR.VAR;
% 
%                             STAS_mask_rsz = imresize(STAS_mask,[200 200],'nearest');
%                             VAR.VAR_5km = STAS_mask_rsz.*imresize(VAR.VAR,[200 200],'nearest');
% 
%                             out_dir = strrep(out_dir,'PPT','PPT_STAS');
%                             if ~isfolder(out_dir), mkdir(out_dir),end
%                             save([out_dir 'MSWEP_Precip_' ROIsites.(fields{i_flds}).subset_nm '_' num2str(yrs(i_yr))],'-struct','VAR')
%                         end

                    clear VAR
                case 'point'
                    %%%
            end
        end
    end
end