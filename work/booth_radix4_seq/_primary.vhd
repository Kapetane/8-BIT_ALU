library verilog;
use verilog.vl_types.all;
entity booth_radix4_seq is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        M_in            : in     vl_logic_vector(7 downto 0);
        Q_in            : in     vl_logic_vector(7 downto 0);
        P               : out    vl_logic_vector(15 downto 0);
        done            : out    vl_logic;
        busy            : out    vl_logic
    );
end booth_radix4_seq;
