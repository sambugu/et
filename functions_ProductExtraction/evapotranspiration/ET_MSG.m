function ET_MSG(indir,MSG_dir_var,outdir,ROIsites,extract_what)
    %% EXTRACT METEOSAT LAND-SAF [MSG] ET DATA
    %% MSG - ETa, ETref
    % NETCDF
    fields = fieldnames(ROIsites);
    msg_dir = MSG_dir_var.dir;
    msg_var = MSG_dir_var.var;
    for i_msgET=1:length(msg_dir)
        msg_dirs = dir([indir msg_dir{i_msgET}]); % msg_dir defined further up as 'MSG'
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
                            
                            msg_ET = squeeze(ncread([msg_ncfls(i_msgfls).folder '\' msg_ncfls(i_msgfls).name],char(msg_var(i_msgET))...
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
                            msg_ET = squeeze(ncread([msg_ncfls(i_msgfls).folder '\' msg_ncfls(i_msgfls).name],char(msg_var(i_msgET))...
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
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\MSG_' strrep(strrep(char(msg_dir(i_msgET)),'\NETCDF\',''),'MSG\','')];
                            if ~isfolder(out_dir), mkdir(out_dir),end
                            save([out_dir '\' msg_ncfls(i_msgfls).name(1:end-11)],'-struct','ET')
                        case 'point'                        
                            out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\MSG_' strrep(strrep(char(msg_dir(i_msgET)),'\NETCDF\',''),'MSG\','')];
                            if ~isfolder(out_dir), mkdir(out_dir),end
                            save([out_dir '\' msg_ncfls(i_msgfls).name(1:end-11)],'-struct','ET_pt')
                end
                clear ET_pt ET
            end
        end    
    end

end