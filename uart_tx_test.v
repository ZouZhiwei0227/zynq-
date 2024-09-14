module uart_tx_test(
    reset_n,
    clk,
    data,
    uart_tx,
    led

);
input reset_n;
input clk;
input [7:0]data;
output uart_tx;
output reg led;

wire send_en;
wire tx_done;


uart_byte_tx uart_tx_test(
    .clk(clk),
    .reset_n(reset_n),
    .data(data),
    .send_en(send_en),
    .uart_tx(uart_tx),
    .tx_done(tx_done)
);
defparam uart_tx_test.baud=115200;

parameter mcnt_delay=50000000-1;
reg [25:0]delay_cnt;
//延时计数器
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        delay_cnt<=0;
    else if(delay_cnt==mcnt_delay)
        delay_cnt<=0;
    else
        delay_cnt<=delay_cnt+1'd1;

assign send_en=(delay_cnt==mcnt_delay)?1:0;
        
//led翻转
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        led<=0;
    else if(tx_done)
        led<=!led;



endmodule