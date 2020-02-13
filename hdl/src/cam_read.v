`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:22 12/02/2019 
// Design Name: 
// Module Name:    cam_read 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//hola, commist de prueba
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
	

/********************************************************************************

Por favor colocar en este archivo el desarrollo realizado por el grupo para la 
captura de datos de la camara 

debe tener en cuenta el nombre de las entradas  y salidad propuestas 

********************************************************************************/
	 reg [1:0]cs=0;
	 reg ovsync;
	 
always @ (posedge pclk) begin
	case (cs)
	0: begin
		if(ovsync && !vsync)begin
		cs=1;
		end
	end
	1: begin
		if(vsync) begin
			cs=0;
		end
		px_wr=0;
		mem_px_addr=0;
		mem_px_data=0;
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
				#1
			 	px_wr=1;
				mem_px_addr=mem_px_addr+1;
			
				if (mem_px_addr==19200) begin
						mem_px_addr=0;
						cs=0;
					end
						if (href) cs=1
						else cs=0
				px_wr=o;
		end
endcase
	ovsync<=vsync;
end
endmodule
