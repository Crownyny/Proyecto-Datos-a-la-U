# REPOSITORIO PARA EL CONCURSO "DATOS A LA U"

## PROYECTO: Análisis espacio-temporal de la dinámica del delito en el territorio colombiano

### AUTORES:
- **Jason Alexander Muñoz Hormiga** - [jaisonmunoz@unicauca.edu.co](mailto:jaisonmunoz@unicauca.edu.co)
- **Yersson Esteban Montenegro Astudillo** - [yemontenegro@unicauca.edu.co](mailto:yemontenegro@unicauca.edu.co)
- **Julian David Meneses Daza** - [juliandavidm@unicauca.edu.co](mailto:juliandavidm@unicauca.edu.co)

---

### Descripción del Proyecto
Para el preprocesamiento de datos, utilizamos el notebook `General.ipynb`, que carga los datos desde el archivo `Datos2010-2024.csv`. Este notebook también permite pivotear y despivotear los datos, lo cual es necesario para que el modelo pueda predecir el siguiente valor para todos los municipios de un departamento o a nivel nacional.

Los datos geográficos de longitud y latitud están en el archivo `GeoColombia.json`.

Tambien se cuenta con un dashboard en PowerBI con la visualizacion de los datos `DataVisualization.pbix`, aunque este todavia no tiene integracion con ninguno de los modelos

### Modelos Utilizados
Los modelos empleados para la predicción espacial (IDW) y la predicción temporal se encuentran en la carpeta `Matlab Scripts`. Dentro de esta carpeta, hay una subcarpeta con el mapa de formas de Colombia como referencia.

A continuación, se describe la funcionalidad de cada archivo:

- **`Generador_PNG.m`**: Genera una carpeta con imágenes de todos los años en formato PNG para la creación de un GIF.
- **`Mapa_Mes.m`**: Crea un mapa para un mes y año específicos, mostrando las zonas de mayor probabilidad de delito.
- **`Modelo_Predictivo.m`**: Función que debe ejecutarse antes de `Prediccion.m`; se aplica en cada coordenada para predecir su siguiente valor.
- **`Prediccion.m`**: Genera una predicción a partir de un archivo pivoteado con cada localización y su serie de tiempo.

---

### Estructura de Carpetas

Para facilitar el manejo de los datos, hemos organizado ciertas carpetas adicionales:

- **`Csv por Departamento`**: Contiene los datos fragmentados por departamento para facilitar su manipulación.
- **`Datos Anuales Capturas Policia Nacional`**: Incluye el proceso de transformación de los datos anuales crudos de la policía.
- **`Elementos Graficos`**: Contiene algunos elementos gráficos utilizados en la presentación para su revisión.
- **`Datos IDW Trafico de Estupefacientes`**: Contiene datos con fecha, coordenada y cantidad de capturas por tráfico de estupefacientes; estos datos pueden ser usados en `Mapa_Mes` para generar mapas.

---

### Fuentes de Datos

- **Datos de Capturas 2010-2015**: [Reporte Capturas Policía Nacional de Colombia](https://www.datos.gov.co/Seguridad-y-Defensa/Reporte-Capturas-Polic-a-Nacional-de-Colombia/cukt-wz9m/about_data)
- **Datos de Capturas 2015-09/2024**: [Policía Nacional - Resultados Operativos](https://www.policia.gov.co/resultados-operativos)
- **Geo-referencias**: [Geoportal DANE - Divipola](https://geoportal.dane.gov.co/servicios/descarga-y-metadatos/descarga-divipola/)

--- 
