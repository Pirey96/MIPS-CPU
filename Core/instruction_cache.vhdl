library IEEE;
use IEEE.std_logic_1164.all;


entity instruction_cache is
port ( 
	pc_val : in std_logic_vector (4 downto 0);     --5 bits long but can be up to 31 bits long
	current_instruction : out std_logic_vector (31 downto 0));
end instruction_cache;


architecture instruction_cache_arch of instruction_cache is 
	--type istruction_memory_cells is array (0 to 31) of std_logic_vector (31 downto 0);
	--signal mem_cells : istruction_memory_cells;
	
	signal output : std_logic_vector (31 downto 0);
begin
process (pc_val)
begin
	--harcode: 
	case pc_val is
		when "00000" => output <="00100000000000110000000000000000";
		when "00001" => output <="00100000000000010000000000000000";
		when "00010" => output <="00100000000000100000000000000101";
		when "00011" => output <="00000000001000100000100000100000";
		when "00100" => output <="00100000010000101111111111111111";
		when "00101" => output <="00010000010000110000000000000001";
		when "00110" => output <="00001000000000000000000000000011";
		when "00111" => output <="10101100000000010000000000000000";
		when "01000" => output <="10001100000001000000000000000000";
		when "01001" => output <="00110000100001000000000000001010";
	    when "01010" => output <="00110100100001000000000000000001";
		when "01011" => output <="00111000100001000000000000001011";
		when "01100" => output <="00111000100001000000000000000000";
		when  others => output <="00000000000000000000000000000000";
	end case;
	current_instruction <= output;
end process;
end instruction_cache_arch;