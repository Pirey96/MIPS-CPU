library IEEE;
use IEEE.std_logic_1164.all;

entity pc is 
port (input : in std_logic_vector (4 downto 0);  --needs to be 31 downto 0 but for simplicty 4 downto 0 shall be used
output : out std_logic_vector (4 downto 0);       --needs to be 31 downto 0 but for simplicty 4 downto 0 shall be used`
reset : in std_logic;
clk : in std_logic
);
end pc;
architecture pc_arch of pc is 
begin
process (clk,reset,input)
begin
if clk'event and clk = '1' then
	output <= input;
end if;
if reset = '1' then
	output <= (others=>'0');
end if;
end process;
end pc_arch;