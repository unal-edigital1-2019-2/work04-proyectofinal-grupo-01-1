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
module cam_read #(
		parameter AW = 15 // Cantidad de bits  de la dirección 
		)(
		input pclk,
		input rst,
		input vsync,
		input href,
		input [7:0] px_data,

		output [AW-1:0] mem_px_addr,
		output [7:0]  mem_px_data,
		output px_wr
   );
	

/********************************************************************************

Por favor colocar en este archivo el desarrollo realizado por el grupo para la 
captura de datos de la camara 

debe tener en cuenta el nombre de las entradas  y salidad propuestas 

********************************************************************************/
 reg contador=0;
	 reg [14:0]addr=0;
	 reg bp;
	 reg [1:0]cs=0;
	 reg ovsync;
	 reg ohref;
	 
always @ (posedge pclk) begin
	case (cs)
	0: begin
		if(ovsync && !vsync)begin
			cs=1;
		end
		addr=0;
		mem_px_addr<=0;
	end
	1: begin
		if (href==1) begin
			cs=2;
			px_wr<=0;
				if	(contador==0)begin
				mem_px_data[7]<=px_data[7];
				mem_px_data[6]<=px_data[6];
				mem_px_data[5]<=px_data[5];
				mem_px_data[4]<=px_data[2];
				mem_px_data[3]<=px_data[1];
				mem_px_data[2]<=px_data[0];
				contador=contador+1;
			end
		end
		if (vsync && !ovsync) begin
			cs=0;
		end
	end
	2: begin
	cs=1;
			if	(contador==1)begin
				mem_px_data[1]<=px_data[4];
				mem_px_data[0]<=px_data[3];
				mem_px_addr<=addr;
				addr=addr+1;
				#1
				px_wr<=1;
			end
		contador=contador+1;
		end
endcase
	ovsync=vsync;
	ohref=href;
end
endmodule
