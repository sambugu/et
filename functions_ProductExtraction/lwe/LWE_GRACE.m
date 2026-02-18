function LWE_GRACE(indir,grace_dir,outdir,ROIsites,extract_what)
    %% GRACE - LWE [liquid water equivalent]
    % https://podaac.jpl.nasa.gov/GRACE?tab=mission-objectives&sections=about%2Bdata
    % https://web.archive.org/web/20230601124027/https://podaac.jpl.nasa.gov/GRACE?tab=mission-objectives&sections=about%2Bdata
    
    fields = fieldnames(ROIsites);

    for i_pdct=1:length(grace_dir)
        dat_files = dir([indir grace_dir{i_pdct} '\NC\']);    
        for i_flds=1:length(fields)
            VAR.VAR = [];VAR.Time=[];VAR.Day=[];VAR.Month=[];VAR.Year=[];
            for i = 3:length(dat_files)
                if ~contains([dat_files(i).folder '\' dat_files(i).name],'.nc'),continue;end
                lat = ncread([dat_files(i).folder '\' dat_files(i).name],'lat');
                lon = ncread([dat_files(i).folder '\' dat_files(i).name],'lon');
                switch extract_what
                    case 'area'
                        tOP=ROIsites.(fields{i_flds}).tOP;bTtm=ROIsites.(fields{i_flds}).bTtm;
                        RigHT=ROIsites.(fields{i_flds}).RigHT;leFT=ROIsites.(fields{i_flds}).leFT;
                        lat_ind = find(lat<=tOP & lat>=bTtm);
                        lon_ind = find(lon<=RigHT & lon>=leFT);
                        % total ET - denoted 'slhf' - daily LE                    
                        var = ncread([dat_files(i).folder '\' dat_files(i).name],'lwe_thickness'...
                            ,[lon_ind(1) lat_ind(1) 1]...
                            ,[length(lon_ind) length(lat_ind) inf]);
                        var = flip(var')*1000; % *1000 m to mm
                        VAR.VAR = cat(3,VAR.VAR,var);
                        VAR.coord.lat = lat(lat_ind);
                        VAR.coord.lon = lon(lon_ind);
                        Time = round(ncread([dat_files(i).folder '\' dat_files(i).name],'time')); % round incase 'time' is decimal
                        VAR.Time = [VAR.Time;Time]; % 'days since 2002-01-01T00:00:00'
                        VAR.Day = [VAR.Day;day(datetime(2002,1,Time),'dayofyear')];
                        VAR.Month = [VAR.Month;month(datetime(2002,1,Time))];
                        VAR.Year = [VAR.Year;year(datetime(2002,1,Time))];
                    case 'point'
                        %%%
                end
            end
            % keyboard
            %% SAVE
            switch extract_what
                case 'area'
                    % save subset struct
                    out_dir = [outdir ROIsites.(fields{i_flds}).subset_nm '\' extract_what '\LWE_subset_' ROIsites.(fields{i_flds}).subset_nm '\GRACE\'];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save([out_dir 'GRACE_LWE_' grace_dir{i_pdct} '_' ROIsites.(fields{i_flds}).subset_nm '_2002-' num2str(year(datetime(2002,1,Time)))],'-struct','VAR')
                    clear VAR
                case 'point'
                    %%%
            end
        end
    end

end