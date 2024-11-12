% Cargar los datos desde un archivo CSV
disp('Cargando datos desde el archivo CSV...');
df = readtable('NARCOTRAFICO.csv'); % Cambia el nombre del archivo si es necesario
disp('Datos cargados correctamente.');

% Variables de latitud, longitud y cantidad
latitudes = df.LATITUD;
longitudes = df.LONGITUD;
cantidad_crimenes = df.CANTIDAD;
meses = df.MES;

disp('Variables cargadas: Latitudes, Longitudes, Cantidad de crímenes, Meses.');

% Convertir 'MES' al formato de fecha y extraer año y mes
disp('Convirtiendo los meses a formato de fecha...');
fechas = datetime(meses, 'InputFormat', 'yyyy-MM');
meses = month(fechas);
anios = year(fechas);
disp('Meses convertidos correctamente.');

% Crear carpeta de salida para guardar los gráficos
output_folder = 'graficos_por_mes';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Generar gráficos para cada mes y  año disponible en los datos
fecha_inicio = datetime(2013, 2, 1);
fechas_filtradas = fechas(fechas >= fecha_inicio);
fechas_unicas = unique(fechas_filtradas);

% Paso 1: Agregar puntos ficticios en las esquinas del mapa
corner_lats = [lat_min, lat_min, lat_max, lat_max];
corner_lons = [long_min, long_max, long_min, long_max];
corner_crimes = [0,0,0,0]; % Usar 0 delitos en las esquinas

for fecha = fechas_unicas'
    mes_filtrar = month(fecha);
    anio_filtrar = year(fecha);

    % Filtrar los datos para el mes y año actuales
    idx_filtr = (meses == mes_filtrar) & (anios == anio_filtrar);
    lat_filtr = latitudes(idx_filtr);
    lon_filtr = longitudes(idx_filtr);
    cant_filtr = cantidad_crimenes(idx_filtr);


    % Ajuste de datos
    p50 = prctile(cant_filtr,50);
    i = find(cant_filtr > p25);
    lat_filtr = lat_filtr(i);
    lon_filtr = lon_filtr(i);
    cant_filtr = log(cant_filtr(i) + 1);
    a = min(cant_filtr);
    b = max(cant_filtr);
    cant_filtr = (cant_filtr - a)/(b - a);

    % Combinar los puntos reales con los puntos ficticios
    lat_filtr = [lat_filtr; corner_lats'];
    lon_filtr = [lon_filtr; corner_lons'];
    cant_filtr = [cant_filtr; corner_crimes'];

    % Crear la malla de puntos para interpolación IDW
    [long_grid, lat_grid] = meshgrid(linspace(long_min, long_max, 100), ...
                                     linspace(lat_min, lat_max, 100));
    xi = long_grid(:);
    yi = lat_grid(:);

    % Interpolación IDW
    F = scatteredInterpolant(lon_filtr, lat_filtr, cant_filtr, 'natural', 'none');
    zi_idw = F(xi, yi);

    % Crear máscara para los puntos fuera del shapefile
    zi_idw(~dentro_shapefile) = NaN;
    zi_grid_idw = reshape(zi_idw, size(long_grid));

    % Crear y guardar el gráfico sin mostrarlo
    fig = figure('Visible', 'off');
    mapshow(S, 'FaceColor', [0.95, 0.95, 0.95], 'EdgeColor', 'k'); % Muestra bordes del mapa
    hold on;

    % Ajustar niveles y colormap
    contourf(long_grid, lat_grid, zi_grid_idw, 800, 'LineColor', 'none', 'FaceAlpha', 0.95);
    colormap(turbo);
    colorbar;
    clim([0, 1]);

    % Título y otros elementos del gráfico
    title(['        TRÁFICO. FABRICACIÓN O PORTE DE ESTUPEFACIENTES en ', num2str(mes_filtrar), '/', num2str(anio_filtrar)]);
    text(long_min + 0.03*(long_max - long_min), lat_max - 0.05*(lat_max - lat_min), 'IDW', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'black');
    xlabel('Longitud');
    ylabel('Latitud');
    xlim([long_min, long_max]);
    ylim([lat_min, lat_max]);
    axis off;
    hold off;

    % Guardar el gráfico
    filename = fullfile(output_folder, sprintf('grafico_%04d_%02d.png', anio_filtrar, mes_filtrar));
    saveas(fig, filename);
    close(fig);

    disp(['Gráfico para ', num2str(mes_filtrar), '/', num2str(anio_filtrar), ' guardado en ', filename]);
end
disp('Todos los gráficos han sido guardados.');
