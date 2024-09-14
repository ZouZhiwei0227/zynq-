module hex8_hc595_test(
    clk,
    reset_n,
    sw,
    srclk,
    rclk,
    dio
    );
    input clk;
    input reset_n;
    input [1:0]sw;
    output  srclk;
    output  rclk;
    output  dio;
    wire [7:0]seg;
    wire [7:0]sel;
    reg [31:0]disp_data;

shumaguan shumaguan_tb(
    .clk(clk),
    .reset_n(reset_n),
    .disp_data(disp_data),
    .sel(sel),
    .seg(seg)
    );
hc595_driver hc595_dri_tb(
    .clk(clk),
    .reset_n(reset_n),
    .sel(sel),
    .seg(seg),
    .srclk(srclk),
    .rclk(rclk),
    .dio(dio)
    );
    
    always@(*)
        case(sw)
        0:disp_data<=32'h12345678;
        1:disp_data<=32'h9abcdef0;
        2:disp_data<=32'h55522100;
        3:disp_data<=32'h66622211;
        default:disp_data<=disp_data;
        endcase
endmodule
