library verilog;
use verilog.vl_types.all;
entity non_restoring_divider is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        dividend        : in     vl_logic_vector(15 downto 0);
        divisor         : in     vl_logic_vector(7 downto 0);
        quotient        : out    vl_logic_vector(7 downto 0);
        remainder       : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
end non_restoring_divider;
