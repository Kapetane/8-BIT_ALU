module booth_radix4_seq (
    input clk,
    input rst,
    input start,
    input signed [7:0] M_in,
    input signed [7:0] Q_in,
    output signed [15:0] P,
    output done,
    output busy
);

    wire load;
    wire shift_en;
    wire [2:0] count_out;

    booth_ctrl u_ctrl (
        .clk       (clk),
        .rst       (rst),
        .start     (start),
        .count_out (count_out),
        .load      (load),
        .shift_en  (shift_en),
        .done      (done),
        .busy      (busy)
    );

    booth_datapath u_datapath (
        .clk       (clk),
        .rst       (rst),
        .load      (load),
        .shift_en  (shift_en),
        .M_in      (M_in),
        .Q_in      (Q_in),
        .P         (P),
        .count_out (count_out)
    );

endmodule
