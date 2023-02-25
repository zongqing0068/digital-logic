module key_vibration(
    input		  	 clk,
	input		  	 rst,
	input	         button,
	output reg       button_new
	);
	
	reg [15:0] cnt; 
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			cnt <= 11'd0;
		else if(button == 1) begin
			if(cnt == 50000)
				cnt <= cnt;
			else 
				cnt <= cnt + 1'b1;
			end
		else
			cnt <= 16'b0;
	end
	
	always @(posedge clk or posedge rst) 
	begin
		if(rst) button_new <= 4'd0;
		else button_new <= (cnt == 49999) ? 1'b1 : 1'b0;
	end
	
endmodule