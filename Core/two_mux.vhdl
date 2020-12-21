library IEEE;
use IEEE.std_logic_1164.all;

entity two_mux is
port ( a : in std_logic_vector (4 downto 0);
b : in std_logic_vector(4 downto 0);
sel : in  std_logic;
output : out std_logic_vector (4 downto 0)
);
end two mux;

architecture mux_arch of two_mux is
begin
	process (a,b,sel)
	begin
		case sel is 
			when '0' => output <= a;
			when others => output <= b;
			
		end case;
	end process;
end mux_arch;