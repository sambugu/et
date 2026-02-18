function ET_MERRA(indir,merra_dir,outdir,ROIsites,extract_what)
    %% EXTRACT MERRA ET DATA
    %% MERRA : 'EVAP - [kg m-2 s-1]' | 'EFLUX - [W m-2]'
    % NETCDF
    fields = fieldnames(ROIsites);
    merra_dirs = dir([indir merra_dir]);
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
                            le = nanmean(le,3)/28.4; %#ok for daily ave. latent energy converted to ET in mm/d                    
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
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' merra_dir '\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir '\' merra_ncfls(i).name(1:end-12) '.mat'],'-struct','ET')
                    case 'point'                        
                        out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\' merra_dir '\'];
                        if ~isfolder(out_dir), mkdir(out_dir),end
                        save([out_dir '\' merra_ncfls(i).name(1:end-12) '.mat'],'-struct','ET_pt')
            end
            clear ET_pt ET
        end
    end
        
end