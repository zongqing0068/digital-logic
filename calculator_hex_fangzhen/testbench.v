`timescale 1ns/1ps

`define CAL_RESULT u_calculator_top.u_calculator_hex.cal_result

module testbench (
);

reg        clk          ;
reg        rst_n        ;
reg [ 2:0] func         ;
reg [ 7:0] num1         ;
reg [ 7:0] num2         ;
reg [ 3:0] button_cnt   ;
reg [ 3:0] cnt          ;
reg [ 7:0] check_cnt    ;
reg        wrong        ;
reg [31:0] result [7:0] ;

wire clk_g ;
wire locked;

wire rst = ~rst_n;
wire [7:0] led_en;
wire       led_ca;
wire       led_cb;
wire       led_cc;
wire       led_cd;
wire       led_ce;
wire       led_cf;
wire       led_cg;
wire       led_dp;

initial begin
    clk   = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
    #20000;
    $finish;
end

always #5 clk = ~clk;

clk_div u_clk_div (
    .clk_in1  (clk   ),
	.clk_out1 (clk_g ),
	.locked   (locked)
);

wire button_cnt_end = (button_cnt == 4'hf);

always @ (posedge clk_g or negedge rst_n) begin
    if (~rst_n)              button_cnt <= 4'h0;
	else if (button_cnt_end) button_cnt <= 4'h0;
	else                     button_cnt <= button_cnt + 4'h1;
end

wire button_pos = (button_cnt == 4'h1) & locked;

wire button_pos_delay = (button_cnt == 4'h3) & locked;

wire cnt_end = (cnt == 4'h7);

always @ (posedge clk_g or negedge rst_n) begin
    if (~rst_n)          cnt <= 4'h0;
	else if (cnt_end)    cnt <= 4'h0;
	else if (button_pos) cnt <= cnt + 4'h1;
end
 
always @ (*) begin
    case (cnt) 
		4'h1 : func = 3'h0;
		4'h2 : func = 3'h2;
		4'h3 : func = 3'h5;
		4'h4 : func = 3'h1;
		4'h5 : func = 3'h3;
		4'h6 : func = 3'h5;
		4'h7 : func = 3'h4;
		default : func = 3'h0;
	endcase
end

always @ (*) begin
    case (cnt) 
		4'h1 : num1 = 8'h06;
		4'h2 : num1 = 8'h00;
		4'h3 : num1 = 8'h00;
		4'h4 : num1 = 8'h00;
		4'h5 : num1 = 8'h00;
		4'h6 : num1 = 8'h00;
		4'h7 : num1 = 8'h00;
		default : num2 = 8'h00;
	endcase
end

always @ (*) begin
    case (cnt) 
		4'h1 : num2 = 8'h04;
		4'h2 : num2 = 8'h0C;
		4'h3 : num2 = 8'h05;
		4'h4 : num2 = 8'hC8;
		4'h5 : num2 = 8'h08;
		4'h6 : num2 = 8'h00;
		4'h7 : num2 = 8'h08;
		default : num1 = 8'h0;
	endcase
end

integer i;
always @ (posedge clk_g or negedge rst_n) begin
    if (~rst_n) begin
	    for (i=0;i<=7;i=i+1)
		   result[i] <= 32'h0;
	end
	else begin
		result[1] <= 32'h0000000A;
		result[2] <= 32'h00000078;
		result[3] <= 32'h00003840;
		result[4] <= 32'h00003778;
		result[5] <= 32'h000006EF;
		result[6] <= 32'h00301321;
		result[7] <= 32'h00000001;
	end
end

always @ (posedge clk_g or negedge rst_n) begin
    if (~rst_n)          check_cnt <= 8'h0;
	else if (button_pos) check_cnt <= 8'h1;
	else                 check_cnt <= (check_cnt <<1);
end

always @ (posedge clk_g or negedge rst_n) begin
    if (~rst_n) wrong <= 1'b0;
	else if (check_cnt[7]) begin
		wrong <= ~(result[cnt] == `CAL_RESULT);
    end
end	

wire [3:0] cnt_w = cnt - 4'h1;

always @(posedge clk_g) begin
    if(cnt_end) begin
	    $display("index %x finished",cnt_w);
        if(cnt == 4'h7) begin
	        $display("====================================");
	        $display("Test end!");
            $display("----PASS!!!");
	        $finish;
        end
    end
    else if(wrong) begin
	    $display("wrong at index %x",cnt_w);
	    $display("=====================================");
	    $display("Test end!");
        $display("----FAIL!!!");
		$display("function    : %x",func);
		$display("num1        : %x",num1);
		$display("num2        : %x",num2);
		$display("reference   : %x",result[cnt]);
		$display("test module : %x",`CAL_RESULT); 
	    $finish;
    end
end

calculator_top u_calculator_top (
    .clk    (clk             ),
	.rst    (rst             ),
	.button (button_pos_delay),
	.func   (func            ),
	.num1   (num1            ),
	.num2   (num2            ),
 	.led_en (led_en          ),
	.led_ca (led_ca          ),
	.led_cb (led_cb          ),
    .led_cc (led_cc          ),
	.led_cd (led_cd          ),
	.led_ce (led_ce          ),
	.led_cf (led_cf          ),
	.led_cg (led_cg          ),
	.led_dp (led_dp          ) 
);                     

endmodule