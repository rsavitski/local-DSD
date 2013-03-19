library verilog;
use verilog.vl_types.all;
entity fp_sub1_altbarrel_shift_fkb is
    port(
        data            : in     vl_logic_vector(25 downto 0);
        distance        : in     vl_logic_vector(4 downto 0);
        result          : out    vl_logic_vector(25 downto 0)
    );
end fp_sub1_altbarrel_shift_fkb;
