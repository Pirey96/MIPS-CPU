library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
port ( a : in std_logic_vector (31 downto 0);
b : in std_logic_vector(31 downto 0);
sel : in  std_logic;
output : out std_logic_vector (31 downto 0)
);
end mux;

architecture mux_arch of mux is
--standard mux
begin
	process (sel)
	begin
		case sel is 
			when '0' => output <= a;       --select 0 = a select 1 b
			when others => output <= b;
			
		end case;
	end process;
end mux_arch;