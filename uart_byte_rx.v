module uart_byte_rx(
    clk,
    reset_n,
    uart_rx,
    rx_data,
    rx_done
);

input clk;
input reset_n;
input uart_rx;
output rx_data;
output rx_done;

parameter clock_freq=50_000_000;
parameter baud=115200;
parameter mcnt_baud=clock_freq/baud-1;
parameter mcnt_byte=10-1;

reg [29:0]baud_cnt;
reg en_baud_cnt;
reg [4:0]byte_cnt;
reg [7:0]rx_data;
reg r_uart_rx;
reg rx_done;

reg [7:0]r_rx_data;
reg dff0_uart_rx,dff1_uart_rx;//同步操作，消除亚稳态影响

wire uart_rx_nedge;
wire w_rx_done;

//uart信号边沿检测,D触发器，现态赋值给次态
always@(posedge clk)//打拍
    dff0_uart_rx<=uart_rx;
always@(posedge clk)
    dff1_uart_rx<=dff0_uart_rx;    
always@(posedge clk)
    r_uart_rx<=dff1_uart_rx;//uart_rx现态，r_uart_rx次态

assign uart_rx_nedge=((dff1_uart_rx==0)&&(r_uart_rx==1));//下降沿次态为1，现态为0

//波特率计数器使能
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        en_baud_cnt<=0;
    else if(uart_rx_nedge)//start
        en_baud_cnt<=1;
    else if((baud_cnt==mcnt_baud/2-1)&&(dff1_uart_rx==1)&&(byte_cnt==0))//毛刺信号
        en_baud_cnt<=0;
    else if((baud_cnt==mcnt_baud/2)&&(byte_cnt==mcnt_byte)) //stop防止发送端与接收端误差
        en_baud_cnt<=0;   

//波特率计数器
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        baud_cnt<=0;
    else if(en_baud_cnt)begin
        if(baud_cnt==mcnt_baud)
            baud_cnt<=0;
        else 
            baud_cnt<=baud_cnt+1'b1;
     end
     else
        baud_cnt<=0;

//位计数器
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        byte_cnt<=0;
    else if((baud_cnt==mcnt_baud/2)&&(byte_cnt==mcnt_byte))
        byte_cnt<=0;
    else if(baud_cnt==mcnt_baud)
            byte_cnt<=byte_cnt+1'b1;
            
//位接收
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        r_rx_data<=8'b0;
    else if(baud_cnt==mcnt_baud/2-1)begin//中点取样保持稳定
        case(byte_cnt)
        1:r_rx_data[0]<=dff1_uart_rx;
        2:r_rx_data[1]<=dff1_uart_rx;
        3:r_rx_data[2]<=dff1_uart_rx;
        4:r_rx_data[3]<=dff1_uart_rx;
        5:r_rx_data[4]<=dff1_uart_rx;
        6:r_rx_data[5]<=dff1_uart_rx;
        7:r_rx_data[6]<=dff1_uart_rx;
        8:r_rx_data[7]<=dff1_uart_rx;
        default r_rx_data=r_rx_data;
        endcase
        end

//rx_done最好用时序
assign w_rx_done=((baud_cnt==mcnt_baud/2)&&(byte_cnt==mcnt_byte));
always@(posedge clk )
    rx_done<=w_rx_done;
//data寄存器，传输结果一步显示
always@(posedge clk)
//    if(!reset_n)
//        rx_data<=8'b0;能不加复位就不加复位，优化布局布线
     if(w_rx_done)
        rx_data<= r_rx_data;   
       

endmodule