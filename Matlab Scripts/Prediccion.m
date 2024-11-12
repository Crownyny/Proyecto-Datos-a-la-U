% Cargar los datos desde un archivo CSV
disp('Cargando datos desde el archivo CSV...');
df = readtable('NARCOTRAFICO_PIVOT.csv'); % Cambia el nombre del archivo si es necesario
disp('Datos cargados correctamente.');

results = [];

% Asegúrate de que 'df.Cantidad' (o la columna que quieras) sea la serie de datos
for col = 2:width(df)  % Asumiendo que las columnas de datos empiezan desde la segunda columna
    serie = df{:, col};  % Obtener los datos de la columna 'col'
    
    % Llamar a la función 'pronostico_delitos2' y obtener solo el segundo valor
    result = pronostico_delitos2(serie, 12, 1, 1);  % Aquí 'serie' es la columna de datos
    results = [results, result(2, 1)];  % Guardar solo el segundo valor
end

% Obtener la fecha siguiente (sumando 1 mes)
fecha_actual = datetime(df.MES{177}, 'InputFormat', 'yyyy-MM');  % Usar la primera fecha de 'df.MES'
fecha_siguiente = dateshift(fecha_actual, 'start', 'month', 1);
% Convertir la nueva fecha a formato string (de nuevo a 'yyyy-mm')
nueva_fecha = datestr(fecha_siguiente, 'yyyy-mm');  % Convertir la fecha a string en formato 'yyyy-mm'

results(isnan(results)) = 0;
% Crear la nueva fila con la fecha y los resultados
new_row = [{nueva_fecha}, num2cell(results)];  % Agregar la fecha como una celda y convertir los resultados a celdas

% Convertir la nueva fila a una tabla y agregarla al final de 'df'
new_row_table = cell2table(new_row, 'VariableNames', df.Properties.VariableNames);
df = [df; new_row_table];

% Mostrar la tabla resultante
% Exportar la tabla df a un archivo CSV
writetable(df, 'resultado_pivot.csv');
