library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity data_cache is
port (
	address_in : in std_logic_vector(4 downto 0);
	reset : in std_logic;
	clk : in std_logic;
	data_write : in std_logic;
	din : in std_logic_vector(31 downto 0);
	data_out : out std_logic_vector (31 downto 0)
	);
end data_cache;

architecture data_cache_arch of data_cache is
type memory_cells is array  (0 to 31) of std_logic_vector (31 downto 0);
signal cache : memory_cells;
--signal cache_out : std_logic_vector (31 downto 0);
--very similar to register file except it has only one output and one input
begin
process (reset, data_write, address_in)
begin
	if (reset = '1') then                                     --reset sets every register in the cache to 0
		for i in 0 to 31 loop
			cache(i) <= "00000000000000000000000000000000";
		end loop;
	end if;
	
	if (clk'event and clk ='1') then                    --write into cacge
		if data_write = '1' then 
			cache(to_integer(unsigned (address_in))) <= din; 
		end if;
	end if;
	
end process;
 process (address_in, cache)
 begin
	
		data_out <= cache(to_integer(unsigned (address_in)));             --access cache data

end process;
end data_cache_arch;