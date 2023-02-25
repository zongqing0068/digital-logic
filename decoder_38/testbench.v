`timescale 1ns/1ps

module testbench (
);

reg       clk          ;
reg       rst_n        ;
reg [2:0] enable       ;
reg [2:0] switch       ;
reg [3:0] button_cnt   ;
reg [2:0] cnt          ;
reg       wrong        ;
reg [7:0] result [4:0] ;

wire [7:0] led;

wire rst = ~rst_n;

//initial clk and rst_n
initial begin
    clk = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
	enable = 3'b100;
    #2000;
    $finish;
end

always #5 clk = ~clk;

//test counter
wire button_cnt_end = (button_cnt == 4'hf);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)              button_cnt <= 4'h0;
	else if (button_cnt_end) button_cnt <= 4'h0;
	else                     button_cnt <= button_cnt + 4'h1;
end

wire button_pos = (button_cnt == 4'h1);

wire cnt_end = (cnt == 3'h4);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)          cnt <= 3'h0;
	else if (cnt_end)    cnt <= 3'h0;
	else if (button_pos) cnt <= cnt + 3'h1;
end

//input initial
always @ (*) begin
    case (cnt) 
		3'h1 : switch = 3'b010;
		3'h2 : switch = 3'b100;
		3'h3 : switch = 3'b111;
		default : switch = 3'b000;
	endcase
end

//reference initial
integer i;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
	    for (i=0;i<=7;i=i+1)
		   result[i] <= 8'h0;
	end
	else begin
		result[1] <= 8'b11111011;
		result[2] <= 8'b11101111;
		result[3] <= 8'b01111111;
	end
end

//compare reference and test module
wire check_point = (button_cnt == 4'h5);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) wrong <= 1'b0;
	else if (check_point) begin
		wrong <= ~(result[cnt] == led);
    end
end	

//output test result
wire [2:0] cnt_w = cnt - 3'h1;

always @(posedge clk) begin
    if(cnt_end) begin
	    $display("index %x finished",cnt_w);
        if(cnt == 3'h4) begin
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
		$display("reference   : %x",result[cnt]);
		$display("test module : %x",led);
	    $finish;
    end
end

decoder_38 u_decoder_38 (
    .clk    (clk   ),
	.rst    (rst   ),
	.enable (enable),
	.switch (switch),
	.led    (led   )
);

endmodule 