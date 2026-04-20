library verilog;
use verilog.vl_types.all;
entity booth_encoder is
    port(
        booth_bits      : in     vl_logic_vector(2 downto 0);
        M               : in     vl_logic_vector(8 downto 0);
        add_val         : out    vl_logic_vector(8 downto 0)
    );
end booth_encoder;
