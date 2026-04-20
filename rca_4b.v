module rca_4bit (
    input [3:0] a, 
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout, 
    output bp 
);

    wire [4:0] c;
    wire [3:0] p;
    
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : fa_loop
            full_adder u_fa (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (c[i]),
                .sum  (sum[i]),
                .cout (c[i+1]),
                .p    (p[i])
            );
        end
    endgenerate

    assign cout = c[4];
    assign bp = p[0] & p[1] & p[2] & p[3];

endmodule