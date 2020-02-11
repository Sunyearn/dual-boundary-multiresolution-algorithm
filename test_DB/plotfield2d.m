function plotfield2d(field2D,origion,Dx,Dy)
        figure;
        X = cumsum([origion(1); Dx]);
        Y = cumsum([origion(2);-Dy]);
        [yy,xx]=meshgrid(Y,X);
        pcolor(yy,xx,field2D)
%         contourf(yy,xx,field2D)
        colormap(jet);
        colorbar;
        shading('flat');
        xlabel('Easting(km)');
        ylabel('Northing(km)');
        title(['test cheva'])
end