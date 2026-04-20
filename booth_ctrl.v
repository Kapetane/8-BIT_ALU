module booth_ctrl (
    input clk,
    input rst,
    input start,
    input [2:0] count_out,
    output reg load,
    output reg shift_en,
    output reg done,
    output reg busy
);


    reg running;

    always @(posedge clk) begin
        if (rst) begin
            load     <= 1'b0;
            shift_en <= 1'b0;
            done     <= 1'b0;
            busy     <= 1'b0;
            running  <= 1'b0;
        end else begin

            load     <= 1'b0;
            shift_en <= 1'b0;
            done     <= 1'b0;

            if (start) begin
                load    <= 1'b1;
                busy    <= 1'b1;
                running <= 1'b1;
            end else if (running) begin
                
                if (count_out < 3'd3) begin 
                    shift_en <= 1'b1;
                    busy     <= 1'b1;
                end else begin
                    done     <= 1'b1;
                    busy     <= 1'b0;
                    running  <= 1'b0;
                end
            end
        end
    end
endmodule
