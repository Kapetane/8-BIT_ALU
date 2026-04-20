library verilog;
use verilog.vl_types.all;
entity booth_datapath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        load            : in     vl_logic;
        shift_en        : in     vl_logic;
        M_in            : in     vl_logic_vector(7 downto 0);
        Q_in            : in     vl_logic_vector(7 downto 0);
        P               : out    vl_logic_vector(15 downto 0);
        count_out       : out    vl_logic_vector(2 downto 0)
    );
end booth_datapath;
