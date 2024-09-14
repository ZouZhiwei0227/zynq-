module uart_rx_test(
    clk,
    reset_n,
    uart_rx,
    rx_data,
    led

);
input clk;
input reset_n;
input uart_rx;
output [7:0]rx_data;
output reg led;

wire rx_done;

uart_byte_rx uart_rx_test(
    .clk(clk),
    .reset_n(reset_n),
    .uart_rx(uart_rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);
defparam uart_rx_test.baud=9600;

always@(posedge clk or negedge reset_n)
    if(!reset_n)
        led<=0;
    else if(rx_done)
        led<=~led;


endmodule