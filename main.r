## ---- eval=FALSE, include=TRUE--------------------------------------------------------
## "Protocolo:
## 
## 1. Daniel Felipe Villa Rengifo
## 
## 2. Lenguaje: R
## 
## 3. Tema: Mapas con R
## 
## 4. Fuentes:
##    https://rpubs.com/rubenfbc/mapa_coordenadas"


## -------------------------------------------------------------------------------------
#El primer paso, es instalar (si no se ha hecho ya) y cargar las librerías necesarias para trabajar:

#install.packages("ggplot2")
#install.packages("sf")
library(sf)
library(ggplot2)


## -------------------------------------------------------------------------------------
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


## -------------------------------------------------------------------------------------
# POr errores con el sistema para exportar se creo este loop:
while (!is.null(dev.list()))  dev.off()
# En este ejemplo, se genera un mapa dónde todos los elementos tienen el mismo color:
png(filename = "ColorDepa.png")
color <- ggplot(data = DEPColombia) +
  geom_sf(fill = "yellow", color = "black")
color
dev.off()


## -------------------------------------------------------------------------------------
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
