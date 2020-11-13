library IEEE;
use IEEE.std_logic_1164.all;


-- 32 x 32 register file
-- two read ports, one write port with write enable
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity regfile is
port( din : in std_logic_vector(31 downto 0);
 reset : in std_logic;
 clk : in std_logic;
 write : in std_logic;
 read_a : in std_logic_vector(4 downto 0);
 read_b : in std_logic_vector(4 downto 0);
 write_address : in std_logic_vector(4 downto 0);
 out_a : out std_logic_vector(31 downto 0);
 out_b : out std_logic_vector(31 downto 0));
end regfile ;

architecture registers of regfile is
type registers is array (0 to 31) of std_logic_vector (31 downto 0)                 --array of 32 bit registers
signal reg : registers;

process (reset, clk, write, write_address)
begin 
	if (reset = '1') then 
		for i in 0 to 31 loop
			reg(i) <= "00000000000000000000000000000000"
		end loop;
	end if;
	if clk'event and clk ='1' then
		if write = '1' then 
			reg(conv_integer(write_address)) <= din ;
		end if;
	end if;
end process;
	
process (read_a, read_b)
begin
out_a = reg(conv_integer (read_a);
out_b = reg (conv_integer(read_b);
end process;

end registers;















