module booth_shifter (
    input signed [8:0] A_after,   
    input [7:0] Q_in,     
    output signed [8:0] new_A,     
    output [7:0] new_Q,     
    output new_Q1     
);
    assign new_A  = { A_after[8], A_after[8], A_after[8:2] };
    assign new_Q  = { A_after[1:0], Q_in[7:2] };
    assign new_Q1 = Q_in[1];

endmodule
