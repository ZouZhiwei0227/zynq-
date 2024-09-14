module shumaguan(
    clk,
    reset_n,
    disp_data,
    sel,
    seg
    );
    input clk;
    input reset_n;
    input [31:0]disp_data;
    output reg[7:0]sel;
    output reg[7:0]seg;
    
    reg clk_1k;
    reg [15:0]cnt_1ms;
    reg [2:0]cnt_8;
    
//cnt_1ms    
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        cnt_1ms<=0;
    else if(cnt_1ms==49999)
        cnt_1ms<=0;
    else 
        cnt_1ms<=cnt_1ms+1;
//clk_1k,Ê¹ÄÜÊ±ÖÓ
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        clk_1k<=0;
    else if(cnt_1ms==49999)
        clk_1k<=1'b1;
    else 
        clk_1k<=1'b0;

    
//cnt_8
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        cnt_8<=0;
    else if(clk_1k)
        cnt_8<=cnt_8+1;    

//3_8decoder
always@(posedge clk)begin

    case(cnt_8)
        0:sel=8'b0000_0001;
        1:sel=8'b0000_0010;
        2:sel=8'b0000_0100;
        3:sel=8'b0000_1000;
        4:sel=8'b0001_0000;
        5:sel=8'b0010_0000;
        6:sel=8'b0100_0000;
        7:sel=8'b1000_0000;
    
    endcase
    end
    
//data_byte_seg examp:8'h12345678
reg [3:0]disp_temp;
always@(posedge clk)begin

    case(cnt_8)
        0:disp_temp=disp_data[3:0];
        1:disp_temp=disp_data[7:4];
        2:disp_temp=disp_data[11:8];
        3:disp_temp=disp_data[15:12];
        4:disp_temp=disp_data[19:16];
        5:disp_temp=disp_data[23:20];
        6:disp_temp=disp_data[27:24];
        7:disp_temp=disp_data[31:28];
    
    endcase
    end

// lut  
 
always@(posedge clk)begin

    case(disp_temp)
        0:seg=8'hc0;
        1:seg=8'hf9;
        2:seg=8'ha4;
        3:seg=8'hb0;
        4:seg=8'h99;
        5:seg=8'h92;
        6:seg=8'h82;
        7:seg=8'hf8;
        8:seg=8'h80;
        9:seg=8'h90;
        10:seg=8'h88;
        11:seg=8'h83;
        12:seg=8'hc6;
        13:seg=8'ha1;
        14:seg=8'h86;
        15:seg=8'h8e;
        
    
    endcase
    end
endmodule
