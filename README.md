```{r, eval=FALSE, include=TRUE}
"Protocolo:

1. Daniel Felipe Villa Rengifo

2. Lenguaje: R

3. Tema: Mapas con R

4. Fuentes:
   https://rpubs.com/rubenfbc/mapa_coordenadas"
```


En multitud de campos la mejor forma de mostrar los resultados suele ser la construcción de un mapa, de tal forma que podamos hacer accesible esta información a cualquiera con un solo vistazo.

Muchos paquetes y funciones para la generación de gráficos se apoyan en los motores gráficos base de R. Sin embargo, para ciertos gráficos avanzados se quedan cortos.

mostraremos los pasos para construir mapas utilizando el paquete `ggplot2`.

# ¿Cómo se organizan los gráficos en R?

Antes de adentrarnos en el paquete ggplo2, es interesante conocer el funcionamiento del sistema de gráficos en R. Este sistema está formado por:

1. Paquetes gráficos.
2. Sistemas gráficos.
3. Motor de dispositivos gráficos.
4. Paquetes de dispositivos gráficos.

+ El núcleo funcional lo componen el motor de gráficos (`grDevices`) y los sistemas gráficos (`graphics` para gráficos tradicionales y `grid` para gráficos de malla o rejilla).

En otros lenguajes de programación la capacidad de construir gráficos la proporciona librerías adicionales ajenas al núcleo (como `matplotlib` para __Python__). En R contamos con `graphics` y `grDevices` ya integrados. En 2001, Paul Murrell desarrolló `grid`, otro sistema gráfico para facilitar la creación de gráficos de rejillas. El paquete `grDevices` permite modificar las fuentes, colores.. y da soporte a los dispositivos gráficos que permiten la exportación a varios formatos.

El sistema de gráficos tradicionales está formado por funciones del paquete `graphics`, mientras que el sistema de gráficos de rejilla lo componen funciones del paquete `grid`. Además, existen muchas librerías adicionales como `ggplot2` o `lattice` que proporcionan acceso a funciones gráficas, pero todas se crean a partir de `graphics` o `grid`.

> Todo esto lo podemos ver en la imagen `organizaciondegraficos.png`

```{r}
#El primer paso, es instalar (si no se ha hecho ya) y cargar las librerías necesarias para trabajar:

#install.packages("ggplot2")
#install.packages("sf")
library(sf)
library(ggplot2)
```


```{r}
# IMportamos archivos GEOjson que marca los departamentos colombianos
DEPColombia <- st_read("MGN_DPTO_POLITICO.json")

# Ver mapa de los departamentos colombianos
png(filename = "DEPCol.png")

depa <- ggplot(data = DEPColombia) +
  geom_sf()
depa
dev.off()

"Esta llamada introduce muy bien la estructura de creación de un gráfico con el paquete ggplot2:

1. La primera parte ggplot(data = DEPColombia) indica que los datos principales se almacenan en el objeto DEPColombia.

2. La línea termina con un signo positivo +, que indica que la llamada aún no está completa, y cada línea que va a continuación corresponde a otra capa. El funcionamiento de ggplot2 consiste en concatenar llamadas a funciones hasta crear el mapa que deseemos.

3. Por último, usamos la función geom_sf, que sirve para agregar la geometría almacenada en un objeto sf"
```

# Colores y bordes

Sin duda alguna, los colores de los objetos representados en un mapa tienen una importancia máxima. Podemos personalizar el color del relleno de todos los objetos y los bordes que incluyamos en nuestro mapa.

```{r}
# POr errores con el sistema para exportar se creo este loop:
while (!is.null(dev.list()))  dev.off()
# En este ejemplo, se genera un mapa dónde todos los elementos tienen el mismo color:
png(filename = "ColorDepa.png")
color <- ggplot(data = DEPColombia) +
  geom_sf(fill = "yellow", color = "black")
color
dev.off()
```

Habiendo aprendido esto veremos algunos ejercicios con bases de datos:

esta tabla de datos fue tomada de [Datos Abiertos Colombia](https://www.datos.gov.co/Salud-y-Protecci-n-Social/Nacidos-Vivos-en-Hospital-Manuel-Uribe-Angel/udqu-ifxr).

Aqui trabajaremos como seran las condiciones de nacimiento de un bebe registrado en el hospital manuel uribe angel, estas estaran relacionada ccon los niveles educativos de padre y/o madre, suponemos de ante mano que la mayoria de los padres no son profesionales por la precariedad de la educación colombiana.





```{r}
library(dplyr)

# Cargamos la base datos, un archivo shp que qse complementa con los otros con su misma nomenclatura
alternativa <- st_read("geo_export_a35e2612-c435-4080-835b-54938105b90f.shp")



############################# VAMOS A EXPORTAR: #################################

# Creamos un grafico para ver en los nacimeintos registrados en el Hospital Manuel Uribe Angel:

png("NacimeintosMapaPAPA.png", height = 720, width = 720)

padre <- ggplot(data = DEPColombia)+
  geom_sf()+
  geom_sf(data = alternativa, aes(geometry = geometry,
                                  colour = nivel_educ,
                                  alpha = I(0.7)))+
  coord_sf(ylim = c(3,11), xlim = c(-78, -72))+
  scale_color_discrete("Región de nacimento (Con Nivel Educativo Padre)")

padre

dev.off()

# Creamos un grafico con el nivel educativo de la madre
png("NacimeintosMapaMAMA.png", height = 720, width = 720)

madre <- ggplot(data = DEPColombia)+
  geom_sf()+
  geom_sf(data = alternativa, aes(geometry = geometry,
                                  colour = nivel_ed_2,
                                  alpha = I(0.7)))+
  coord_sf(ylim = c(3,11), xlim = c(-78, -72))+
  scale_color_discrete("Región de nacimento (Con Nivel Educativo Madre)")

madre

dev.off()

# Barplot sobre losniveles educativos de los padres

png(filename = "NivelEdu_PAPA.png", height = 720, width = 720)

nivel_educativo_padre <- ggplot(data = alternativa)+
  geom_bar(aes(x = nivel_educ, fill = nivel_educ, color = nivel_educ))+
  theme(axis.text.x = element_text(angle = 50, hjust = 1))+
  xlab("")+
  ylab("")

nivel_educativo_padre
dev.off()
# Barplot sobre losniveles educativos de los padres
png(filename = "NivelEdu_MAMA.png", height = 720, width = 720)

nivel_educativo_madre <- ggplot(data = alternativa)+
  geom_bar(aes(x = nivel_ed_2, fill = nivel_ed_2, color = nivel_ed_2))+
  theme(axis.text.x = element_text(angle = 50, hjust = 1))

nivel_educativo_madre

dev.off()

```
Como podemos ver tanto madre y/o padre la mayoria pertenecen al nivel de estudio __"media academica o clasica"__ por ende se puede suponer la vida que van a llevar, sin contantar la cantidad de hijos que tuvieron o tendran, supongo que la mayoria de estos nacimentos son de jovenes que por la falta de educación sexual ahora tiene que ser responsable con dos bocas.