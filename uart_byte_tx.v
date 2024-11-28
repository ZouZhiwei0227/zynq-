module uart_byte_tx(
    clk,
    reset_n,
    data,
    send_en,
    uart_tx,
    tx_done
);

input clk;
input reset_n;
input send_en;
input [7:0]data;
output reg tx_done;
output reg [9:0]uart_tx;

parameter   clock_freq=50_000_000;
parameter   baud=9600;
parameter mcnt_baud=clock_freq/baud-1;
//parameter mcnt_delay=50000000-1;
parameter mcnt_byte=10-1;

//reg [25:0]delay_cnt;
reg [29:0]baud_cnt;
reg [3:0]byte_cnt;
reg en_baud;
reg [7:0]r_data;

wire w_tx_done;

////1s的延时计数器
//always@(posedge clk or negedge reset_n)
//    if(!reset_n)
//        delay_cnt<=0;
//    else if(delay_cnt==mcnt_delay)
//        delay_cnt<=0;
//    else
//        delay_cnt<=delay_cnt+1'd1;

//波特率使能
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        en_baud<=0;
    else if(send_en)
        en_baud<=1;
    else if((baud_cnt==mcnt_baud)&&(byte_cnt==mcnt_byte))
        en_baud<=0;
    
//波特率计数器
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        baud_cnt<=0;
    else if(en_baud)
        if(baud_cnt==mcnt_baud)
        baud_cnt<=0;
    else
        baud_cnt<=baud_cnt+1'd1;

//位计数器
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        byte_cnt<=0;
    else if(baud_cnt==mcnt_baud)
        if(byte_cnt==mcnt_byte)
            byte_cnt<=0;
        else
            byte_cnt<=byte_cnt+1'd1;
            
//防止数据跳变寄存器
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        r_data<=0;
    else if(send_en)            
        r_data<=data;
        
//拨码开关传输
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        uart_tx<=1;
    else if(!en_baud)//uart_tx停止态为1；只需要将波特计数器不工作时设置为1
        uart_tx<=1;        
    else begin
    case(byte_cnt)
    0:uart_tx<=1'b0;
    1:uart_tx<=r_data[0];
    2:uart_tx<=r_data[1];
    3:uart_tx<=r_data[2];
    4:uart_tx<=r_data[3];
    5:uart_tx<=r_data[4];
    6:uart_tx<=r_data[5];
    7:uart_tx<=r_data[6];
    8:uart_tx<=r_data[7];
    9:uart_tx<=1'b1;
    default:uart_tx<=uart_tx;
    endcase
    end

assign w_tx_done= (baud_cnt==mcnt_baud)&&(byte_cnt==mcnt_byte);
always@(posedge clk)
        tx_done<=w_tx_done;

   
//led    
//always@(posedge clk or negedge reset_n)
//    if(!reset_n)
//        led<=0;
//    else if((baud_cnt==mcnt_baud)&&(byte_cnt==mcnt_byte))
//        led<=!led;            
endmodule