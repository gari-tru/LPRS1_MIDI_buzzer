
-------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012,2020
--
-- Instruction ROM
--
-- author:
-- Ivan Kastelan (ivan.kastelan@rt-rk.com)
-- Milos Subotic (milos.subotic@uns.ac.rs)
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity instr_rom is
	port(
		iA : in  std_logic_vector(15 downto 0);
		oQ : out std_logic_vector(14 downto 0)
	);
end entity instr_rom;

-- ubaciti sadrzaj *.txt datoteke generisane pomocu lprsasm ------
architecture Behavioral of instr_rom is
begin
    oQ <= "100000111000000"  when iA = 0 else
          "000110000000000"  when iA = 1 else
          "100000110000000"  when iA = 2 else
          "000110000000000"  when iA = 3 else
          "100000101000000"  when iA = 4 else
          "000110000000000"  when iA = 5 else
          "100000100000000"  when iA = 6 else
          "010000000000000"  when iA = 7 else
          "000000000000000";
end Behavioral;
------------------------------------------------------------------
