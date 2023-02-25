
//顶层模块
module calculator_top (
    input  wire       clk   ,//原时钟信号（100MHz）
	input  wire       rst   ,//复位信号
	input  wire       button,//原启动信号（相当于等号功能）
	input  wire [2:0] func  ,//运算功能选择信号
	input  wire [7:0] num1  ,//操作数1
	input  wire [7:0] num2  ,//操作数2
 	output wire [7:0] led_en,//数码管显示控制使能端
	output wire       led_ca,//数码管显示控制信号
	output wire       led_cb,
    output wire       led_cc,
	output wire       led_cd,
	output wire       led_ce,
	output wire       led_cf,
	output wire       led_cg,
	output wire       led_dp 
);

wire        clk_g     ;//分频后的时钟信号
wire [31:0] cal_result;//用二进制表示的计算结果
wire locked;
wire button_new;//消抖后的启动信号

//实例化四个模块
clk_div u_clk_div (
    .clk_in1  (clk   ),
	.clk_out1 (clk_g ),
	.locked   (locked)
);

calculator_hex u_calculator_hex (
    .clk        (clk_g     ),
	.rst        (rst       ),
    .button     (button_new),
    .func       (func      ),
    .num1       (num1      ),
    .num2       (num2      ),
	.cal_result (cal_result)
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

button_vib u_button_vib (
    .clk        (clk_g     ),
	.rst        (rst       ),
    .button     (button	   ),
	.button_new (button_new)
);

endmodule