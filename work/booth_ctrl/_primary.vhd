library verilog;
use verilog.vl_types.all;
entity booth_ctrl is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        count_out       : in     vl_logic_vector(2 downto 0);
        load            : out    vl_logic;
        shift_en        : out    vl_logic;
        done            : out    vl_logic;
        busy            : out    vl_logic
    );
end booth_ctrl;
