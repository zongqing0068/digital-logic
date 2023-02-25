`timescale 1ns/1ps

module testbench (
);

reg        clk       ;
reg        rst_n     ;
reg [ 3:0] button_cnt;
reg [ 3:0] cnt       ;
reg [ 7:0] check_cnt ;
reg        wrong     ;

wire [7:0] led;

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

wire [3:0] led_num = led[0] + led[1] + led[2] + led[3] + led[4] + led[5] + led[6] + led[7];

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          check_cnt <= 8'h0;
	else if (button_pos) check_cnt <= 8'h1;
	else                 check_cnt <= (check_cnt <<1);
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) wrong <= 1'b0;
	else if (check_cnt[7]) begin
		wrong <= ~(led_num == 4'h1);
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
	    $finish;
    end
end

flowing_water_lights u_flowing_water_lights (
    .clk    (clk       ),
	.rst    (rst       ),
	.button (button_pos),
	.led    (led       )
);

endmodule