% sur le pont d'avignon -ufu-

function Extract_Generic(dat)

%% directories
pdct_dir = dat.pdct_dir;

%% CUSTOM EXTRACTION : SUBSET OR POINT
% LWEPouET = questdlg('What variable do you want to extract ?','LWE, Precipitation or Evapotranspiration ?','LWE','EVAPOTRANSPIRATION','PRECIPITATION','EVAPOTRANSPIRATION');
LWEPPTET = {'LWE';'EVAPOTRANSPIRATION';'PRECIPITATION'};
[extract_LWEPouET,~] = listdlg('name','Variable to extract ? LWE, Precipitation or Evapotranspiration ?','listsize',[500 200],'liststring',LWEPPTET);
for i_lpe=extract_LWEPouET
    LWEPouET=LWEPPTET{i_lpe};
    switch lower(LWEPouET)
        case 'lwe'
    
                        %% LWE functions
                        LWE_fxns = what('lwe');
                        LWE_fxns = LWE_fxns.m;
                        LWE_fxns = strrep(LWE_fxns,'.m','');
                        LWE_pdcts = strrep(LWE_fxns,'LWE_','');
    
            %% other options
            if extract_LWEPouET(1) == i_lpe
                outdir=uigetdir(dat.outdir,'Extracted Output Directory');
        
                extract_what = questdlg('What to extract ?','Point or Area ?','area','point','area');
                [latlon,ROIsites] = extract_WHAT(extract_what);
            end
            [extract_me,~] = listdlg('name','Select Product[s] [LWE]','listsize',[300 200],'liststring',LWE_pdcts);
            extract_ME.([lower(LWEPouET)]) = extract_me;
            indir=uigetdir(dat.indir.lwe,['Input Data Directory [LWE] : e.g. for GRACE, where CSR_TELLUS_L3, GFZ_TELLUS ... folders are located']);%#ok            
            extract_ME.indir.([lower(LWEPouET)])=indir;

        case 'precipitation'
    
                        %% PPT functions
                        PPT_fxns = what('precipitation');
                        PPT_fxns = PPT_fxns.m;
                        PPT_fxns = strrep(PPT_fxns,'.m','');
                        PPT_pdcts = strrep(PPT_fxns,'P_','');

            %% other options
            if extract_LWEPouET(1) == i_lpe
                outdir=uigetdir(dat.outdir,'Extracted Output Directory');
        
                extract_what = questdlg('What to extract ?','Point or Area ?','area','point','area');
                [latlon,ROIsites] = extract_WHAT(extract_what);
            end
            [extract_me,~] = listdlg('name','Select Product[s] [PPT]','listsize',[300 200],'liststring',PPT_pdcts);
            extract_ME.([lower(LWEPouET)]) = extract_me;
            indir=uigetdir(dat.indir.ppt,'Input Data Directory [Precipitation]');
            extract_ME.indir.([lower(LWEPouET)])=indir;            

        case 'evapotranspiration'
    
                        %% ET functions
                        ET_fxns = what('evapotranspiration');
                        ET_fxns = ET_fxns.m;
                        ET_fxns = strrep(ET_fxns,'.m','');
                        ET_pdcts = strrep(ET_fxns,'ET_','');
                        
            %% other options
            if extract_LWEPouET(1) == i_lpe
                outdir=uigetdir(dat.outdir,'Extracted Output Directory');
        
                extract_what = questdlg('What to extract ?','Point or Area ?','area','point','area');
                [latlon,ROIsites] = extract_WHAT(extract_what);
            end
            [extract_me,~] = listdlg('name','Select Product[s] [ET]','listsize',[300 200],'liststring',ET_pdcts);
            extract_ME.([lower(LWEPouET)]) = extract_me;
            indir=uigetdir(dat.indir.et,'Input Data Directory [Evapotranspiration]');
            extract_ME.indir.([lower(LWEPouET)])=indir;
    
    end
end

%% EXTRACTION
for i_lpe=extract_LWEPouET
    LWEPouET=LWEPPTET{i_lpe};
    extract_me = extract_ME.([lower(LWEPouET)]);
    indir=extract_ME.indir.([lower(LWEPouET)]);
    switch lower(LWEPouET)
        case 'lwe'           
            for i_fxn = extract_me
                if ~ischar(indir) || ~ischar(outdir),errordlg('Please select the root INPUT and/or OUTPUT folder[s]');return;end
                LWE_fxn = eval(['@' LWE_fxns{i_fxn}]);
                % keyboard    
                LWE_fxn([indir '\'],pdct_dir.lwe.(LWE_pdcts{i_fxn}),[outdir '\'],ROIsites,extract_what);
            end
            try
                save([outdir '\LWE_' latlon{1} '\' extract_what '\ROIsites'],'ROIsites')
            catch
                try
                    save([outdir '\' latlon{1} '\' extract_what '\LWE_subset_' latlon{1} '\ROIsites'],'ROIsites')
                catch
                    save([outdir '\LWE_subset_' latlon{1} '\' extract_what '\ROIsites'],'ROIsites')
                end
            end
    
        case 'precipitation'
            for i_fxn = extract_me
                if ~ischar(indir) || ~ischar(outdir),errordlg('Please select the root INPUT and/or OUTPUT folder[s]');return;end
                PPT_fxn = eval(['@' PPT_fxns{i_fxn}]);
            %     keyboard    
                PPT_fxn([indir '\'],pdct_dir.ppt.(PPT_pdcts{i_fxn}),[outdir '\'],ROIsites,extract_what);
            end
            try
                save([outdir '\PPT_' latlon{1} '\' extract_what '\ROIsites'],'ROIsites')
            catch
                try
                    save([outdir '\' latlon{1} '\' extract_what '\PPT_subset_' latlon{1} '\ROIsites'],'ROIsites')
                catch
                    save([outdir '\PPT_subset_' latlon{1} '\' extract_what '\ROIsites'],'ROIsites')
                end
            end

        case 'evapotranspiration'  
            for i_fxn = extract_me
                if ~ischar(indir) || ~ischar(outdir),errordlg('Please select the root INPUT and/or OUTPUT folder[s]');return;end
                ET_fxn = eval(['@' ET_fxns{i_fxn}]);
                % keyboard    
                ET_fxn([indir '\'],pdct_dir.le.(ET_pdcts{i_fxn}),[outdir '\'],ROIsites,extract_what);
            end
            try
                save([outdir '\ET_' latlon{1} '\' extract_what '\ROIsites'],'ROIsites')
            catch
                try
                    save([outdir '\' latlon{1} '\' extract_what '\ET_subset_' latlon{1} '\ROIsites'],'ROIsites')
                catch
                    save([outdir '\ET_subset_' latlon{1} '\' extract_what '\ROIsites'],'ROIsites')
                end
            end
    end
end
% keyboard
return

function [latlon,ROIsites] = extract_WHAT(extract_what)
    switch extract_what
        case 'area'
            input_method = questdlg('Input top-left/bottom-right latlon manually, draw AOI OR load coordinates ?','Input, Crop  OR Load ?','Manual','Crop','Load','Manual');
            switch input_method
                case 'Manual'
                    latlon = inputdlg({'AOI Name : ','Latitude [TOP] : ','Longitude [LEFT] : ','Latitude [BOTTOM] : ','Longitude [RIGHT] : '},'Site name & Co-ordinates',[1 70],{'SouthFrance','51.5','-4.5','42.5','7.5'});
                    % latlon{1} = strrep(latlon{1},' ','_');latlon{1} = strrep(latlon{1},'-','_');
                    latlon{2} = str2num(latlon{2}); latlon{3} = str2num(latlon{3});%#ok
                    latlon{4} = str2num(latlon{4}); latlon{5} = str2num(latlon{5});%#ok
                    latlon=latlon';
                case 'Crop'
                    latlon = crop2aoi;
                    latlon{1} = inputdlg({'AOI Name : '},'Site Name',[1 70],{'SouthFrance'});                            
                    latlon{1} = latlon{1}{1};
                case 'Load'
                    [ROI_file,ROI_path] = uigetfile('\\147.100.1.28\Projects\esa_lstm_2019_2020_2021_2022\EVASPA_mwangis\Evaluation_Benchmarking\ET_extracts\functions_ProductExtraction\ROI_coord.txt'...
                        ,'Select your ROI_coord file');
                    ROIs=table2cell(readtable([ROI_path ROI_file]));
                    latlon = ROIs(1:end-1,:); % last row is a comment
            end                    
            % input vars
            for i_st = 1:size(latlon,1)
                latlon_st = latlon(i_st,:);
                latlon_st{1} = strrep(latlon_st{1},' ','_');latlon_st{1} = strrep(latlon_st{1},'-','_');
                ROIsites.(latlon_st{1}).subset_nm = latlon_st{1};
                ROIsites.(latlon_st{1}).tOP = latlon_st{2};
                ROIsites.(latlon_st{1}).leFT = latlon_st{3};
                ROIsites.(latlon_st{1}).bTtm = latlon_st{4};
                ROIsites.(latlon_st{1}).RigHT = latlon_st{5};
            end
        case 'point'
            latlon = inputdlg({'AOI Name : ','Latitude : ','Longitude : '},'Site Name & Co-ordinates',[1 70],{'SouthFrance','43','2'});
            latlon{1} = strrep(latlon{1},' ','_');latlon{1} = strrep(latlon{1},'-','_');
            latlon{2} = str2num(latlon{2}); latlon{3} = str2num(latlon{3});%#ok
    end
return

%%% -ufu-