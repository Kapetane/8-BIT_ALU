module booth_datapath (
    input clk,
    input rst,
    input load,       
    input shift_en,  
 
    input signed [7:0] M_in,
    input signed [7:0] Q_in,
    output signed [15:0] P,
    output [2:0]  count_out
);

    reg signed [8:0] A;
    reg [7:0] Q;
    reg Q1;
    reg signed [8:0] M;
    reg [2:0] count;
    wire [2:0] booth_bits ;
    wire signed [8:0] add_val;
    wire signed [8:0] A_after;
    wire signed [8:0] new_A;
    wire [7:0] new_Q;
    wire new_Q1;
assign booth_bits = {Q[1], Q[0], Q1};
    booth_encoder u_encoder (
        	.booth_bits (booth_bits),
        	.M          (M),
        	.add_val    (add_val)
    	);


    assign A_after = A + add_val;


    booth_shifter u_shifter (
        	.A_after (A_after),
        	.Q_in    (Q),
        	.new_A   (new_A),
        	.new_Q   (new_Q),
        	.new_Q1  (new_Q1)
   	 );

    always @(posedge clk) begin
        if (rst) begin
            A <= 9'sd0;
            Q <= 8'b0;
            Q1 <= 1'b0;
            M <= 9'sd0;
            count <= 3'd0;
        end
        else if (load) begin
            M <= { M_in[7], M_in };
            Q <= Q_in;
            A <= 9'sd0;
            Q1 <= 1'b0;
            count <= 3'd0;
        end
        else if (shift_en) begin
            A <= new_A;
            Q <= new_Q;
            Q1 <= new_Q1;
            count <= count + 1;
        end
    end

    //Output
    assign P = { A[7:0], Q[7:0] };
    assign count_out = count;

endmodule
