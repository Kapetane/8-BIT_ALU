module non_restoring_divider (
    input clk,
    input reset,
    input start,
    input [15:0] dividend,
    input [7:0] divisor, 
    output [7:0] quotient,
    output [7:0] remainder,
    output reg done
);

    reg [7:0] A, Q, M;
    reg [7:0] A_next;   
    reg [3:0] count;
    reg [2:0] state;

    wire [7:0] sum_out;

    wire ctrl_sub = ~A_next[7];


    wire [7:0] M_xor;
    
    assign M_xor = M ^ {8{ctrl_sub}}; 

    alu_cska_8bit add_sub_unit (
        .A    (A),
        .B    (M_xor),
        .cin  (ctrl_sub),
        .S    (sum_out),
        .cout ()         
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            done <= 0;
            count <= 0;
            A <= 0;
            Q <= 0;
            M <= 0;
            A_next <= 0;
        end else begin
            case (state)

                //INIT 
                0: begin
                    done <= 0;
                    if (start) begin
                        A <= dividend[15:8];
                        Q <= dividend[7:0];
                        M <= divisor;
                        count <= 0;
                        A_next <= 0;
                        state <= 1;
                    end
                end

                //SHIFT
                1: begin
                    A <= {A[6:0], Q[7]};
                    Q <= {Q[6:0], 1'b0};
                    state <= 2;
                end

                //ADD/SUB
                2: begin
                    A <= sum_out;
                    A_next <= sum_out;  
                    state <= 3;
                end

                //UPDATE Q
                3: begin
                    if (A_next[7] == 0)
                        Q[0] <= 1;
                    else
                        Q[0] <= 0;

                    if (count == 7)
                        state <= 4;
                    else begin
                        count <= count + 1;
                        state <= 1;
                    end
                end

                //CORRECTION
                4: begin
                    if (A_next[7] == 1)
                        A <= A + M;

                    state <= 5;
                end

                //DONE 
                5: begin
                    done <= 1;
                    if (!start)
                        state <= 0;
                end

            endcase
        end
    end

    assign quotient = Q;
    assign remainder = A;

endmodule

module tb_divider_explicit;
    reg clk;
    reg reset;
    reg start;
    reg [15:0] dividend;
    reg [7:0] divisor;

    wire [7:0] quotient;
    wire [7:0] remainder;
    wire done;

    non_restoring_divider dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        dividend = 0;
        divisor = 0;

        #25 reset = 0;
        #20;

        //Exemplu 1: 3811 / 75)
        //Asteptat: Q = 50, R = 61
        dividend = 16'd3811; 
        divisor = 8'd75;
        #10 start = 1; //Activam semnalul start
        #10 start = 0; //Il dezactivam dupa un impuls de ceas
        
        wait(done == 1); //Asteptam ca hardware-ul s? termine
        #10;
        $display("TEST 1: 3811 / 75 | Rezultat: Q=%d, R=%d", quotient, remainder);
        #40;               

        //Exemplu 2 (7381 / 116) ---
        // Asteptat: Q = 63, R = 73
        dividend = 16'd7381; 
        divisor = 8'd116;
        #10 start = 1;
        #10 start = 0;
        
        wait(done == 1);
        #10;
        $display("TEST 2: 7381 / 116 | Rezultat: Q=%d, R=%d", quotient, remainder);
        #40;

        //Exemplu 3 (2932 / 57) ---
        // Asteptat: Q = 51, R = 25
        dividend = 16'd2932; 
        divisor = 8'd57;
        #10 start = 1;
        #10 start = 0;
        
        wait(done == 1);
        #10;
        $display("TEST 3: 2932 / 57 | Rezultat: Q=%d, R=%d", quotient, remainder);
        #50;
        $display("Toate testele au fost rulate!");
        
    end

endmodule
