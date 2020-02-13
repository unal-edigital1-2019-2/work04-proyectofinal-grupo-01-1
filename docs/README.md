
# RESULTADOS FINALES DEL PROYECTO

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
		    input pclk,
		    input rst,
		    input vsync,
		    input href,
		    input [7:0] px_data,

		    output reg [AW-1:0] mem_px_addr=0,
		    output reg [7:0]  mem_px_data,
		    output reg px_wr
   );
   reg [1:0]cs=0;
	 reg ovsync;
	 
always @ (posedge pclk) begin
	case (cs)
	0: begin
		if(ovsync && !vsync)begin
		cs=1;
		mem_px_addr=0;
		end
		mem_px_addr=0;
	end
	1: begin
		px_wr=0;
		if (href) begin
				mem_px_data[7]=px_data[7];
				mem_px_data[6]=px_data[6];
				mem_px_data[5]=px_data[5];
				mem_px_data[4]=px_data[2];
				mem_px_data[3]=px_data[1];
				mem_px_data[2]=px_data[0];
				cs=2;
		end
	end
	2: begin
				mem_px_data[1]=px_data[4];
				mem_px_data[0]=px_data[3];
			 	px_wr=#1 1;
				mem_px_addr=mem_px_addr+1;
				cs=1;
		if(vsync) begin
		cs=0;
		end		
		if (mem_px_addr==19200) begin
			mem_px_addr=0;
			cs=0;
		end
		end
endcase
	ovsync<=vsync;
end
endmodule
```