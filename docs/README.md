
# RESULTADOS FINALES DEL PROYECTO

En el presente se encuentra documentado el trabajo del grupo para la realización de un módulo de captura de datos
que debe tomar los datos de entrada de la cámara que se encuentran en RGB 565 y transformarlos a formato RGB 332
e instanciarlo en el test_cam.v.

![DIAGRAMA1](/docs/figs/cajacapturadatos.png)

se debían sincronizar las señales de entrada para poder realizar una captura de datos correcta, para ello se analizó el siguiente diagrama:

![DIAGRAMA1](/docs/figs/cajacapturadatos2.PNG)
posteriormente al realizar el análizis de este diagrama se concluye que Vsync será el encargado de decir cuándo se inica la imagen y cuándo finaliza, el href nos dice cuándo se hace el cambio de columna de datos, mientras ue pclk se encarga de decirnos qué pixel nos encontramos leyendo.
este código corresponde a la captura de datos.

una vez entendido se procede a la realización de un diagrama de bloques funcional de la solución a la captura de datos

![DIAGRAMA1](/docs/figs/Diagrama_de_flujo_cam_read.PNG)
una vez realizado esto se concluye que que se usará una máquina de estados en el código que nos perimta:
 * verificar el pclk(si está en flaco de subida)
 * verificar el estado de Vsync
 * verificar href
  * luego analizar qué byte estamos leyendo para saberlos píxeles que se están tomando
  * guardar en memoria
  * volver a verifica vsync 




