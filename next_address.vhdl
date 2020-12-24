


        pc_sig <=( "000000000000000000000000000"&pc);
        PC_offset <= not(branch_enable) and (sext_branch_adddress) ;
        bra <= std_logic_vector(signed(PC_offset) + signed(pc_sig)+00000000000000000000000000000001);

end process;

process (pc, rt, target_address, bra)
begin
        case pc_sel is
                when "00" => next_pc <= bra;
                when "01" => next_pc <=  "000000"&target_address;
                when "10" => next_pc <= rt;       --for jr
                when others => next_pc <= bra;    --UNUSED
        end case;
end process;
end address_arch;


------------------PROBLEMATIC






