function latlon=crop2aoi
    fig1=figure('name','World Map','Position',[20 20 1080/1.15 1080/2]);
    b = imagesc(nan(200,400));
    set(b,'alphadata',~isnan(nan(200,400)))
    set(gca,'YDir','normal')
    hold on
    load coastlines
    plot(coastlon+200,(coastlat+100),'k') % car imagesc only plots positives
        xticklabels = -200:20:200;
        xticks = linspace(1, 400, numel(xticklabels));
        set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)
        yticklabels = -100:20:100;
        yticks = linspace(1, 200, numel(yticklabels));
        set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
        
        xlabel('Longitude [°]');ylabel('Latitude [°]');
        
        title('DRAW YOUR AOI EXTENT BELOW (GLOBAL PRODUCTS ONLY !)')
        
    [I,rect]  = imcrop;%#ok
    TL_lon = rect(1);
    BR_lat = rect(2);
        TL_lat = BR_lat+rect(4);
        BR_lon = TL_lon+rect(3);

%         [TL_lon TL_lat BR_lon BR_lat]% 
%         [TL_lon-200 TL_lat-100 BR_lon-200 BR_lat-100]

%         latlon.TL_lon=TL_lon-200;
%         latlon.TL_lat=TL_lat-100;
%         latlon.BR_lon=BR_lon-200;
%         latlon.BR_lat=BR_lat-100;        
        
%         latlon{1} = 'dummy name';
        latlon{2}=TL_lat-100; % top
        latlon{3}=TL_lon-200; % left        
        latlon{4}=BR_lat-100; % bottom
        latlon{5}=BR_lon-200; % right
        
        close(fig1)
end  
    
    
    