library verilog;
use verilog.vl_types.all;
entity fp_cust_insn is
    generic(
        fp_add_latency  : integer := 7;
        fp_sub_latency  : integer := 7;
        fp_mul_latency  : integer := 5;
        add_opcode      : integer := 0;
        sub_opcode      : integer := 1;
        mul_opcode      : integer := 2
    );
    port(
        dataa           : in     vl_logic_vector(31 downto 0);
        datab           : in     vl_logic_vector(31 downto 0);
        result          : out    vl_logic_vector(31 downto 0);
        n               : in     vl_logic_vector(1 downto 0);
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        clk_en          : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of fp_add_latency : constant is 1;
    attribute mti_svvh_generic_type of fp_sub_latency : constant is 1;
    attribute mti_svvh_generic_type of fp_mul_latency : constant is 1;
    attribute mti_svvh_generic_type of add_opcode : constant is 1;
    attribute mti_svvh_generic_type of sub_opcode : constant is 1;
    attribute mti_svvh_generic_type of mul_opcode : constant is 1;
end fp_cust_insn;
