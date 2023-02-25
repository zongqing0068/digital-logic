`timescale 1ns / 1ps

//显示模块
module calculator_display(
    input wire clk,//分频后的时钟信号
    input wire rst,//复位信号
    input  wire button,//消抖后的启动信号
    input wire [31:0] cal_result,//用二进制表示的计算结果
    output reg [7:0] led_en,//数码管显示控制使能端
    output reg led_ca,//数码管显示控制信号
    output reg led_cb,
    output reg led_cc,
    output reg led_cd,
    output reg led_ce,
    output reg led_cf,
    output reg led_cg,
    output wire led_dp
    );

reg ena=0;//控制是否显示数字的使能端，即记录button是否被按下过
reg [31:0] cnt_num = 32'h0;
reg [31:0] num_end = 32'd10000;//控制数码管显示位置的轮换时间
reg [3:0] switch;//将每四位二进制数转化为十六进制对应的数码管亮暗方式

assign led_dp = 1;

always@(posedge clk or posedge rst)
begin
    if(rst) {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1111111;//复位时全灭
    else begin
        case(switch)//每四位不同的二进制表示对应了一位十六进制数字，对应了一种数码管亮暗方式
            4'b0000:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0000001;
            4'b0001:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1001111;
            4'b0010:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0010010;
            4'b0011:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0000110;
            4'b0100:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1001100;
            4'b0101:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0100100;
            4'b0110:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0100000;
            4'b0111:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0001111;
            4'b1000:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0000000;
            4'b1001:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0001100;
            4'b1010:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0001000;
            4'b1011:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1100000;
            4'b1100:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1110010;
            4'b1101:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1000010;
            4'b1110:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0110000;
            4'b1111:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0111000;
        endcase 
    end           
end  

always@(posedge clk or posedge rst)
begin//计数器，控制数码管显示位置的轮换
    if(ena) begin
        if(button || rst) cnt_num <= 32'h0;
        else if(cnt_num == num_end) cnt_num <= 32'h0;
        else cnt_num <= cnt_num + 32'h1;
        end
end 

always@(posedge clk or posedge rst)
begin
    if(rst) begin//复位时数码管熄灭
        ena <= 0;
        led_en <= 8'b11111111;
        switch <= 4'b0000;
        
    end
    else if(button) begin
        ena <= 1;//按下button直到按rst之前，数码管均应有显示
        led_en <= 8'b11111110;//从最后一位往前轮换
    end
    else if(ena) begin
        if(cnt_num == num_end)//计数器达到轮换时间
        begin
            led_en <= {led_en[6:0], led_en[7]};//显示前一位数字
            case(led_en)//根据数码管点亮的位置判断当前应显示的数字(将二进制数字每四位一分割)
               8'b01111111: switch <= cal_result[31:28];
               8'b10111111: switch <= cal_result[27:24];
               8'b11011111: switch <= cal_result[23:20];
               8'b11101111: switch <= cal_result[19:16];
               8'b11110111: switch <= cal_result[15:12];
               8'b11111011: switch <= cal_result[11:8];
               8'b11111101: switch <= cal_result[7:4];
               8'b11111110: switch <= cal_result[3:0];
            endcase
        end
    end       
end

endmodule
