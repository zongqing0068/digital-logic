module led_display_ctrl (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led_en,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
);

reg ena=0;
reg [31:0] cnt_time = 32'h0;
reg [31:0] cnt_num = 32'h0;
reg [31:0] num_end = 32'd5;
reg [31:0] time_end = 32 'd100000000;
integer now_time1, now_time2;
integer switch;

assign led_dp = 1;

always@(*)
begin
    if(rst) {led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} = 7'b1111111;
    else begin
        case(switch)
            0:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0000001;
            1:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1001111;
            2:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0010010;
            3:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0000110;
            4:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b1001100;
            5:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0100100;
            6:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0100000;
            7:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0001111;
            8:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0000000;
            9:{led_ca,led_cb,led_cc,led_cd,led_ce,led_cf,led_cg} <= 7'b0001100;
        endcase 
    end           
end  


always@(posedge clk or posedge rst)
begin
    if(ena) begin
        if(button || rst) cnt_num <= 32'h0;
        else if(cnt_num == num_end) cnt_num <= 32'h0;
        else cnt_num <= cnt_num + 32'h1;
        end
end 

always@(posedge clk or posedge rst)
begin
    if(ena) begin
        if(rst || button) cnt_time <= 32'h0;
        else if(cnt_time == time_end) cnt_time <= 32'h0;
        else cnt_time <= cnt_time + 32'h1;
        end
end

always@(posedge clk or posedge rst)
begin
    if(rst ) begin
        now_time1 <= 1;
        now_time2 <= 0;
        end
    else if(ena) begin
        if(button) begin
        now_time1 <= 1;
        now_time2 <= 0;
        end
        else if(cnt_time == time_end && now_time1 == 1 && now_time2 == 0) begin
            now_time1 <= 0;
            now_time2 <= 9;
        end
        else if(cnt_time == time_end && now_time1 == 0 && now_time2 == 0) begin
            now_time1 <= 1;
            now_time2 <= 0;
        end
        else if(cnt_time == time_end && now_time1 == 0) now_time2 <= now_time2 -1;
        end
end 

always@(posedge clk or posedge rst)
begin
    if(rst) begin
        ena <= 0;
        led_en <= 8'b11111111;
        
    end
    else if(button) begin
        ena <= 1;
        led_en <= 8'b11111110;
    end
    else if(ena) begin
        if(cnt_num == num_end)
        begin
            led_en <= {led_en[6:0], led_en[7]};
            case(led_en)
                8'b01111111: switch <= now_time1;
                8'b10111111: switch <= now_time2;
                8'b11011111: switch <= 2;
                8'b11101111: switch <= 0;
                8'b11110111: switch <= 0;
                8'b11111011: switch <= 5;
                8'b11111101: switch <= 1;
                8'b11111110: switch <= 3;
            endcase
        end
    end
        
end


endmodule