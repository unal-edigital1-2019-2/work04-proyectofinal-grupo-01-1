
# RESULTADOS FINALES DEL PROYECTO
## UNIVERSIDAD NACIONAL DE COLOMBIA-BOGOTÁ-2020-20192S
### Juan Pablo González Prieto 1075680988
### Julián David Pulido Castañeda 1000163697
### Sebastián Ruiz Pulido 1032504363

En el presente se encuentra documentado el trabajo del grupo para la realización de un módulo de captura de datos
que debe tomar los datos de entrada de la cámara que se encuentran en RGB 565 y transformarlos a formato RGB 332
e instanciarlo en el test_cam.v.

![DIAGRAMA1](/docs/figs/cajacapturadatos.png)

Se debían sincronizar las señales de entrada para poder realizar una captura de datos correcta, para ello se analizó el siguiente diagrama:

![DIAGRAMA1](/docs/figs/cajacapturadatos2.PNG)

Posteriormente al realizar el análizis de este diagrama se concluye que Vsync será el encargado de decidirr cuándo se inica la imagen y cuándo finaliza, el href nos dice cuándo se hace el cambio de columna de datos, mientras que pclk se encarga de decirnos qué pixel nos encontramos leyendo.

Una vez entendido eso  se procede a la realización de un diagrama de bloques funcional de la solución a la captura de datos:

![DIAGRAMA1](/docs/figs/Diagrama_de_flujo_cam_read.PNG)


Realizado esto se concluye que se usará una máquina de estados en el código que nos permita:
 * verificar el pclk(si está en flaco de subida)
 * verificar el estado de Vsync
 * verificar href
   * luego analizar qué byte estamos leyendo para saberlos píxeles que se están tomando
   * guardar en memoria
   * volver a verifica vsync 

Al entender los estados que se debían realizar se crea el diagrama de la máquina de estados que se encuentra a continuación

   ![DIAGRAMA1](/docs/figs/Maquina_estados.png)


```verilog
        module cam_read #(
		    parameter AW = 15		// Cantidad de bits  de la dirección 
		    )(
<<<<<<< HEAD
		    input pclk,             //Entrada pclk de la cámara
		    input rst,              //Reset de la cámara
		    input vsync,            //Señal Vsync de la cámara que permite saber cuándo empieza una imagen
		    input href,             //Señal href de la cámara que permite saber qué línea de píxeles se está escribiendo
		    input [7:0] px_data,    //Entrada de dato de 8 bits de la cámara(correspondiente a una parte de un píxel)

		    output reg [AW-1:0] mem_px_addr=0, // Address de la memoria (posición donde se está escribiendo)
		    output reg [7:0]  mem_px_data, // RGB 565 to RGB 332 aquí trnansformamos el formto RGB 565 a RGB 332
		    output reg px_wr //  Nos indica si estamos escribiendo en memoria o no
=======
		    input pclk,             //entrada pclk de la cámara
		    input rst,              //reset de la cámara
		    input vsync,            //señal Vsync de la cámara que permite saber cuándo empieza una imagen
		    input href,             //señal href de la cámara que permite saber qué línea de píxeles se está escribiendo
		    input [7:0] px_data,    //entrada de dato de 8 bits de la cámara(correspondiente a una parte de un píxel)

		    output reg [AW-1:0] mem_px_addr=0, // address de ña memoria (posición donde se está escribiendo)
		    output reg [7:0]  mem_px_data, // RGB 565 to RGB 332 aquí trnansformamos el RGB 565 a RGB 332
		    output reg px_wr //  nos indica si estamos escribiendo en memoria o no
>>>>>>> 41e97c7b8d399dc4654ca6fddbeebe2ee66fd7a7
   );
   reg [1:0]cs=0;// Actúa como el contador de case (para establecer los casos)
	 reg ovsync;// Utilizado para guardar el valor pasado de Vsync
	 
<<<<<<< HEAD
always @ (posedge pclk) begin// Sentencias que se llevan a cabo siempre y cuando pclk se encuentre en un flanco de subida
	case (cs)//Inicio de la máquina de estados
	0: begin// Estado 0 de la máquina de estados cs=00
		if(ovsync && !vsync)begin//Rápidamente ovsync ha toamdo el primer valor de vsync y procedemos a compararlos, con && garantizamos una comparación lógica  de tipo AND
		cs=1;// Si ovsync y !vsync =1 entonces procedemos a pasar al estado 1
		mem_px_addr=0;//Iniciamos en la posición de memoria 0
		end
	end
	1: begin// primer primer estado, cs=01, En este caso hacemos la captura de los datos y procedemos a convertirlos a RGB 332
		px_wr=0;// Indicamos que aún no escribimos en la memoria
		if (href) begin//Debemos asegurar que href se encuentre en flanco de subida para hacer el proceso
=======
always @ (posedge pclk) begin// sentencias que se llevan a cabo siempre y cuando pclk se encuentre en un flanco de subida
	case (cs)//inicio de la máquina de estados
	0: begin// estado 0 de la máquina de estados cs=00
		if(ovsync && !vsync)begin//rápidamente ovsync ha tomado el primer valor de vsync y procedemos a compararlos, con && garantizamos una comparación de tipo AND
		cs=1;// si ovsync y !vsync =1 entonces procedemos a pasar al case 1
		mem_px_addr=0;//iniciamos en la posición de memoria 0
		end
	end
	1: begin// primer estado, cs=01, en este caso hacemos la captura de los datos y procedemos a convertirlos a RGB 332
		px_wr=0;// indicamos que aún no escribimos en la memoria
		if (href) begin//debemos asegurar que href se encuentre en flanco de subida para hacer el proceso
>>>>>>> 41e97c7b8d399dc4654ca6fddbeebe2ee66fd7a7
/****************************************************************
 En esta parte tomamos los datos más significativo de R(rojo) y V (Verde)
 del primer byte que vienen en formato 565(RGB) y lo guardamos en formato   
 332(RGB)         
******************************************************************/
				mem_px_data[7]=px_data[7];          
				mem_px_data[6]=px_data[6];             
				mem_px_data[5]=px_data[5];                 
				mem_px_data[4]=px_data[2];              
				mem_px_data[3]=px_data[1];         
				mem_px_data[2]=px_data[0];
<<<<<<< HEAD
				cs=2;// Después de tomar los datos más significativos pasamos al estado 2 
=======
				cs=2;// despues de tomar los datos más significativos pasamos al estado 2 
>>>>>>> 41e97c7b8d399dc4654ca6fddbeebe2ee66fd7a7
		end
	end
	2: begin// Estado 2, en este estado procedemos a tomar los datos del color azul(B) que vienen en formato 565 RGB y se pasa a 332 RGB
				mem_px_data[1]=px_data[4];
				mem_px_data[0]=px_data[3];
			 	px_wr=1;//Procedemos a escribir en memoria
				mem_px_addr=mem_px_addr+1;//Nos desplazamos a la siguiente dirección de memoria
				cs=1;//Posteriormente volvemos al estado 1 de la máquina de estados 
		if(vsync) begin// Con este condicional analizamos si vsync está en un flanco de subida volvemos al estado 0
		cs=0;//volvemos al estado 0 de nuestra máquina de estados
		end		
		if (mem_px_addr==19200) begin//Limitador de memoria
			mem_px_addr=0;// Si la memoria  llega  a la posición de  19200 píxeles, debe volver a la posición 0 nuevamente
			cs=0;//Nos devolvemos al estado 0 a evaluar vsync
		end
		end
endcase
<<<<<<< HEAD
	ovsync<=vsync;// Se usa para que recurrentemente ovsync tome el valor pasado de vsync
=======
	ovsync<=vsync;// se usa para que recurrentemente ovsync tome el valor pasado de vsync
>>>>>>> 41e97c7b8d399dc4654ca6fddbeebe2ee66fd7a7
end
endmodule
```

Para instanciar este bloque en el test_cam.v se utiliza el siguiente código

``` verilog
    cam_read #(AW)ov7076_565_to_332(
		.pclk(CAM_pclk),
		.rst(rst),
		.vsync(CAM_vsync),
		.href(CAM_href),
		.px_data(CAM_px_data),

		.mem_px_addr(DP_RAM_addr_in),
		.mem_px_data(DP_RAM_data_in),
		.px_wr(DP_RAM_regW)
   )
```
Entre las diferentes pruebas realizadas para verificar el funcionamiento del dispositivo tenemos:

* Prueba de los límites de la imagen: para esta prueba se se reemplazaron los datos de la cámara por el valor binario del color rojo para verificar que el modulo de alimentación a memoria fuciona correctamente.
![DIAGRAMA1](/docs/figs/Prueba_limitesdeimagen.jfif)

* Prueba de barra de colores de la memoria: se muestra el valor default que se encuentra en memoria previo a conectar la cámara.
![DIAGRAMA1](/docs/figs/Prueba_barra_coloresenmemoria.jpeg)

* Prueba de la barra de colores dada por la cámara: Por medio del programa arduino se asignó por default la muestra de una barra de colores para los datos de la cámara
![DIAGRAMA1](/docs/figs/Prueba_barra_colorescamara.jpeg)
![DIAGRAMA1](/docs/figs/Prueba_barra_colorescamara2.jpeg)

* Prueba final: Como ultima prueba se buscó obtener la imagen grabada por la cámara evidenciando una posible desincronización de las señales de entrada ó el fallo físco de la cámara.
![DIAGRAMA1](/docs/figs/Prueba_barracolores.jfif)

# Simulación:
En el paquete de trabajo número 3 se proporsionó una simulación para verificar el funcionamiento de la descripción de hardware ya que debido al paro presentado no se encontraban disponibles los equipos necesarios para su prueba.
![DIAGRAMA1](/docs/figs/simulacion.png)