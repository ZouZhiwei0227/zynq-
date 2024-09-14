module hc595_driver(
    clk,
    reset_n,
    sel,
    seg,
    srclk,
    rclk,
    dio
    );

    input clk;
    input reset_n;
    input [7:0]seg;
    input [7:0]sel;

    output reg srclk;
    output reg rclk;
    output reg dio;
    
    parameter clock_freq=50_000_000;
    parameter srclk_freq=12_500_000;
    parameter mcnt_div=clock_freq/(srclk_freq*2)-1;
    parameter mcnt_srclk_edge=32-1;
    reg [31:0]divider_cnt;
    reg [4:0]srclk_edge_cnt;


//产生25Mhz使能时钟    
    always@(posedge clk or negedge reset_n)
        if(reset_n==0)
            divider_cnt<=0;
        else if(divider_cnt==mcnt_div)
            divider_cnt<=0;
        else
            divider_cnt<=divider_cnt+1'b1;

        
//16个数据，需要32次使能时钟
    always@(posedge clk or negedge reset_n)
        if(reset_n==0)
            srclk_edge_cnt<=0;
        else if(divider_cnt==mcnt_div)
            srclk_edge_cnt<=srclk_edge_cnt+1'b1;   
    
//使能时钟控制srclk、rclk    
    always@(posedge clk or negedge reset_n)
        if(!reset_n)begin
            dio<=1'b0;
            srclk<=1'b0;
            rclk<=1'b0;
         end
         else begin
            case(srclk_edge_cnt)
            0:begin dio<=seg[7]; srclk<=1'b0; rclk<=1'b1; end
            1:begin srclk<=1'b1; rclk<=1'b0; end
            2:begin dio<=seg[6]; srclk<=1'b0; end
            3:begin srclk<=1'b1; end
            4:begin dio<=seg[5]; srclk<=1'b0;  end
            5:begin srclk<=1'b1; end
            6:begin dio<=seg[4]; srclk<=1'b0; end
            7:begin srclk<=1'b1;  end
            8:begin dio<=seg[3]; srclk<=1'b0;  end
            9:begin srclk<=1'b1;  end
            10:begin dio<=seg[2]; srclk<=1'b0;  end
            11:begin srclk<=1'b1;  end
            12:begin dio<=seg[1]; srclk<=0;  end
            13:begin srclk<=1'b1;  end
            14:begin dio<=seg[0]; srclk<=1'b0;  end
            15:begin srclk<=1'b1;  end
            16:begin dio<=sel[7]; srclk<=1'b0; end
            17:begin srclk<=1'b1;  end
            18:begin dio<=sel[6]; srclk<=1'b0;end
            19:begin srclk<=1'b1;  end
            20:begin dio<=sel[5]; srclk<=1'b0; end
            21:begin srclk<=1'b1;  end
            22:begin dio<=sel[4]; srclk<=1'b0; end
            23:begin srclk<=1'b1;  end
            24:begin dio<=sel[3]; srclk<=1'b0;end
            25:begin srclk<=1'b1;  end
            26:begin dio<=sel[2]; srclk<=1'b0; end
            27:begin srclk<=1'b1;  end
            28:begin dio<=sel[1]; srclk<=1'b0; end
            29:begin srclk<=1'b1;  end
            30:begin dio<=sel[0]; srclk<=1'b0; end
            31:begin srclk<=1'b1;  end
           endcase
           end
    
endmodule
