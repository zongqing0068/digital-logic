
//消抖模块
module button_vib(
    input wire clk,//分频后的时钟信号
    input wire rst,//复位信号
    input  wire button,//原启动信号（相当于等号功能）
    output reg button_new//消抖后的启动信号
    );

reg [31:0] cnt; 

always @(posedge clk or posedge rst)
begin
	if(rst)
		cnt <= 32'b0;
	else if(button == 1) begin//只有当启动按键被持续按下满10ms时才视作真正启动
		if(cnt < 100000)//10ms
			cnt <= cnt + 32'b1;
		end
	else
		cnt <= 32'b0;
end

always @(posedge clk or posedge rst) 
begin
	if(rst) button_new <= 1'b0;
	else if(cnt == 99999) button_new <= 1'b1;
	//计数器只可能有一次保持在99999，之后均维持在100000，直至按键被松开
	else button_new <= 1'b0;
end

endmodule
