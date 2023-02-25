module sequence_detection (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	input  wire [7:0] switch,
	output reg        led
);

parameter IDLE = 3'b000;
parameter s0 = 3'b001;
parameter s1 = 3'b010;
parameter s2 = 3'b011;
parameter s3 = 3'b100;
parameter s4 = 3'b101;
integer cnt;

reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk or posedge rst) begin
	if(rst) cnt <= 7;
	else if(button) cnt <= 7;
	else cnt <= cnt-1;
end


always @(posedge clk or posedge rst) begin
	if(rst) current_state <= IDLE;
	else	current_state <= next_state;
end

always @(*) begin
	case(current_state)
		IDLE :  if(button) next_state = s0;
				else next_state = IDLE;
		s0	 :  if(cnt < 0) next_state = IDLE;
				else if(switch[cnt]) next_state = s1;
				else next_state = s0;
		s1	 :	if(cnt < 0) next_state = IDLE;
				else if(switch[cnt]) next_state = s1;
				else next_state = s2;
		s2	 :	if(cnt < 0) next_state = IDLE;
				else if(switch[cnt]) next_state = s1;
				else next_state = s3;
		s3	 :	if(cnt < 0) next_state = IDLE;
				else if(switch[cnt]) next_state = s4;
				else next_state = s0;
		s4	 :	if(cnt < 0 || switch[cnt]) next_state = IDLE;
				else next_state = s0;
		default :next_state = IDLE;
	endcase
end

always @(posedge clk or posedge rst) begin
	if(rst) led <= 0;
	else if(button) led <= 0;
	else if(current_state == s4 && cnt >=0 && switch[cnt] == 0) led <= 1;
end


endmodule
