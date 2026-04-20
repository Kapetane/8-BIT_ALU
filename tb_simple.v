module tb_booth_wave;
 
    reg clk, rst, start;
    reg  signed [7:0]  M_in, Q_in;
    wire signed [15:0] P;
    wire done, busy;
 
    booth_radix4_seq dut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .M_in  (M_in),
        .Q_in  (Q_in),
        .P     (P),
        .done  (done),
        .busy  (busy)
    );

    initial clk = 0;
    always #5 clk = ~clk;
 
   initial begin
        //Reset initial
        rst = 1; start = 0; M_in = 0; Q_in = 0; #30;
        rst = 0; #10;
 
        // 126 * -127 = -16002
        M_in = 126; Q_in = -127; start = 1; #10;
        start = 0;
        
        
        
    end
 
endmodule