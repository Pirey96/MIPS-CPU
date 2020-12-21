library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std;

entity cpu is
port(reset : in std_logic;
	clk : in std_logic;
	rs_out, rt_out : out std_logic_vector(31 downto 0);
	-- output ports from register file
	pc_out : out std_logic_vector(31 downto 0); -- pc reg
	overflow, zero : out std_logic);
end cpu;

architecture processor of cpu is
--COMPONENTS
--each component of each major block of the CPU (this is a little bit higher than rtl
component alu
port(	x, y : in std_logic_vector(31 downto 0);
 	-- two input operands
 	add_sub : in std_logic ; -- 0 = add , 1 = sub
	logic_func : in std_logic_vector(1 downto 0 ) ;
 	-- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
 	func : in std_logic_vector(1 downto 0 ) ;
 	-- 00 = lui, 01 = setless , 10 = arith , 11 = logic
 	output : out std_logic_vector(31 downto 0) ;
 	overflow : out std_logic ;
 	zero : out std_logic
);
end component;
--component of the regfile previously deigned
--view Register-File.vhdl
component regfile
port( din : in std_logic_vector(31 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	reg_write : in std_logic;
	read_a : in std_logic_vector(4 downto 0);
	read_b : std_logic_vector(4 downto 0);
	write_address : in std_logic_vector(4 downto 0);
	out_a : out std_logic_vector(31 downto 0);
	out_b : out std_logic_vector(31 downto 0));
end component ;
--previously created component to calculate the next address
component next_address
port(rt, rs : in std_logic_vector(31 downto 0);
	-- two register inputs
	pc : in std_logic_vector(4 downto 0);
	target_address : in std_logic_vector(25 downto 0);
	branch_type : in std_logic_vector(1 downto 0);
	pc_sel : in std_logic_vector(1 downto 0);
	next_pc : out std_logic_vector(31 downto 0));
end component;
--previously created compnent for the sign extention for immediate and numeric values from 32 bit
--instrucutions 
component sign_extention 
port( --3 i/o
	input : in std_logic_vector (15 downto 0);
	func :  in std_logic_vector (1 downto 0);
	output : out std_logic_vector (31 downto 0)
);
end component;

--instruction cache (hardcoded)
--will be modified for multiple codes
component instruction_cache
port ( 
	pc_val : in std_logic_vector (4 downto 0);     --5 bits long but can be up to 31 bits long
	current_instruction : out std_logic_vector (31 downto 0));
end component;

--memory for data to be stored
component data_cache
port (
	address_in : in std_logic_vector(4 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	data_write : in std_logic;
	din : in std_logic_vector(31 downto 0);
	data_out : out std_logic_vector (31 downto 0)
	);
end component;
--program counter
component pc 
port (input : in std_logic_vector (4 downto 0);
	output : out std_logic_vector (4 downto 0);
	reset : in std_logic;
	clk : in std_logic
);
end component;

--the skeleton of the cpu controlling all functionality of the instructions
component control_unit 
port ( op : in std_logic_vector(5 downto 0);
	fnctn : in std_logic_vector( 5 downto 0);
	reg_write  : out std_logic;
	reg_dst    : out std_logic;
	reg_in_src : out std_logic;
	alu_src    : out std_logic;
	add_sub    : out std_logic;
	data_write : out std_logic;
	logic_func : out std_logic_vector (1 downto 0);
	func       : out std_logic_vector (1 downto 0);
	branch_type: out std_logic_vector (1 downto 0);
	pc_sel     : out std_logic_vector (1 downto 0)
);
end component;

component two_mux
port ( a : in std_logic_vector (4 downto 0);
b : in std_logic_vector(4 downto 0);
sel : in  std_logic;
output : out std_logic_vector (4 downto 0)
);
end component;

component mux
port ( a : in std_logic_vector (31 downto 0);
b : in std_logic_vector(31 downto 0);
sel : in  std_logic;
output : out std_logic_vector (31 downto 0)
);
end component;
----------------------------signals used for interconnections-------------------------------------------
signal n_a : std_logic_vector (31 downto 0 );  			    --output signal of next address

signal instruction : std_logic_vector (31 downto 0);  		--output signal of instruction cache
signal imux_out :std_logic_vector(4 downto 0);				--output of the I cache mux
signal reg_write_sig  : std_logic;                          --CONTROL SIGNAL OUTPUTS
signal reg_dst_sig    : std_logic;                          --CONTROL SIGNAL OUTPUTS
signal reg_in_src_sig : std_logic;                          --CONTROL SIGNAL OUTPUTS
signal alu_src_sig    : std_logic;                          --CONTROL SIGNAL OUTPUTS
signal add_sub_sig    : std_logic;                          --CONTROL SIGNAL OUTPUTS
signal data_write_sig : std_logic;                          --CONTROL SIGNAL OUTPUTS
signal logic_func_sig : std_logic_vector (1 downto 0);      --CONTROL SIGNAL OUTPUTS
signal func_sig       : std_logic_vector (1 downto 0);       --CONTROL SIGNAL OUTPUTS
signal branch_type_sig: std_logic_vector (1 downto 0);      --CONTROL SIGNAL OUTPUTS
signal pc_sel_sig     : std_logic_vector (1 downto 0);      --CONTROL SIGNAL OUTPUTS
signal write_back     :std_logic_vector (31 downto 0);      --output writeback
signal output_a		  :std_logic_vector (31 downto 0);      --regfile output
signal output_b		  :std_logic_vector (31 downto 0);		--output b regfile
signal sext_out       :std_logic_vector (31 downto 0);		--sign extention output 
signal sext_reg_mux   :std_logic_vector (31 downto 0);	--output of sext/regfile multiplexor
signal alu_out        :std_logic_vector (31 downto 0);    --ALU output 
signal data_output    :std_logic_vector (31 downto 0);    --data cache output
--signal p_counter      :std_logic_vector (31 downto 0);
signal npc            :std_logic_vector (4 downto 0);
signal filler         :std_logic_vector (26 downto 0); --filler bits for 32 bit length variables for which only 5 is needed
---------------------------------------component instantiations------------------------------------------
--!!!!WORK!!!! must be removed this is for xilinx/vivado synthesis and compilation
for NA : next_address  use entity work.next_address(address_arch);  --the next_address component connections
for PROGRAM_COUNTER : pc use entity work.pc(pc_arch);               -- program counter component instantiation
for ARITHMETIC_LOGIC_UNIT : alu use entity work.alu(alu_arch);      --arithmetic logic unit
for REGISTERS : regfile use entity work.regfile(registers_file_arch);	--register component
for ICACHE : instruction_cache use entity work.instruction_cache(instruction_cache_arch);  --cache component
for DCACHE : data_cache use entity work.data_cache (data_cache_arch);		--cache component 
for SIGN_EXT : sign_extention use entity work.sign_extention (sign_extention_arch);   --sign extention
for CONTROL : control_unit use entity work.control_unit (control_unit_arch);  --control 
--multiplexors
for MUX_ICACHE : two_mux use entity work.two_mux(mux_arch);
for MUX_SEXT_RF : mux use entity work.mux (mux_arch);
for MUX_DCACHE : mux use entity work.mux (mux_arch);
---------------------------------------------------------------------------------------------------------------------------
begin
--use compononents and making the last interconnects
	CONTROL : control_unit port map ( op => instruction (31 downto 26), fnctn => instruction(5 downto 0), reg_write =>reg_write_sig, reg_dst =>reg_dst_sig, 
		reg_in_src =>reg_in_src_sig, alu_src =>alu_src_sig, add_sub =>add_sub_sig, data_write => data_write_sig, logic_func =>logic_func_sig, 
				func =>func_sig, branch_type =>branch_type_sig, pc_sel =>pc_sel_sig);
				
	ICACHE : instruction_cache port map ( pc_val => npc, current_instruction => instruction);
	MUX_ICACHE : two_mux port map ( a => instruction (20 downto 16), b => instruction(15 downto 11), sel => reg_dst_sig, output (4 downto 0) => imux_out);
	REGISTERS : regfile port map (read_a => instruction(20 downto 16), read_b=> instruction(15 downto 11), write_address => imux_out, din => write_back,
									reset => reset, clk => clk,reg_write => reg_write_sig, out_a => output_a, out_b => output_b);
	SIGN_EXT : sign_extention port map (input => instruction(15 downto 0), func => func_sig, output => sext_out);
	MUX_SEXT_RF : mux port map (a => output_b, b=> sext_out, sel => alu_src_sig, output => sext_reg_mux);
	ARITHMETIC_LOGIC_UNIT : alu port map ( x => output_a, y => sext_reg_mux, add_sub => add_sub_sig, logic_func => logic_func_sig, func => func_sig, 
												overflow => overflow, zero=>zero,output=>alu_out);
	DCACHE : data_cache port map (address_in => alu_out (4 downto 0), din => output_b, clk => clk, reset=> reset, data_write=> data_write_sig, data_out => data_output);			
	MUX_DCACHE : mux port map (a => data_output, b=> alu_out, sel => reg_in_src_sig, output => write_back);
				
	NA : next_address port map (rt => output_b, rs=>output_a, pc =>npc,target_address=> instruction(25 downto 0),branch_type=>branch_type_sig, pc_sel => pc_sel_sig,next_pc => n_a);
	PROGRAM_COUNTER : pc port map ( input=> n_a(4 downto 0), output => npc, clk=>clk, reset=>reset); 
	
	rs_out <= output_a;
	rt_out <= output_b;
	pc_out <= "000000000000000000000000000"&npc;
	

end processor;
