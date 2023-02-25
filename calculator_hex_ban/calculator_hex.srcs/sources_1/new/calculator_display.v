`timescale 1ns / 1ps

module calculator_display(
    input wire clk,
    input wire rst,
    input  wire button,
    input wire [31:0] cal_result,
    output reg [7:0] led_en,
    output reg led_ca,
    output reg led_cb,
    output reg led_cc,
    output reg led_cd,
    output reg led_ce,
    output reg led_cf,
    output reg led_cg,
    output wire led_dp
    );

reg ena=0;
reg [31:0] cnt_num = 32'h0;
reg [31:0] num_end = 32'd10000;
reg [3:0] switch;

assign led_dp = 1;

always@(posedge clk or posedge rst)
begin
    if(rst) {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1111111;
    else begin
        case(switch)
            4'b0000:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0000001;
            4'b0001:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1001111;
            4'b0010:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0010010;
            4'b0011:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0000110;
            4'b0100:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1001100;
            4'b0101:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0100100;
            4'b0110:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0100000;
            4'b0111:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0001111;
            4'b1000:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0000000;
            4'b1001:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0001100;
            4'b1010:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0001000;
            4'b1011:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1100000;
            4'b1100:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1110010;
            4'b1101:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1000010;
            4'b1110:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0110000;
            4'b1111:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b0111000;
        endcase 
    end           
end  


always@(posedge clk or posedge rst)
begin
    if(ena) begin
        if(button || rst) cnt_num <= 32'h0;
        else if(cnt_num == num_end) cnt_num <= 32'h0;
        else cnt_num <= cnt_num + 32'h1;
        end
end 

always@(posedge clk or posedge rst)
begin
    if(rst) begin
        ena <= 0;
        led_en <= 8'b11111111;
        switch <= 4'b0000;
        
    end
    else if(button) begin
        ena <= 1;
        led_en <= 8'b11111110;
    end
    else if(ena) begin
        if(cnt_num == num_end)
        begin
            led_en <= {led_en[6:0], led_en[7]};
            case(led_en)
//                8'b01111111: switch = cal_result[31:28];
//                8'b10111111: switch = cal_result[27:24];
//                8'b11011111: switch = cal_result[23:20];
//                8'b11101111: switch = cal_result[19:16];
//                8'b11110111: switch = cal_result[15:12];
//                8'b11111011: switch = cal_result[11:8];
//                8'b11111101: switch = cal_result[7:4];
//                8'b11111110: switch = cal_result[3:0];
                 
                8'b10111111: switch = cal_result[31:28];
                8'b11011111: switch = cal_result[27:24];
                8'b11101111: switch = cal_result[23:20];
                8'b11110111: switch = cal_result[19:16];
                8'b11111011: switch = cal_result[15:12];
                8'b11111101: switch = cal_result[11:8]; 
                8'b11111110: switch = cal_result[7:4];  
                8'b01111111: switch = cal_result[3:0];  
            endcase
        end
    end
        
end

endmodule
