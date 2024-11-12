REPOSITORIO PARA EL CONCURSO DATOS A LA U
PROYECTO: Análisis espacio temporal de la dinámica del delito en el territorio colombiano
AUTORES:
    Jason Alexander Muñoz Hormiga jaisonmunoz@unicauca.edu.co
    Yersson Esteban Montenegro Astudillo yemontenegro@unicauca.edu.co 
    Julian David Meneses Daza juliandavidm@unicauca.edu.co

Para el preprocesamiento de datos tenemos el notebook "General.ipynb", este carga los datos desde "Datos2010-2024.csv" 

Los modelos utilizados tanto para prediccion espacial IDW como para prediccion temporal, se encuentra en la carpeta Matlab Scripts, dentro de esa carpeta tambien esta una subcarpeta con el mapa de formas de colombia para referencia, a continuacion se lista la funcionalidad de cada archivo:
"Generador_PNG.m" Me genera una carpeta con imagenes de todos los años en fromato png para la creacion del gif
"Mapa_Mes.m" Me crea un mapa para cierto mes y año con las zonas de mayor proabbilidad de delito
"Modelo_Predictivo.m" Modelo_Predictivo, es una funcion que debe ser ejecutada antes de Prediccion
"Prediccion.m" Genera una prediccion para una rchivo pivoteado con cada localizacion y sus serie de tiempo

Tambien tenemos ciertas carpetas a modo de extras para facilidades
"Csv por Departamento" Tiene los datos fragmentados por departamento para mayor facilidad y ligereza de manejo
"Datos Anuales Capturas Policia Nacional" Tiene el proceso de como se transformaron los datos crudos anuales de la policia
"Elementos Graficos" tiene algunos elementos usados en la presentacion para su revision