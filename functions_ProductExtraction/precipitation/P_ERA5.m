function P_ERA5(indir,era5_dir,outdir,ROIsites,extract_what)
    %% EXTRACT ERA5 Precip DATA
    %% ERA5 : DAILY P - Total Precip [m]
    % NETCDF

    fields = fieldnames(ROIsites);
    
    ly=@(yr)~rem(yr,400)|(rem(yr,100)&~rem(yr,4));
    dat_files = dir([indir era5_dir]);
    for i=3:length(dat_files)
        if contains([dat_files(i).folder '\' dat_files(i).name],'.nc')
            lat = ncread([dat_files(i).folder '\' dat_files(i).name],'latitude');
            lon = ncread([dat_files(i).folder '\' dat_files(i).name],'longitude');
            for i_flds=1:length(fields)
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'slhf' - daily LE
                        try
                            var = ncread([dat_files(i).folder '\' dat_files(i).name],'tp'...
                                ,[lon_ind(1) lat_ind(1) 1]...
                                ,[length(lon_ind) length(lat_ind) inf]);
                        catch %% 'ERA5_ET_FR_2018-2023.nc' is 4D !
                            var = squeeze(ncread([dat_files(i).folder '\' dat_files(i).name],'tp'...
                                ,[lon_ind(1) lat_ind(1) 1 1]...
                                ,[length(lon_ind) length(lat_ind) 1 inf]));
                        end
                        var(var<0) = nan;%le(le<=-999)=nan;
                        var = permute(var,[2 1 3]); %% rotate/re-orient LE array
                        var = squeeze(nansum(reshape(var,size(var,1),size(var,2),24,[]),3));                    
    %                     var = squeeze(nanmean(reshape(var,size(var,1),size(var,2),24,[]),3));
                        yrs = str2num(dat_files(i).name(end-11:end-8)):str2num(dat_files(i).name(end-6:end-3));
                        yrs_ = [0 cumsum(365+ly(yrs))];
                        % keyboard
                        for i_yr=1:length(yrs)
                            VAR.VAR = var(:,:,yrs_(i_yr)+1:yrs_(i_yr+1))*1000; %*1000 m to mm %

                            VAR.coord.lat = lat(lat_ind);
                            VAR.coord.lon = lon(lon_ind);
                            VAR.time = ncread([dat_files(i).folder '\' dat_files(i).name],'time');
                            VAR.doy = 1:length(VAR.VAR(1,1,:));

                            % save subset struct
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\PPT_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\ERA5\'];
                            if ~isfolder(out_dir), mkdir(out_dir),end
                            save([out_dir 'ERA5_Precip_' ROIsites.(fields{i_flds}).subset_nm '_' num2str(yrs(i_yr))],'-struct','VAR')

%                                 if stasmask_bl
%                                     STAS_mask_rsz = imresize(STAS_mask,size(VAR.VAR(:,:,1)),'nearest');
%                                     VAR.VAR = STAS_mask_rsz.*VAR.VAR;
% 
%                                     STAS_mask_rsz = imresize(STAS_mask,[200 200],'nearest');
%                                     VAR.VAR_5km = STAS_mask_rsz.*imresize(VAR.VAR,[200 200],'nearest');
% 
%                                     out_dir = strrep(out_dir,'PPT','PPT_STAS');
%                                     if ~isfolder(out_dir), mkdir(out_dir),end
%                                     save([out_dir 'ERA5_Precip_' ROIsites.(fields{i_flds}).subset_nm '_' num2str(yrs(i_yr))],'-struct','VAR')
%                                 end

                            clear VAR
                        end
                    case 'point'
                        %%%,,,
                end        
            end
        end
    end

end