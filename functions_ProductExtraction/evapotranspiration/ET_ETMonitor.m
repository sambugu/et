function ET_ETMonitor(indir,etmon_dir,outdir,ROIsites,extract_what)
    %% EXTRACT ETMonitor ET DATA
    %% ETMonitor daily 1km datasets

    fields = fieldnames(ROIsites);    
    
    etmon_dirs = dir([indir etmon_dir]);etmon_dirs={etmon_dirs(3:end).name};
    for i_etmonYR=1:length(etmon_dirs)
        
        % ETMonitor tiff files
        geotiffs=dir([indir etmon_dir '\' etmon_dirs{i_etmonYR} '\*.tif']);
        for i_flds=1:length(fields) %% extract for each ROI/site while reloading each .tiff --- not very efficient ! BUT we save on memory/RAM especially on large subsets
            
            ET.ET = []; ET.coord.lat = []; ET.coord.lon = []; ET.time = [];
            ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];

            for i=1:length(geotiffs)            
                
                [etmon_et,R]=geotiffread([geotiffs(i).folder '\' geotiffs(i).name]);%#ok        
             
                % approximate pixel coordinates
                if i==1
                    lat = fliplr(R.LatitudeLimits(1):(R.LatitudeLimits(2)-R.LatitudeLimits(1))/(length(etmon_et(:,1))-1):R.LatitudeLimits(2)); % flip to start from north southwards
                    lon = R.LongitudeLimits(1):(R.LongitudeLimits(2)-R.LongitudeLimits(1))/(length(etmon_et(1,:))-1):R.LongitudeLimits(2);
                end
            
                % for i_flds=1:length(fields)
                    switch extract_what
                        case 'area'
                            tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                            RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                            lat_ind = find(lat<=tOP & lat>=bTtm);
                            lon_ind = find(lon<=RigHT & lon>=leFT);
        
                            % decadal ET subset
                            et = etmon_et(lat_ind,lon_ind);
                            et = double(et)*0.01;et(et<0) = nan;
                            ET.ET = cat(3,ET.ET,et);clear et;
        
                            ET.coord.lat = lat(lat_ind);
                            ET.coord.lon = lon(lon_ind);
                            ET.time = [ET.time;geotiffs(i).name(end-15:end-9)];                    
                    end        
                clear etmon_et
            end
                   
            %% save subset struct per year
            switch extract_what
                case 'area'
                    out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\ETMonitor\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir 'ETMonitor_' etmon_dirs{i_etmonYR} '.mat'],'-struct','ET','-v7.3')
                case 'point'
                    out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\ETMonitor\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir 'ETMonitor_' etmon_dirs{i_etmonYR} '.mat'],'-struct','ET_pt','-v7.3')
            end
                         
        end

    end
    
end