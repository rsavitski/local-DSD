library verilog;
use verilog.vl_types.all;
entity fp_sub1_altpriority_encoder_f48 is
    port(
        data            : in     vl_logic_vector(15 downto 0);
        q               : out    vl_logic_vector(3 downto 0)
    );
end fp_sub1_altpriority_encoder_f48;
