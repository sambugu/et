function ET_GLDAS_NOAH(indir,gldasnoah_dir,outdir,ROIsites,extract_what)
    %% EXTRACT GLDAS_NOAH ET DATA
    %% GLDAS NOAH025 : ''Evap_tavg' - [kg m-2 s-1]' | 'Qle_tavg - [W m-2]' - every 3 hrs
    fields = fieldnames(ROIsites);
    gldas_dirs = dir([indir gldasnoah_dir]); % gldasclsm_dir defined further up as 'GLDAS_CLSM025'    
    for i_gldasYR=3:length(gldas_dirs)
        if ~isfolder([gldas_dirs(i_gldasYR).folder '\' gldas_dirs(i_gldasYR).name]), continue; end
        gldas_ncfls = dir([gldas_dirs(i_gldasYR).folder '\' gldas_dirs(i_gldasYR).name]);
        gldas_fls = {gldas_ncfls(3:end).name};gldas_fls = gldas_fls(contains(gldas_fls,'.1200.021.nc4'));
        for i_flds=1:length(fields)
            ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
            ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];
            for i=1:length(gldas_fls)
                if contains([gldas_ncfls(i).folder '\' gldas_fls{i}],'.nc4')
                    
                    lat = ncread([gldas_ncfls(1).folder '\' gldas_fls{i}],'lat');
                    lon = ncread([gldas_ncfls(1).folder '\' gldas_fls{i}],'lon');
            
                    switch extract_what
                        case 'area'
                            tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                            RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                            lat_ind = find(lat<=tOP & lat>=bTtm);
                            lon_ind = find(lon<=RigHT & lon>=leFT);
                            % total ET - denoted 'ET' - monthly ET from 1980
                            try % latent flux from 00-21 hrs in 3 hr timesteps
                                % le00 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.0000.021.nc4')],'Qle_tavg'...
                                %     ,[lon_ind(1) lat_ind(1) 1]...
                                %     ,[length(lon_ind) length(lat_ind) inf]);le00 = flipud(le00'); %% rotate/re-orient array 
                                le03 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.0300.021.nc4')],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le03 = flipud(le03'); %% rotate/re-orient array 
                                le06 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.0600.021.nc4')],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le06 = flipud(le06'); %% rotate/re-orient array 
                                le09 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.0900.021.nc4')],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le09 = flipud(le09'); %% rotate/re-orient array 
                                le12 = ncread([gldas_ncfls(1).folder '\' gldas_fls{i}],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le12 = flipud(le12'); %% rotate/re-orient array 
                                le15 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.1500.021.nc4')],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le15 = flipud(le15'); %% rotate/re-orient array 
                                le18 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.1800.021.nc4')],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le18 = flipud(le18'); %% rotate/re-orient array 
                                le21 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.2100.021.nc4')],'Qle_tavg'...
                                    ,[lon_ind(1) lat_ind(1) 1]...
                                    ,[length(lon_ind) length(lat_ind) inf]);le21 = flipud(le21'); %% rotate/re-orient array
                                try % works upto last day of the current year
                                    hr0000 = strrep(gldas_fls{i},'.1200.021.nc4','.0000.021.nc4');
                                    yyyy = str2num(hr0000(end-20:end-17));mm = str2num(hr0000(end-16:end-15));dd = str2num(hr0000(end-14:end-13));
                                    tm = datetime(yyyy,mm,dd+1); dd = day(tm); mm = month(tm);
                                    hr0000 = strrep(hr0000,hr0000(end-20:end-13),num2str(yyyy*10000 + mm*100 + dd));
                                    le00 = ncread([gldas_ncfls(1).folder '\' hr0000],'Qle_tavg'...
                                        ,[lon_ind(1) lat_ind(1) 1]...
                                        ,[length(lon_ind) length(lat_ind) inf]);le00 = flipud(le00'); %% rotate/re-orient array
                                catch
                                    le00 = ncread([gldas_ncfls(1).folder '\' strrep(gldas_fls{i},'.1200.021.nc4','.0000.021.nc4')],'Qle_tavg'...
                                        ,[lon_ind(1) lat_ind(1) 1]...
                                        ,[length(lon_ind) length(lat_ind) inf]);le00 = flipud(le00'); %% rotate/re-orient array
                                end
                            catch
                                continue
                            end

                            le = cat(3,le03,le06,le09,le12,le15,le18,le21,le00);clear le00 le03 le06 le09 le12 le15 le18 le21
                            le(le==-9999) = nan;
                            le = nanmean(le,3);
                            le = le/28.4; % for daily ave. latent energy converted to ET in mm/d                    
                            
                            ET.ET = cat(3,ET.ET,le);clear le;
                            
                            ET.coord.lat = flipud(lat(lat_ind)); % flip to start from north southwards
                            ET.coord.lon = lon(lon_ind);
                            ET.time = [ET.time;gldas_fls{i}(end-20:end-13)];                        
        
                        case 'point'
                            pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                            pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                            % Point total ET - denoted 'ET' - monthly ET from 1982-2018
                            ET_pt.ET = squeeze(ncread([gldas_ncfls(i).folder '\' gldas_fls{i}],'Qle_tavg'...
                                ,[pt_lon_ind(1) pt_lat_ind(1) 1]...
                                ,[length(pt_lon_ind) length(pt_lat_ind) inf]));
                            ET_pt.ET = ET_pt.ET/28.4; % for daily ave. latent energy converted to ET in mm/d 
                            
                            ET_pt.coord.lat = lat(pt_lat_ind);
                            ET_pt.coord.lon = lon(pt_lon_ind);
                            ET_pt.time = [ET.time;gldas_fls{i}(end-20:end-13)];%ncread([gldas_ncfls(i).folder '\' gldas_ncfls(i).name],'time');
                    end        
            
                end
            end
            % save subset struct
            switch extract_what
                    case 'area'
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' gldasnoah_dir '\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir '\' gldas_fls{i}(1:end-17) '.mat'],'-struct','ET')
                    case 'point'                        
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\' gldasnoah_dir '\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir '\' gldas_fls{i}(1:end-17) '.mat'],'-struct','ET_pt')
            end
            clear ET_pt ET
        end
    end
    
end