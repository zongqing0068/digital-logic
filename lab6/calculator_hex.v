`timescale 1ns / 1ps

//计算模块
module calculator_hex(
    input wire clk,//分频后的时钟信号
    input wire rst,//复位信号
    input wire button,//消抖后的启动信号
    input wire [2:0] func,//运算功能选择信号
    input wire [7:0] num1,//操作数1
    input wire [7:0] num2,//操作数2
    output reg [31:0] cal_result//用二进制表示的计算结果
    );

reg flag;

always@(posedge clk or posedge rst)
begin
    if(rst) flag <= 1'b0;//flag为0表示第一轮运算
    else if(button) flag <= 1'b1;//flag为1表示连续运算
end

always@(posedge clk or posedge rst)
begin
    if(rst) begin
    cal_result <= 32'b0;
    end
    else if(button) begin
        if(flag == 0)begin//第一轮运算时，两个操作数为num1和num2
            case(func)//按照func所选择的功能进行对应运算
            3'b000: cal_result <= num1 + num2;
            3'b001: cal_result <= num1 - num2;
            3'b010: cal_result <= num1 * num2;
            3'b011: cal_result <= num1 / num2;
            3'b100: cal_result <= num1 % num2;
            3'b101: cal_result <= num1 * num1;
            endcase
        end
        else//连续运算时，两个操作数为上一轮结果cal_result和num2
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

