function ET_CAMELE(indir,camele_dir,outdir,ROIsites,extract_what)
    %% EXTRACT CAMELE ET DATA
    % 0.1 & 0.25 res
    % NETCDF
    fields = fieldnames(ROIsites);
    camele_ncfls = dir([indir camele_dir]);
    for i=3:length(camele_ncfls)
        if ~contains(camele_ncfls(i).name,'.nc'), continue; end
        if contains(camele_ncfls(i).name,'.01.'),res_dir='\01\';else,res_dir='\025\';end
        % total ET - denoted 'ET'
        lat = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'lat');
        lon = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'lon');
    
        for i_flds=1:length(fields)
            switch extract_what
                case 'area'
                    tOP=ROIsites.(char(fields(i_flds))).tOP;bTtm=ROIsites.(char(fields(i_flds))).bTtm;
                    RigHT=ROIsites.(char(fields(i_flds))).RigHT;leFT=ROIsites.(char(fields(i_flds))).leFT;
                    lat_ind = find(lat<=tOP & lat>=bTtm);
                    lon_ind = find(lon<=RigHT & lon>=leFT);
                %     if length(lat)==1500, coord = coord01; else, coord = coord025; end
                    ET.ET = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'ET'...
                        ,[lat_ind(1) lon_ind(1) 1]...
                        ,[length(lat_ind) length(lon_ind) inf]);    
                    ET.coord.lat = lat(lat_ind);
                    ET.coord.lon = lon(lon_ind);
                    ET.time = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'day');
                    
                    % save subset struct
                    out_dir = [outdir ROIsites.(char(fields(i_flds))).subset_nm '\' extract_what '\ET_subset_' ROIsites.(char(fields(i_flds))).subset_nm '\' camele_dir res_dir];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir camele_ncfls(i).name],'.nc','.mat'),'-struct','ET')
                    clear ET
                case 'point'
                    pt_lat_ind = find(ROIsites.(char(fields(i_flds))).lat_pt >= lat,1,'first');
                    pt_lon_ind = find(ROIsites.(char(fields(i_flds))).lon_pt >= lon,1,'last');
                    ET_pt.ET = squeeze(ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'ET'...
                        ,[pt_lat_ind(1) pt_lon_ind(1) 1]...
                        ,[length(pt_lat_ind) length(pt_lon_ind) inf]));    
                    ET_pt.coord.lat = lat(pt_lat_ind);
                    ET_pt.coord.lon = lon(pt_lon_ind);
                    ET_pt.time = ncread([camele_ncfls(i).folder '\' camele_ncfls(i).name],'day');
                    % save subset struct
                    out_dir = [outdir ROIsites.(char(fields(i_flds))).site_nm '\' extract_what '\ET_' ROIsites.(char(fields(i_flds))).site_nm '\' camele_dir res_dir];
                    if ~isfolder(out_dir), mkdir(out_dir),end
                    save(strrep([out_dir camele_ncfls(i).name],'.nc','.mat'),'-struct','ET_pt')
                    clear ET_pt
            end
        end
    end
    
end