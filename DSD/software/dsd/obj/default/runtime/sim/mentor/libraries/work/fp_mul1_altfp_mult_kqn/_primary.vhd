library verilog;
use verilog.vl_types.all;
entity fp_mul1_altfp_mult_kqn is
    port(
        clock           : in     vl_logic;
        dataa           : in     vl_logic_vector(31 downto 0);
        datab           : in     vl_logic_vector(31 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end fp_mul1_altfp_mult_kqn;