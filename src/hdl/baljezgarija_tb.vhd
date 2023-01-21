
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library std;
use std.textio.all;

use ieee.math_real.all;

library work;

entity baljezgarija_tb is
end baljezgarija_tb;

architecture Behavior of baljezgarija_tb is
	
	constant iCLK_period : time := 83.333333 ns; -- 12MHz
	
	signal iCLK       : std_logic := '0';
	signal inRST      : std_logic := '0';
	
	signal o_pwm      : std_logic;
	

	signal iBUS_A     : std_logic_vector(7 downto 0) := (others => '0');
	signal oBUS_RD    : std_logic_vector(15 downto 0);
	signal iBUS_WD    : std_logic_vector(15 downto 0) := (others => '0');
	signal iBUS_WE    : std_logic := '0';
	
	
begin


	-- Instantiate the Unit Under Test (UUT)
	uut: entity work.baljezgarija
	generic map(
		CLK_FREQ         => 120000, -- Everything is 100x faster.
		CNT_BITS_COMPENS => -7 -- Less bits to avoid warnings.
	)
	port map(
		iCLK       => iCLK,
		inRST      => inRST,
		
		o_pwm      => o_pwm,
		
		iBUS_A     => iBUS_A,
		oBUS_RD    => oBUS_RD,
		iBUS_WD    => iBUS_WD,
		iBUS_WE    => iBUS_WE
	);

	

	-- Clock process definitions
	iCLK_proc: process
	begin
		iCLK <= '0';
		wait for iCLK_period/2;
		iCLK <= '1';
		wait for iCLK_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
		
		inRST <= '0';
		wait for 2*iCLK_period;
		inRST <= '1';
	
		wait;
	end process;

end architecture;
