function ET_SSEBop(indir,sebbop_dir,outdir,ROIsites,extract_what)
    %% EXTRACT SEBBop ET DATA
    %% SSEBop v5 - global decadal [10-day] datasets

    fields = fieldnames(ROIsites);
    
%     currdir = cd;
%     cd([indir sebbop_dir]);
%     geotiffs=dir('*.tif');
%     cd(currdir)
    geotiffs=dir([indir sebbop_dir '\*.tif']);

    yrs = 2003:2020; % SSEBop data availability
    i_yr=1;

    % subset to .mat
    save_now=false;

    ET_subset.ET = []; ET_subset.coord.lat = []; ET_subset.coord.lon = []; ET_subset.time = [];
    ET_pt.ET = []; ET_pt.coord.lat = []; ET_pt.coord.lon = []; ET_pt.time = [];%#ok

    for i_flds=1:length(fields) %% extract for each ROI/site while reloading each .tiff --- not very efficient ! BUT we save on memory/RAM especially on large subsets
        for i=1:length(geotiffs)
        
            try
                if ~contains(geotiffs(i).name(1:5),num2str(yrs(i_yr))),i_yr=i_yr+1;ET=ET_subset;ET_subset.ET=[];ET_subset.time=[];save_now=true;end
            catch
                return
            end
        
            [sebbop_et,R]=geotiffread([geotiffs(i).folder '\' geotiffs(i).name]);%#ok        
         
            % approximate pixel coordinates
            if i==1
                lat = fliplr(R.LatitudeLimits(1):(R.LatitudeLimits(2)-R.LatitudeLimits(1))/(length(sebbop_et(:,1))-1):R.LatitudeLimits(2)); % flip to start from north southwards
                lon = R.LongitudeLimits(1):(R.LongitudeLimits(2)-R.LongitudeLimits(1))/(length(sebbop_et(1,:))-1):R.LongitudeLimits(2);
            end
        
            % for i_flds=1:length(fields)
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                        RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
    
                        % decadal ET subset
                        et = sebbop_et(lat_ind,lon_ind);
                        et = double(et);et(et==255) = nan;
                        ET_subset.ET = cat(3,ET_subset.ET,et);clear et;
    
                        ET_subset.coord.lat = lat(lat_ind);
                        ET_subset.coord.lon = lon(lon_ind);
                        ET_subset.time = [ET_subset.time;geotiffs(i).name(6:8)];                    
                end
    
                if save_now   
                    %% save subset struct per year
%                     out_dir = [outdir '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\SSEBop_v5_decadal\'];
                    out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\SSEBop_v5_decadal\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr-1)) '.mat'],'-struct','ET','-v7.3')            
                    save_now = false;
                elseif i==length(geotiffs) 
                    ET = ET_subset; clear ET_subset
                    save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr)) '.mat'],'-struct','ET','-v7.3')
                end
    
        end
               
            % if save_now   
            %     %% save subset struct per year
            %     out_dir = [outdir '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\SSEBop_v5_decadal\'];
            %     if ~isfolder(out_dir), mkdir(out_dir),end
            %     save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr-1)) '.mat'],'-struct','ET','-v7.3')            
            %     save_now = false;
            % elseif i==length(geotiffs) 
            %     ET = ET_subset; clear ET_subset
            %     save([out_dir 'SEBBop_v5_' num2str(yrs(i_yr)) '.mat'],'-struct','ET','-v7.3')
            % end   
    end

end