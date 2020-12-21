library IEEE;
use IEEE.std_logic_1164.all;



entity sign_extention is
port( --3 i/o
	input : in std_logic_vector (15 downto 0);
	func :  in std_logic_vector (1 downto 0);
	output : out std_logic_vector (31 downto 0)
);
end sign_extention;

architecture sign_extention_arch of sign_extention is
--signal temp : std_logic_vector (31 downto 0);
begin
process (input,func)
begin
	if (func = "00") then
		output(31 downto 16) <= input(15 downto 0);
		output(15 downto 0) <= "0000000000000000";
	elsif (func = "01") then
		output(15 downto 0) <= input(15 downto 0);
		output(31 downto 16) <= (others => input(15));
	elsif func = "10" then
		output(15 downto 0) <= input(15 downto 0);
		output(31 downto 16) <= (others => input(15));
	else
		output (15 downto 0) <= input (15 downto 0);
		output (31 downto 16) <= "0000000000000000";
	end if;
	
end process;
end sign_extention_arch;