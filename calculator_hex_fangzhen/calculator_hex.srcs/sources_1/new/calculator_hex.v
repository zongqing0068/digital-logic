`timescale 1ns / 1ps

module calculator_hex(
    input wire clk,
    input wire rst,
    input wire button,
    input wire [2:0] func,
    input wire [7:0] num1,
    input wire [7:0] num2,
    output reg [31:0] cal_result
//    output reg button_new
    );

reg flag;
//reg [15:0] cnt; 


//Ïû¶¶
//always @(posedge clk or posedge rst)
//begin
//	if(rst)
//		cnt <= 11'd0;
//	else if(button == 1) begin
//		if(cnt == 50000)
//			cnt <= cnt;
//		else 
//			cnt <= cnt + 1'b1;
//		end
//	else
//		cnt <= 16'b0;
//end

//always @(posedge clk or posedge rst) 
//begin
//	if(rst) button_new <= 4'd0;
//	else if(cnt == 49999) button_new <= 1'b1;
//	else button_new <= 1'b0;
//end

always@(posedge clk or posedge rst)
begin
    if(rst) flag <= 1'b0;
    else if(button) flag <= 1'b1;
end

always@(posedge clk or posedge rst)
begin
    if(rst) begin
    cal_result <= 32'b0;
    end
    else if(button) begin
        if(flag == 0)begin
            case(func)
            3'b000: cal_result <= num1 + num2;
            3'b001: cal_result <= num1 - num2;
            3'b010: cal_result <= num1 * num2;
            3'b011: cal_result <= num1 / num2;
            3'b100: cal_result <= num1 % num2;
            3'b101: cal_result <= num1 * num1;
            endcase
        end
        else
        case(func)
            3'b000: cal_result <= cal_result  + num2;
            3'b001: cal_result <= cal_result  - num2;
            3'b010: cal_result <= cal_result  * num2;
            3'b011: cal_result <= cal_result  / num2;
            3'b100: cal_result <= cal_result  % num2;
            3'b101: cal_result <= cal_result  * cal_result ;
        endcase
    end
end

endmodule