library verilog;
use verilog.vl_types.all;
entity alu_control_unit is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        opcode          : in     vl_logic_vector(1 downto 0);
        op1             : in     vl_logic_vector(15 downto 0);
        op2             : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(15 downto 0);
        done_all        : out    vl_logic
    );
end alu_control_unit;
