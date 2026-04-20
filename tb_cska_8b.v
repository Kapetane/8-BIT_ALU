module tb_alu_cska;

    reg signed [7:0] A, B;
    reg cin;
    wire signed [7:0] S;
    wire cout;

    alu_cska_8bit dut (
        .A    (A),
        .B    (B),
        .cin  (cin),
        .S    (S),
        .cout (cout)
    );

    initial begin
        A = 0; B = 0; cin = 0; #10;

        A = 8'sd15; B = 8'sd10; cin = 0; #10;

        A = 8'b0000_1111; B = 8'b0000_0000; cin = 1; #10;

        A = 8'b1111_1111; B = 8'b0000_0000; cin = 1; #10;

        A = -8'sd5; B = -8'sd10; cin = 0; #10;

        A = 8'sd127; B = 8'sd1; cin = 0; #10;

    end

endmodule