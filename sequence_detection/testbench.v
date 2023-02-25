`timescale 1ns/1ps

module testbench (
);

reg        clk       ;
reg        rst_n     ;
reg [ 7:0] switch    ;
reg [ 3:0] button_cnt;
reg [ 3:0] cnt       ;
reg [15:0] check_cnt ;
reg        wrong     ;
reg [ 7:0] result    ;

wire led;

wire rst = ~rst_n;

initial begin
    clk = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
    #2000;
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
wire button_pos_delay = (button_cnt == 4'h3);

wire cnt_end = (cnt == 4'h8);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          cnt <= 4'h0;
	else if (cnt_end)    cnt <= 4'h0;
	else if (button_pos) cnt <= cnt + 4'h1;
end

always @ (*) begin
    case (cnt) 
		4'h1 : switch = 8'b00100101;
		4'h2 : switch = 8'b00101001;
		4'h3 : switch = 8'b10110111;
		4'h4 : switch = 8'b01001001;
		4'h5 : switch = 8'b00001101;
		4'h6 : switch = 8'b00100101;
		4'h7 : switch = 8'b01010110;
		default : switch = 8'b00000000;
	endcase
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) result <= 8'h00;
	else        result <= 8'h52;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          check_cnt <= 16'h0;
	else if (button_pos) check_cnt <= 16'h1;
	else                 check_cnt <= (check_cnt <<1);
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) wrong <= 1'b0;
	else if (check_cnt[13]) begin
		wrong <= ~(result[cnt] == led);
    end
end	

wire [3:0] cnt_w = cnt - 4'h1;

always @(posedge clk) begin
    if (cnt_end) begin
	    $display("index %x finished",cnt_w);
        if (cnt == 4'h8) begin
	        $display("====================================");
	        $display("Test end!");
            $display("----PASS!!!");
	        $finish;
        end
    end
    else if (wrong) begin
	    $display("wrong at index %x",cnt_w);
	    $display("=====================================");
	    $display("Test end!");
        $display("----FAIL!!!");
		$display("test sequence : %b",switch);
		$display("reference     : %x",result[cnt]);
		$display("test module   : %x",led);
	    $finish;
    end
end

sequence_detection u_sequence_detection (
    .clk    (clk   ),
	.rst    (rst   ),
	.button (button_pos_delay),
	.switch (switch),
	.led    (led   )
);

endmodule