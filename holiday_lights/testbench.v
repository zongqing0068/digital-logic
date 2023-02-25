`timescale 1ns/1ps

module testbench (
);

reg        clk       ;
reg        rst_n     ;
reg [ 2:0] switch    ;
reg [ 3:0] button_cnt;
reg [ 3:0] cnt       ;
reg [ 7:0] check_cnt ;
reg        wrong     ;

wire [15:0] led;

wire rst = ~rst_n;

initial begin
    clk   = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
    #200000;
    $finish;
end

always #5 clk = ~clk;

wire button_cnt_end = (button_cnt == 4'hf);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)              button_cnt <= 4'h0;
	else if (button_cnt_end) button_cnt <= 4'h0;
	else                     button_cnt <= button_cnt + 4'h1;
end

wire button_pos = (button_cnt == 4'h1);

wire cnt_end = (cnt == 4'h7);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          cnt <= 4'h0;
	else if (cnt_end)    cnt <= 4'h0;
	else if (button_pos) cnt <= cnt + 4'h1;
end

always @ (*) begin
    case (cnt) 
		4'h1 : switch = 3'h0;
		4'h2 : switch = 3'h1;
		4'h3 : switch = 3'h2;
		4'h4 : switch = 3'h3;
		4'h5 : switch = 3'h4;
		4'h6 : switch = 3'h5;
		4'h7 : switch = 3'h6;
		default : switch = 3'h0;
	endcase
end

wire [3:0] result = switch + 4'h1;

wire [3:0] led_num = led[0] + led[1] + led[2] + led[3] + led[4] + led[5] + led[6] + led[7] + 
                     led[8] + led[9] + led[10] + led[11] + led[12] + led[13] + led[14] + led[15];

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          check_cnt <= 8'h0;
	else if (button_pos) check_cnt <= 8'h1;
	else                 check_cnt <= (check_cnt <<1);
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) wrong <= 1'b0;
	else if (check_cnt[7]) begin
		wrong <= ~(result == led_num);
    end
end	

wire [3:0] cnt_w = cnt - 4'h1;

always @(posedge clk) begin
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
		$display("reference   led_num : %x",result);
		$display("test module led_num : %x",led_num);
	    $finish;
    end
end

holiday_lights u_holiday_lights (
    .clk    (clk       ),
	.rst    (rst       ),
	.button (button_pos),
    .switch (switch    ),
	.led    (led       )
);

endmodule