`timescale 1ns/1ps

module testbench (
);

reg        clk       ;
reg        rst_n     ;
reg [31:0] cnt       ;
reg        cnt_period;
reg [ 3:0] check_cnt ;
reg        wrong_en  ;
reg        wrong_c   ;

wire [7:0] led_en;
wire       led_ca;
wire       led_cb;
wire       led_cc;
wire       led_cd;
wire       led_ce;
wire       led_cf;
wire       led_cg;
wire       led_dp;
	
wire rst = ~rst_n;

initial begin
    clk = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
    #10000000;
    $finish;
end

always #5 clk = ~clk;

wire cnt_end = (cnt == 32'h0000ffff);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)       cnt_period <= 1'b0;
	else if (cnt_end) cnt_period <= 1'b0;
	else              cnt_period <= 1'b1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          cnt <= 32'h0;
	else if (cnt_end)    cnt <= 32'h0;
	else if (cnt_period) cnt <= cnt + 32'h1;
end

wire button_pos = (cnt == 32'h1);

wire [7:0] led_en_result = led_en[0] + led_en[1] + led_en[2] + led_en[3] + led_en[4] + led_en[5] + led_en[6] + led_en[7];

wire [6:0] led_cx = {led_cg,led_cf,led_ce,led_cd,led_cc,led_cb,led_ca}; 

wire led0 = (led_cx == 7'b1000000);
wire led1 = (led_cx == 7'b1111001);
wire led2 = (led_cx == 7'b0100100);
wire led3 = (led_cx == 7'b0110000);
wire led4 = (led_cx == 7'b0011001);
wire led5 = (led_cx == 7'b0010010);
wire led6 = (led_cx == 7'b0000010);
wire led7 = (led_cx == 7'b1111000);
wire led8 = (led_cx == 7'b0000000);
wire led9 = (led_cx == 7'b0011000); 

wire led_cx_v = led0 | led1 | led2 | led3 | led4 | led5 | led6 | led7 | led8 | led9;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          check_cnt <= 4'h0;
	else if (button_pos) check_cnt <= 4'h1;
	else                 check_cnt <= check_cnt + 4'h1;
end

wire check_period = cnt_period & (check_cnt > 4'h4);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)            wrong_en <= 1'b0;
	else if (check_period) wrong_en <= ~(led_en_result == 8'h07);
end	

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)            wrong_c <= 1'b0;
	else if (check_period) wrong_c <= ~(led_cx_v & led_dp);
end

wire [31:0] cnt_w = cnt - 32'h1;

always @ (posedge clk) begin
    if (cnt_end) begin
	    $display("index %x finished",cnt_w);
        if(cnt_end) begin
	        $display("====================================");
	        $display("Test end!");
            $display("----PASS!!!");
	        $finish;
        end
    end
    else if (wrong_en) begin
	    $display("led_en signal wrong at index %x",cnt_w);
	    $display("=====================================");
	    $display("Test end!");
        $display("----FAIL!!!");
	    $finish;
    end
	else if (wrong_c) begin
	    $display("led_c*/led_dp signal wrong at index %x",cnt_w);
	    $display("=====================================");
	    $display("Test end!");
        $display("----FAIL!!!");
	    $finish;
    end
end

led_display_ctrl u_led_display_ctrl (
    .clk    (clk   ),
	.rst    (rst   ),
	.button (button_pos),
	.led_en (led_en),
	.led_ca (led_ca),
	.led_cb (led_cb),
    .led_cc (led_cc),
	.led_cd (led_cd),
	.led_ce (led_ce),
	.led_cf (led_cf),
	.led_cg (led_cg),
	.led_dp (led_dp) 
);

endmodule