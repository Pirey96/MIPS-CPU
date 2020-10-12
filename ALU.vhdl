library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
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
end alu ;


architecture behavioural of alu is
signal sum_dif : std_logic_vector(31 downto 0);
signal logic_gate_output : std_logic_vector(31 downto 0);
begin
	process (x, y, add_sub)               --32 bit Adder
		begin
			case add_sub is
			when '0' => sum_dif <= signed(x) + signed(y);
			when others => sum_dif <= signed(x) - signed(y);
			end case;
	end process;

process (x , y, logic_func)
	begin                                        --32 bit logic
		case logic_func is 
			when "00" => logic_gate_output <= x and y;
			when "01" => logic_gate_output <= x or y;
			when "10" => logic_gate_output <= x xor y;
			when others => logic_gate_output <= x nor y;
		end case;
end process;

process (sum_dif)                 --Zero check
	begin
		if sum_dif = x"00" then
			z <= '1';
		else
			z <= '0';
		end if;
end process;
	
process (x, y, sum_dif, add_sub)	--overflow check
	begin
		 if (add_sub = '0' and x(31)=y(31) and sum_dif /= x(31) or
		 add_sub = '1' and x(31)/=y(31) and sum_dif /= x(31) then overflow <= '1';
		 else overflow <='0';
		 end if;
end process;

process (y, sum_dif, logic_gate_output   --final multiplexing for output
	begin
		case func is 
			when "00" => output <= y;
			when "01" => output <= not (sum_dif(31) or x"00");
			when "10" => output <= sum_dif;
			when "11" => output<= logic_gate_output;
		end case;
	end process

end behavioural;























