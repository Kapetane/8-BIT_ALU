module alu_control_unit (
    input clk,
    input reset,
    input start,               
    input [1:0] opcode, //00=Adunare,01=Scadere,10=Inmultire,11=Impartire
    input [15:0] op1, //16-bit pentru a suporta deimpartitul.(Pt +,-,* folosim doar op1[7:0])
    input [7:0]  op2, //8-bit(divisor, inmultitor, scazator, 'adunator')
    
    output reg [15:0] result, //Rezultatul operatiei
    output reg done_all //semnal ca e gata
);

    //Stari FSM
    localparam IDLE       = 3'b000;
    localparam WAIT_MULT  = 3'b001;
    localparam WAIT_DIV   = 3'b010;
    localparam DONE_STATE = 3'b011;

    reg [2:0] state;

    //Semnale interne pentru Add/Sub
    wire [7:0] add_sub_A;
    wire [7:0] add_sub_B;
    wire add_sub_cin;
    wire [7:0] sum_out;
    
    //Blocam intrarile sumatorului pe 0 daca operatia nu este 00(+) sau 01(-)
    wire is_add_sub = (opcode == 2'b00 || opcode == 2'b01);
    assign add_sub_A   = is_add_sub ? op1[7:0] : 8'b0;
    
    //Daca e scadere, inversam op2 bit cu bit.Altfel ramane op2.
    assign add_sub_B   = is_add_sub ? ((opcode == 2'b01) ? ~op2 : op2) : 8'b0;
    //Daca e scadere, avem nevoie de +1 la carry in pt C2
    assign add_sub_cin = (opcode == 2'b01) ? 1'b1 : 1'b0;

    
    alu_cska_8bit adder_unit (
        .A(add_sub_A),
        .B(add_sub_B),
        .cin(add_sub_cin),
        .S(sum_out),
        .cout()
    );

    reg start_mult;
    wire done_mult, busy_mult;
    wire [15:0] mult_out;

    booth_radix4_seq mult_unit (
        .clk(clk),
        .rst(reset),
        .start(start_mult),
        .M_in(op1[7:0]),
        .Q_in(op2),
        .P(mult_out),
        .done(done_mult),
        .busy(busy_mult)
    );

    //Semnale Impartitor
    reg start_div;
    wire done_div;
    wire [7:0] quotient_out, remainder_out;

    non_restoring_divider div_unit (
        .clk(clk),
        .reset(reset),
        .start(start_div),
        .dividend(op1),
        .divisor(op2),
        .quotient(quotient_out),
        .remainder(remainder_out),
        .done(done_div)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state      <= IDLE;
            result     <= 0;
            done_all   <= 0;
            start_mult <= 0;
            start_div  <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_all <= 0;
                    start_mult <= 0;
                    start_div <= 0;
                    
                    if (start) begin
                        case (opcode)
                            2'b00, 2'b01: begin
                                //+ si - (Combinational)
                                result <= {8'b0, sum_out};//Punem rezultatul de 8 biti intr-un format de 16
                                state <= DONE_STATE;
                            end
                            2'b10: begin
                                //Inmultire (Secvential)
                                start_mult <= 1;//start doar la inmultitor
                                state <= WAIT_MULT;
                            end
                            2'b11: begin
                                //Impartire (Secvential)
                                start_div <= 1; // start doar impartitor
                                state <= WAIT_DIV;
                            end
                        endcase
                    end
                end

                WAIT_MULT: begin
                    start_mult <= 0; // Oprim impulsul
                    if (done_mult) begin
                        result <= mult_out;
                        state <= DONE_STATE;
                    end
                end

                WAIT_DIV: begin
                    start_div <= 0; // Oprim impulsul
                    if (done_div) begin
                        //Impachetam catul si restul intr-un cuvant de 16 biti (Rest = High, Cat = Low)
                        result <= {remainder_out, quotient_out};
                        state <= DONE_STATE;
                    end
                end

                DONE_STATE: begin
                    done_all <= 1;
                    if (!start) begin 
                        // inainte sa ne intoarcem in IDLE (Handshake)
                        done_all <= 0;
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule




module alu_control_unit_tb();

    reg clk;
    reg reset;
    reg start;
    reg [1:0] opcode;
    reg [15:0] op1;
    reg [7:0] op2;
    
    wire [15:0] result;
    wire done_all;

    // Instantierea ALU-ului tau
    alu_control_unit dut (
        .clk(clk), .reset(reset), .start(start), .opcode(opcode),
        .op1(op1), .op2(op2), .result(result), .done_all(done_all)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        // Initializare
        clk = 0; reset = 1; start = 0; opcode = 0; op1 = 0; op2 = 0;
        #20 reset = 0; #20;

        // --- ADUNARE (opcode 00) ---
        // 103 + 12
        @(posedge clk); opcode = 2'b00; op1 = 103; op2 = 12; start = 1;
        wait(done_all); $display("ADD:  %d + %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;

        // -103 + (-12)
        @(posedge clk); opcode = 2'b00; op1 = -103; op2 = -12; start = 1;
        wait(done_all); $display("ADD: %d + %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;

        // -103 + 12
        @(posedge clk); opcode = 2'b00; op1 = -103; op2 = 12; start = 1;
        wait(done_all); $display("ADD: %d + %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;

        // 103 + (-12)
        @(posedge clk); opcode = 2'b00; op1 = 103; op2 = -12; start = 1;
        wait(done_all); $display("ADD:  %d + %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;


        // --- SCADERE (opcode 01) ---
        // 87 - 24
        @(posedge clk); opcode = 2'b01; op1 = 87; op2 = 24; start = 1;
        wait(done_all); $display("SUB:  %d - %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;

        // -87 - (-24)
        @(posedge clk); opcode = 2'b01; op1 = -87; op2 = -24; start = 1;
        wait(done_all); $display("SUB: %d - (%d) = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;

        // -87 - 24
        @(posedge clk); opcode = 2'b01; op1 = -87; op2 = 24; start = 1;
        wait(done_all); $display("SUB: %d - %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;

        // 87 - (-24)
        @(posedge clk); opcode = 2'b01; op1 = 87; op2 = -24; start = 1;
        wait(done_all); $display("SUB:  %d - (%d) = %d", $signed(op1[7:0]), $signed(op2), $signed(result[7:0]));
        @(posedge clk); start = 0; wait(!done_all); #10;


        // --- INMULTIRE (opcode 10) ---
        // 54 * 36
        @(posedge clk); opcode = 2'b10; op1 = 54; op2 = 36; start = 1;
        wait(done_all); $display("MUL: %d * %d = %d", $signed(op1[7:0]), $signed(op2), $signed(result));
        @(posedge clk); start = 0; wait(!done_all); #10;


        // --- IMPARTIRE (opcode 11) ---
        // 7125 / 72
        @(posedge clk); opcode = 2'b11; op1 = 7125; op2 = 72; start = 1;
        wait(done_all); 
        $display("DIV: %d / %d => Cat: %d, Rest: %d", op1, op2, result[7:0], result[15:8]);
        @(posedge clk); start = 0; wait(!done_all); #10;

 
    end

endmodule