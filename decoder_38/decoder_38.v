module decoder_38 (
    input  wire       clk,
	input  wire       rst,
	input  wire [2:0] enable,
	input  wire [2:0] switch,
	output reg  [7:0] led
);

wire rst_n = ~rst;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) led <= 8'b00000000;
    else if (enable[0] || enable[1] || !enable[2]) led <= 8'b11111111;
	else
	   case(switch)
	       3'b000: led <= 8'b11111110;
	       3'b001: led <= 8'b11111101;
	       3'b010: led <= 8'b11111011;
	       3'b011: led <= 8'b11110111;
	       3'b100: led <= 8'b11101111;
	       3'b101: led <= 8'b11011111;
	       3'b110: led <= 8'b10111111;
	       3'b111: led <= 8'b01111111;
	       endcase
end

endmodule