module calculator_top (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	input  wire [2:0] func  ,
	input  wire [7:0] num1  ,
	input  wire [7:0] num2  ,
 	output wire [7:0] led_en,
	output wire       led_ca,
	output wire       led_cb,
    output wire       led_cc,
	output wire       led_cd,
	output wire       led_ce,
	output wire       led_cf,
	output wire       led_cg,
	output wire       led_dp 
);

wire        clk_g     ;
wire [31:0] cal_result;
wire locked;
wire button_new;

clk_div u_clk_div (
    .clk_in1  (clk   ),
	.clk_out1 (clk_g ),
	.locked   (locked)
);

calculator_hex u_calculator_hex (
    .clk        (clk_g     ),
	.rst        (rst       ),
    .button     (button),
    .func       (func      ),
    .num1       (num1      ),
    .num2       (num2      ),
	.cal_result (cal_result),
	.button_new (button_new)
);

calculator_display u_calculator_display (
    .clk        (clk_g     ),
	.rst        (rst       ),
	.button     (button_new),
	.cal_result (cal_result),
	.led_en     (led_en    ),
	.led_ca     (led_ca    ),
	.led_cb     (led_cb    ),
	.led_cc     (led_cc    ),
	.led_cd     (led_cd    ),
	.led_ce     (led_ce    ),
	.led_cf     (led_cf    ),
	.led_cg     (led_cg    ),
	.led_dp     (led_dp    )
);

endmodule