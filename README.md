Aquí tienes el README con el formato y los espacios adecuados:

---

# REPOSITORIO PARA EL CONCURSO "DATOS A LA U"

## PROYECTO: Análisis espacio-temporal de la dinámica del delito en el territorio colombiano

### AUTORES:
- Jason Alexander Muñoz Hormiga - [jaisonmunoz@unicauca.edu.co](mailto:jaisonmunoz@unicauca.edu.co)
- Yersson Esteban Montenegro Astudillo - [yemontenegro@unicauca.edu.co](mailto:yemontenegro@unicauca.edu.co)
- Julian David Meneses Daza - [juliandavidm@unicauca.edu.co](mailto:juliandavidm@unicauca.edu.co)

---

### Descripción del Proyecto
Para el preprocesamiento de datos, utilizamos el notebook `General.ipynb`, el cual carga los datos desde el archivo `Datos2010-2024.csv`.

### Modelos Utilizados
Los modelos empleados para predicción espacial (IDW) y para predicción temporal se encuentran en la carpeta `Matlab Scripts`. Dentro de esta carpeta, también hay una subcarpeta con el mapa de formas de Colombia como referencia.

A continuación, se describe la funcionalidad de cada archivo:

- **`Generador_PNG.m`**: Genera una carpeta con imágenes de todos los años en formato PNG para la creación de un GIF.
- **`Mapa_Mes.m`**: Crea un mapa para un mes y año específicos, mostrando las zonas de mayor probabilidad de delito.
- **`Modelo_Predictivo.m`**: Función que debe ejecutarse antes de usar `Prediccion.m`.
- **`Prediccion.m`**: Genera una predicción a partir de un archivo pivoteado con cada localización y su serie de tiempo.

---

### Estructura de Carpetas

Además, tenemos ciertas carpetas adicionales para facilitar el manejo de los datos:

- **`Csv por Departamento`**: Contiene los datos fragmentados por departamento para mayor facilidad y ligereza de manejo.
- **`Datos Anuales Capturas Policia Nacional`**: Incluye el proceso de transformación de los datos crudos anuales de la policía.
- **`Elementos Graficos`**: Contiene algunos elementos gráficos utilizados en la presentación para su revisión.

--- 

