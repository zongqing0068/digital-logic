`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/15 11:22:13
// Design Name: 
// Module Name: memory_w_r
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory_w_r(
    input clk_g,
    input rst,
    input button,
    input [15:0] mem_douta,
    output [15:0] led,
    output mem_ena,
    output mem_wea,
    output [3:0] mem_addra,
    output [15:0] mem_dina
    );
    
reg ena, wea;
reg [15:0] dina;
reg [3:0] addra = 4'b0;
reg [15:0] led0;
wire rst_n = ~rst;
reg [31:0] cnt = 32'h0;
integer num=0;

assign mem_ena = ena;
assign mem_wea = wea;
assign mem_dina = dina;
assign mem_addra = addra;
assign led = led0;

// always@(posedge clk_g or negedge rst_n) begin
//    led0 = mem_douta;
//    end


always@(posedge clk_g or negedge rst_n)
begin
    if(ena) begin
        if(~rst_n) cnt <= 32'h0;
        else if(cnt == 32 'd10000000) cnt <= 32'h0;
        else cnt <= cnt + 32'h1;
        end
end    

always@(posedge clk_g or negedge rst_n)
begin
    if (~rst_n) begin
        ena <= 0;
        wea <= 0;
        dina<=16'h0000000000000001;
        led0 <= 16'b0;
        end
    else if (button) begin
        ena <= 1;
        wea <= 1;
        end
    else if (ena) begin
        if(wea) begin
            case(addra)
            4'b0000: dina<=16'b0000000000000011;
            4'b0001: dina<=16'b0000000000000111;
            4'b0010: dina<=16'b0000000000001111;
            4'b0011: dina<=16'b0000000000011111;
            4'b0100: dina<=16'b0000000000111111;
            4'b0101: dina<=16'b0000000001111111;
            4'b0110: dina<=16'b0000000011111111;
            4'b0111: dina<=16'b0000000111111111;
            4'b1000: dina<=16'b0000001111111111;
            4'b1001: dina<=16'b0000011111111111;
            4'b1010: dina<=16'b0000111111111111;
            4'b1011: dina<=16'b0001111111111111;
            4'b1100: dina<=16'b0011111111111111;
            4'b1101: dina<=16'b0111111111111111;
            4'b1110: dina<=16'b1111111111111111;
            endcase
            addra <= addra+1;
            if (addra == 4'b1111) begin
                wea <= 0;
                addra <= 4'b0000;
            end  
        end
        else begin
           if (cnt == 32'd10000000) begin
               led0 <= mem_douta;
	           if (addra < 4'b1111)
	           addra <= addra + 1;
	       end
	   end
    end
end

    
endmodule
