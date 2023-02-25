module memory_top (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
	output wire [15:0] led   
);

wire clk_g, mem_ena, mem_wea, locked;
wire [15:0] mem_douta;
wire [3:0] mem_addra;
wire [15:0] mem_dina;

clk_div u_clk_div (
    . clk_in1(clk),
    . clk_out1(clk_g),
    . locked(locked)
);

memory_w_r u_memory_w_r (
    . clk_g(clk_g),
    . rst(rst),
    . button(button),
    . mem_douta(mem_douta),
    . led(led),
    . mem_ena(mem_ena),
    . mem_wea(mem_wea),
    . mem_addra(mem_addra),
    . mem_dina(mem_dina)
);

led_mem u_led_mem (
    . ena(mem_ena),
    . wea(mem_wea),
    . addra(mem_addra),
    . dina(mem_dina),
    . clka(clk_g),
    . douta(mem_douta)
);

endmodule