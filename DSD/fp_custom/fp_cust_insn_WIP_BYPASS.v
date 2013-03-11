`timescale 1 ps / 1 ps
module fp_cust_insn (
		input  wire [31:0] dataa,  // nios_custom_instruction_slave.dataa
		input  wire [31:0] datab,  //                              .datab
		output wire [31:0] result, //                              .result
		input  wire [1:0]  n,
		input  wire        reset,  //                              .reset
		input  wire        clk,    //                              .clk
		input  wire        clk_en, //                              .clk_en
		input  wire        start,  //                              .start
		output wire        done    //                              .done
	);

	
	// default duration config
	parameter fp_add_latency = 7;
	parameter fp_sub_latency = 7;
	parameter fp_mul_latency = 5;
	
	// n = opcode
	parameter add_opcode = 0;
	parameter sub_opcode = 1;
	parameter mul_opcode = 2;
	

	localparam ieee754_nan = 32'h7fffffff;
	localparam ieee754_signless_infinity = 31'h7f800000;
	localparam ieee754_pos_zero = 32'h00000000;
	localparam ieee754_signless_one = 31'h3f800000;

	//////////////////////////////////////////////////////////////////////////////
	
	wire add_sub_select;
	wire [31:0] result_bus [3:0];

	reg special_symbol_override;
	reg [31:0] special_result;
	
	reg [3:0] delay_cnt;

	//////////////////////////////////////////////////////////////////////////////

	function is_float_inf;
		input [31:0] float_arg;
	begin
		if (float_arg[30:0] == ieee754_signless_infinity)
			is_float_inf = 1'b1;
		else
			is_float_inf = 1'b0;
	end
	endfunction

	//////////////////////////////////////////////////////////////////////////////
	
	// note: reset ignored, only state kept is in a counter and that is properly reset with start signal

	// derive add/sub control signal for the addsub block"
	// add_sub high -> addition; low -> substraction
	assign add_sub_select = (n == add_opcode) ? 1'b1 : 1'b0;
	
	// add and sub results duplicated on both wires
	assign result_bus[sub_opcode] = result_bus[add_opcode];
	
	// multiplex correct result by operation select
	assign result = (special_symbol_override == 0) ? result_bus[n] : special_result;

	// done signal
	assign done = (delay_cnt == 0 || special_symbol_override == 1'b1) ? 1'b1 : 1'b0;
		
	//////////////////////////////////////////////////////////////////////////////

	always @ (start)
	begin
		special_symbol_override <= 1'b0;
		special_result <= 32'b0;

		// override with NaN if either operand is NaN
		if ((dataa[30:23] == 8'hFF && dataa[22:0] != 0) || (datab[30:23] == 8'hFF && datab[22:0] != 0))
		begin
			special_symbol_override <= 1'b1;
			special_result <= ieee754_nan;
		end

		// if not above, check if +-infinity
		else if (is_float_inf(dataa) || is_float_inf(datab))
		begin
			special_symbol_override <= 1'b1;
			case (n) // case on opcode
				add_opcode:
				begin
					// if +inf + -inf -> nan
					if (is_float_inf(dataa) && is_float_inf(datab) && dataa[31] == ~datab[31]) 
					begin
						special_result <= ieee754_nan;							
					end
					else // otherwise infinity always dominates over the remainder of cases
					begin
						special_result <= (is_float_inf(dataa)) ? dataa : datab;
					end
				end
				sub_opcode:
				begin
					// if substracting two infs
					if (is_float_inf(dataa) && is_float_inf(datab)) 
					begin
						// if the same sign for both infs -> nan
						if (dataa[31] == datab[31])
							special_result <= ieee754_nan;
						else // opposite sign infs -> inf of first operand's sign, same as dataa
							special_result <= dataa;
					end
					
					// if one inf value, output infinity with sign depending on which operand is inf
					else 
					begin
						special_result <= (is_float_inf(dataa)) ? dataa : {~datab[31], datab[30:0]};
					end
				end
				mul_opcode: 
				begin
					// if both infs, xor sign and return inf
					if (is_float_inf(dataa) && is_float_inf(datab)) 
					begin
						special_result <= {dataa[31] ^ datab[31], ieee754_signless_infinity};
					end

					// inf * 0 -> nan
					else if ((is_float_inf(dataa) && datab == 0) || (is_float_inf(datab) && dataa == 0)) 
					begin
						special_result <= ieee754_nan;						
					end

					// inf * rest -> inf with appropriate sign
					else 
					begin
						special_result <= {dataa[31] ^ datab[31], ieee754_signless_infinity};				
					end
				end
			endcase
		end // special inf case

		// if not above, check for zero
		else if (dataa[30:0] == 0 || datab[30:0] == 0)
		begin
			special_symbol_override <= 1'b1;
			case (n) // case on opcode
			add_opcode: 
			begin
				// one value in sum zero -> return the other value
				special_result <= (dataa[30:0] == 0) ? datab : dataa;
			end
			sub_opcode:
			begin
				// if first value zero, return negated second operand. Otherwise first value is returned
				special_result <= (dataa[30:0] == 0) ? {~datab[31], datab[30:0]} : dataa;
			end
			mul_opcode:
			begin
				// mul with zero (after covering the above exceptions) is always zero, no zero sign is preserved by this block 
				special_result <= ieee754_pos_zero;
			end
			endcase
		end

		// if not above, check for multiplication by one
		else if (n == mul_opcode && (dataa[30:0] == ieee754_signless_one || datab[30:0] == ieee754_signless_one))
		begin
			special_symbol_override <= 1'b1;
			// return the non-one value with signs xor'd
			special_result <= (dataa[30:0] == ieee754_signless_one) ? {dataa[31] ^ datab[31], datab[30:0]} : {dataa[31] ^ datab[31], dataa[30:0]};	
		end
	end


	// downcounter for asserting done when data is valid
	always @ (posedge clk)
	begin
		if (clk_en)
		begin
			if (start)
			begin
				case(n)
				add_opcode: delay_cnt <= fp_add_latency - 1;
				sub_opcode: delay_cnt <= fp_sub_latency - 1;
				mul_opcode: delay_cnt <= fp_mul_latency - 1;
				default: delay_cnt <= 0;
				endcase
			end
			else
				delay_cnt <= delay_cnt - 1; 
		end
	end

	//////////////////////////////////////////////////////////////////////////////

	// addition and substraction block
	altfp_addsub altfp_addsub_inst (.clock ( clk ),
									.add_sub ( add_sub_select ),
									.clk_en ( clk_en ),
									.dataa ( dataa ),
									.datab ( datab ),
									.result ( result_bus[add_opcode] ));

	// multiplication block
	altfp_mul altfp_mul_inst (.clock ( clk ),
							  .clk_en( clk_en ),
							  .dataa ( dataa ),
							  .datab ( datab ),
							  .result ( result_bus[mul_opcode] ));

endmodule