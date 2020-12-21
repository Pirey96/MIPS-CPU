library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
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
end control_unit;

architecture control_unit_arch of control_unit is

begin

process(op, fnctn)
begin
-- case statement to implement each of the 20 possible instructions
-- op 000000 is shared by numerous instructions (mainnly involving the alu)
case op is 
	when "001111" => reg_write  <= '1';                             --laod upper immediate
					 reg_dst    <= '0'; 
					 reg_in_src <= '1';
					 alu_src    <= '1';
					 add_sub    <= '0';
					 data_write <= '0';
					 logic_func <= "00";
					 func       <= "00";
					 branch_type<= "00";
					 pc_sel     <= "00";
					 
	when "000000" => case fnctn is                                   --these insturctions have shared op 100010
							when "100000" =>reg_write  <= '1';            --differentiate these instruction, the function field (fnct) is used
											reg_dst    <= '1';			--intruction add
											reg_in_src <= '1';
											alu_src    <= '0';
											add_sub    <= '0';
											data_write <= '0';
											logic_func <= "00";
											func       <= "10";
											branch_type<= "00";
											pc_sel     <= "00";
											
							when "100010" => reg_write  <= '1';           --instruction sub
											reg_dst    <= '1';           --only the add_sub is changed as its identical to the instruction add
											reg_in_src <= '1'; 
											alu_src    <= '0';
											add_sub    <= '1';
											data_write <= '0';
											logic_func <= "00";
											func       <= "10";
											branch_type<= "00";
											pc_sel     <= "00";
											
							when "101010" => reg_write  <= '1';            --instruction slt
											reg_dst    <= '1';
											reg_in_src <= '1';
											alu_src    <= '0';
											add_sub    <= '1';
											data_write <= '0';
											logic_func <= "00";
											func       <= "01";
											branch_type<= "00";
											pc_sel     <= "00";
											
							when "100100" => reg_write  <=  '1';            --logic and
											reg_dst    <= '1';			--the next 4 instructions are very similar (only the logic_func
											reg_in_src <= '1';			--control signals will be different for each logic 
											alu_src    <= '0';
											add_sub    <= '1';
											data_write <= '0';
											logic_func <= "00";
											func       <= "11";
											branch_type<= "00";
											pc_sel     <= "00";
											
							when "100101" => reg_write  <=  '1';          --logic or 
											reg_dst    <= '1';
											reg_in_src <= '1';
											alu_src    <= '0';
											add_sub    <= '1';
											data_write <= '0';
											logic_func <= "01";
											func       <= "11";
											branch_type<= "00";
											pc_sel     <= "00";
											
							when "100110" => reg_write  <= '1';         --logic xor
											reg_dst    <= '1';
											reg_in_src <= '1';
											alu_src    <= '0';
											add_sub    <= '1';
											data_write <= '0';
											logic_func <= "10";
											func       <= "11";
											branch_type<= "00";
											pc_sel     <= "00";
											
							when "100111" => reg_write  <=  '1';         --logic nor
											reg_dst    <= '1';
											reg_in_src <= '1';
											alu_src    <= '0';
											add_sub    <= '1';
											data_write <= '0';
											logic_func <= "11";
											func       <= "11";
											branch_type<= "00";
											pc_sel     <= "00";
							
							when "001000" => reg_write  <=  '0';         --jr instructions that also has op 0000000
											reg_dst    <= '0';
											reg_in_src <= '0';
											alu_src    <= '0';
											add_sub    <= '0';
											data_write <= '0';
											logic_func <= "00";
											func       <= "00";
											branch_type<= "00";
											pc_sel     <= "10";
											
							when others =>  reg_write  <= '0';         --case statement must have all possibilies
											reg_dst    <= '0';		--must be listed this is just filler
											reg_in_src <= '0';
											alu_src    <= '0';
											add_sub    <= '0';
											data_write <= '0';
											logic_func <= "00";
											func       <= "00";
											branch_type<= "00";
											pc_sel     <= "00";
							
					end case;

	when "001000" =>reg_write  <= '1';               --instuction addi 
				    reg_dst    <= '0';
					reg_in_src <= '1';
					alu_src    <= '1';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "10";
					branch_type<= "00";
					pc_sel     <= "00";
								
	when "001010" =>reg_write  <= '1';               --instruction slti
				    reg_dst    <= '0';
					reg_in_src <= '1';
					alu_src    <= '1';
					add_sub    <= '1';
					data_write <= '0';
					logic_func <= "00";
					func       <= "01";
					branch_type<= "00";
					pc_sel     <= "00";

	when "001100" =>reg_write  <= '1';           --instruciont andi
					reg_dst    <= '0';		   --the next few instructions are also identical 
					reg_in_src <= '1';		   --except for logic_func/op
					alu_src    <= '1';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "11";
					branch_type<= "00";
					pc_sel     <= "00";
								  
	when "001101" =>reg_write  <= '1';           --instruciont ori
					reg_dst    <= '0';
					reg_in_src <= '1';
					alu_src    <= '1';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "01";
					func       <= "11";
					branch_type<= "00";
					pc_sel     <= "00";
								  
	when "001110" =>reg_write  <= '1';           --instruciont xori
					reg_dst    <= '0';
					reg_in_src <= '1';
					alu_src    <= '1';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "10";
					func       <= "11";
					branch_type<= "00";
					pc_sel     <= "00";
								  
	when "100011" =>reg_write  <= '1';           --instruciont lw
					reg_dst    <= '0';
					reg_in_src <= '0';
					alu_src    <= '1';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "10";
					func       <= "10";
					branch_type<= "00";
					pc_sel     <= "00";

	when "101011" =>reg_write  <= '0';           --instruciont sw
					reg_dst    <= '0';
					reg_in_src <= '0';
					alu_src    <= '1';
					add_sub    <= '0';
					data_write <= '1';
					logic_func <= "10";
					func       <= "10";
					branch_type<= "00";
					pc_sel     <= "00";
					
	when "000010" =>reg_write  <= '0';           --instruciont j
					reg_dst    <= '0';
					reg_in_src <= '0';
					alu_src    <= '0';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "00";
					branch_type<= "00";
					pc_sel     <= "10";

	when "000001" =>reg_write  <= '0';           --instruciont bltz
					reg_dst    <= '0';
					reg_in_src <= '0';
					alu_src    <= '0';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "00";
					branch_type<= "11";
					pc_sel     <= "00";
	
	when "000100" =>reg_write  <= '0';           --instruciont beq
					reg_dst    <= '0';
					reg_in_src <= '0';
					alu_src    <= '0';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "00";
					branch_type<= "01";
					pc_sel     <= "00";

	when "000101" =>reg_write  <= '0';           --instruciont bne
					reg_dst    <= '0';
					reg_in_src <= '0';
					alu_src    <= '0';
					add_sub    <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "00";
					branch_type<= "10";
					pc_sel     <= "00";
					
	when others =>  reg_write  <= '0';         --case statement must have all possibilies
					reg_dst    <= '0';		--must be listed this is just filler
					reg_in_src <= '0';
					alu_src    <= '0';
					  add_sub  <= '0';
					data_write <= '0';
					logic_func <= "00";
					func       <= "00";
					branch_type<= "00";
					pc_sel     <= "00";
end case;
end process;
end control_unit_arch;










					 