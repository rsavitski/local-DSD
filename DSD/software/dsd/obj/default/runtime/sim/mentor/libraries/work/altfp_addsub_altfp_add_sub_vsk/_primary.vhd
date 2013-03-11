library verilog;
use verilog.vl_types.all;
entity altfp_addsub_altfp_add_sub_vsk is
    port(
        add_sub         : in     vl_logic;
        clk_en          : in     vl_logic;
        clock           : in     vl_logic;
        dataa           : in     vl_logic_vector(31 downto 0);
        datab           : in     vl_logic_vector(31 downto 0);
        result          : out    vl_logic_vector(31 downto 0)
    );
end altfp_addsub_altfp_add_sub_vsk;
