library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is 
end alu_tb;

architecture test of alu_tb
	component alu
	port(
	x, y : in std_logic_vector(31 downto 0);
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
	
	signal 
	
end test;