library verilog;
use verilog.vl_types.all;
entity alu_cska_8bit is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        cin             : in     vl_logic;
        S               : out    vl_logic_vector(7 downto 0);
        cout            : out    vl_logic
    );
end alu_cska_8bit;
