library verilog;
use verilog.vl_types.all;
entity booth_shifter is
    port(
        A_after         : in     vl_logic_vector(8 downto 0);
        Q_in            : in     vl_logic_vector(7 downto 0);
        new_A           : out    vl_logic_vector(8 downto 0);
        new_Q           : out    vl_logic_vector(7 downto 0);
        new_Q1          : out    vl_logic
    );
end booth_shifter;
