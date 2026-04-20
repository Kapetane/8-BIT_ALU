//     BR4 table:
//     000 ->  0      100 -> -2M
//     001 -> +M      101 -> -M
//     010 -> +M      110 -> -M
//     011 -> +2M     111 ->  0
module booth_encoder (
    input [2:0] booth_bits,   // {Q[1], Q[0], Q[-1]}
    input signed [8:0] M,            
    output reg signed [8:0] add_val       
);

    always @(*) begin
        case (booth_bits)
            3'b000: add_val =  9'sd0;      //  0
            3'b001: add_val =  M;           // +M
            3'b010: add_val =  M;           // +M
            3'b011: add_val =  (M <<< 1);   // +2M
            3'b100: add_val = -(M <<< 1);   // -2M
            3'b101: add_val = -M;           // -M
            3'b110: add_val = -M;           // -M
            3'b111: add_val =  9'sd0;      //  0
            default: add_val = 9'sd0;
        endcase
    end

endmodule
