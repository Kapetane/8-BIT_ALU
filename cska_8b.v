module alu_cska_8bit (
    input signed [7:0] A,
    input signed [7:0] B,
    input cin,
    output signed [7:0] S,
    output cout
);

    wire c4_rca;
    wire bp0;
    wire c4_skip;

    wire c8_rca;
    wire bp1;


    rca_4bit u_rca0 (
        .a    (A[3:0]),
        .b    (B[3:0]),
        .cin  (cin),
        .sum  (S[3:0]),
        .cout (c4_rca),
        .bp   (bp0)
    );

    assign c4_skip = bp0 ? cin : c4_rca;

    rca_4bit u_rca1 (
        .a    (A[7:4]),
        .b    (B[7:4]),
        .cin  (c4_skip),
        .sum  (S[7:4]),
        .cout (c8_rca),
        .bp   (bp1)
    );


    assign cout = bp1 ? c4_skip : c8_rca;

endmodule