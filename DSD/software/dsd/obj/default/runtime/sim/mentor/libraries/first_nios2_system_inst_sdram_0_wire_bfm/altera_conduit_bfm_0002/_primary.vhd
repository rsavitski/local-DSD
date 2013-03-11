library verilog;
use verilog.vl_types.all;
entity altera_conduit_bfm_0002 is
    port(
        sig_addr        : in     vl_logic_vector(11 downto 0);
        sig_ba          : in     vl_logic_vector(1 downto 0);
        sig_cas_n       : in     vl_logic;
        sig_cke         : in     vl_logic;
        sig_cs_n        : in     vl_logic;
        sig_dq          : inout  vl_logic_vector(15 downto 0);
        sig_dqm         : in     vl_logic_vector(1 downto 0);
        sig_ras_n       : in     vl_logic;
        sig_we_n        : in     vl_logic
    );
end altera_conduit_bfm_0002;
