library verilog;
use verilog.vl_types.all;
entity fp_div1_altfp_div_pst_coe is
    port(
        aclr            : in     vl_logic;
        clk_en          : in     vl_logic;
        clock           : in     vl_logic;
        dataa           : in     vl_logic_vector(31 downto 0);
        datab           : in     vl_logic_vector(31 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end fp_div1_altfp_div_pst_coe;
