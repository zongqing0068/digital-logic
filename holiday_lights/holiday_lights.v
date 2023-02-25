module holiday_lights (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
    input  wire [ 2:0] switch,
	output reg  [15:0] led
);

wire rst_n = ~rst;
reg [31:0] cnt = 32'h0;
reg flag;
reg [2:0] switch0=16'b0;

always@(posedge clk or negedge rst_n) begin
    if(switch0!=switch) begin
        led <= 16'b0;
        switch0 = switch;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) flag <= 1'b0;
    else if (button) flag <= 1'b1;
end

always@(posedge clk or negedge rst_n)
begin
    if(flag) begin
        if(~rst_n) cnt <= 32'h0;
        else if(cnt == 32'd100000000) cnt <= 32'h0;
        else cnt <= cnt + 32'h1;
        end
end

always@(posedge clk or negedge rst_n)
begin
    if(~rst_n) 
	   led <= 16'b0;
    else if(flag) begin
        if(led == 16'b0)begin
            case(switch)
	           3'b000: led <= 16'b1;
	           3'b001: led <= 16'b11;
	           3'b010: led <= 16'b111;
	           3'b011: led <= 16'b1111;
	           3'b100: led <= 16'b11111;
	           3'b101: led <= 16'b111111;
	           3'b110: led <= 16'b1111111;
	           3'b111: led <= 16'b11111111;
	        endcase
	    end
        if(cnt == 32'd100000000) led <= {led[14:0], led[15]};
    end
end


endmodule