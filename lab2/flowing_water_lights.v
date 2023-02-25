module flowing_water_lights (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led
);
wire rst_n = ~rst;
reg [31:0] cnt = 32'h0;
reg flag;


always@(posedge clk or negedge rst_n) begin
    if (~rst_n) flag <= 1'b0;
    else if (button) flag <= 1'b1;
end

always@(posedge clk or negedge rst_n)
begin
    if(flag) begin
        if(~rst_n) cnt <= 32'h0;
        else if(cnt == 32 'd100000000) cnt <= 32'h0;
        else cnt <= cnt + 32'h1;
        end
end

always@(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        led <= 8'b00000000;
    else if(flag) begin
        if(led == 8'b00000000) led <= 8'b00000001;
        if(cnt == 32 'd100000000) led <= {led[6:0], led[7]};
    end
end



endmodule