
# RESULTADOS FINALES DEL PROYECTO
Juan Pablo González Prieto 1075680988
Julián David Pulido Castañeda 1000163697
Sebastián Ruiz Pulido 1032504363

En el presente se encuentra documentado el trabajo del grupo para la realización de un módulo de captura de datos
que debe tomar los datos de entrada de la cámara que se encuentran en RGB 565 y transformarlos a formato RGB 332
e instanciarlo en el test_cam.v.

![DIAGRAMA1](/docs/figs/cajacapturadatos.png)

Se debían sincronizar las señales de entrada para poder realizar una captura de datos correcta, para ello se analizó el siguiente diagrama:

![DIAGRAMA1](/docs/figs/cajacapturadatos2.PNG)
Posteriormente al realizar el análizis de este diagrama se concluye que Vsync será el encargado de decir cuándo se inica la imagen y cuándo finaliza, el href nos dice cuándo se hace el cambio de columna de datos, mientras que pclk se encarga de decirnos qué pixel nos encontramos leyendo.
este código corresponde a la captura de datos.

Una vez entendido se procede a la realización de un diagrama de bloques funcional de la solución a la captura de datos:

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
		    input pclk,             //entrada pclk de la cámara
		    input rst,              //reset de la cámara
		    input vsync,            //señal Vsync de la cámara que permite saber cuándo empieza una imagen
		    input href,             //señal href de la cámara que permite saber qué línea de píxeles se está escribiendo
		    input [7:0] px_data,    //entrada de dato de 8 bits de la cámara(correspondiente a una parte de un píxel)

		    output reg [AW-1:0] mem_px_addr=0, // address de ña memoria (posición donde se está escribiendo)
		    output reg [7:0]  mem_px_data, // RGB 565 to RGB 332 aquí trnansformamos e RGB 565 a RGB 332
		    output reg px_wr //  nos indica si estamos escribiendo en memoria o no
   );
   reg [1:0]cs=0;// actúa como el contador de  case
	 reg ovsync;// utilizado para guardar el valor pasado de Vsync
	 
always @ (posedge pclk) begin// sentencias que se llevan a cabo siempre y cuando pclk se encuentre en un flanco de subida
	case (cs)//inicio de la máquina de estados
	0: begin// estado 0 de la máquina de estados cs=00
		if(ovsync && !vsync)begin//rápidamente ovsync ha toamdo el primer valor de vsync y procedemos a compararlos, con && garantizamos una comparación de tipo AND
		cs=1;// si ovsync y !vsync =1 entonces procedemos a pasar al case 1
		mem_px_addr=0;//iniciamos en la posición de memoria 0
		end
	end
	1: begin// primer primer estado, cs=01, en este caso hacemos la captura de los datos y procedemos a convertirlos a RGB 332
		px_wr=0;// indicamos que aún no escribimos en la memoria
		if (href) begin//debemos asegurar que href se encuentre en flanco de subida para hacer el proceso
/****************************************************************
 en esta parte tomamos los datos más significativo de R(rojo) y V (Verde)
 del primer byte que vienen en formato 565(RGB) y lo guardamos en formato   
 332(RGB)         
******************************************************************/
				mem_px_data[7]=px_data[7];          
				mem_px_data[6]=px_data[6];             
				mem_px_data[5]=px_data[5];                 
				mem_px_data[4]=px_data[2];              
				mem_px_data[3]=px_data[1];         
				mem_px_data[2]=px_data[0];
				cs=2;// despues de tomar los datos más significativos ásamos al estado 2 
		end
	end
	2: begin// estado 2, en este estado procedemos a tomar los datos del color azul(B) que vienen en formato 565 RGB y se pasa a 332 RGB
				mem_px_data[1]=px_data[4];
				mem_px_data[0]=px_data[3];
			 	px_wr=1;//procedemos a escribir en memoria
				mem_px_addr=mem_px_addr+1;//nos desplazamos a la siguiente dirección de memoria
				cs=1;//posteriormente volvemos al estado 1 de la máquina de estados 
		if(vsync) begin// con este condicional analizamos que si vsync está en un flanco de subida volvemos al estado 0
		cs=0;
		end		
		if (mem_px_addr==19200) begin//limitador de memoria
			mem_px_addr=0;// si la memoria  llega  a la posición de  19200 píxeles, debe volver a la posición 0 nuevamente
			cs=0;//nos devolvemos al estado 0 a evaluar vsync
		end
		end
endcase
	ovsync<=vsync;// se usa para que recurentemente ovsync tome el valor pasado de vsync
end
endmodule
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