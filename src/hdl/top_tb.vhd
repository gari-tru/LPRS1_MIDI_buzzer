
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012,2020
-- Lab 6
--
-- Computer system top level testbench
--
-- authors:
-- Ivan Kastelan (ivan.kastelan@rt-rk.com)
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity top_tb is
end top_tb;

architecture Behavior of top_tb is

	component top is
		generic(
			-- Default frequency used in synthesis.
			constant CLK_FREQ         : positive := 12000000;
			constant CNT_BITS_COMPENS : integer  := 0
		);
		port(
			iCLK       : in  std_logic;
			inRST      : in  std_logic;
			oLED       : out std_logic_vector(15 downto 0);
			
			o_pwm	: out std_logic
		);
	end component top;
	
	
	--Inputs
	signal iCLK       : std_logic := '0';
	signal inRST      : std_logic := '0';
	signal oLED       : std_logic_vector (15 downto 0);
						
	signal o_pwm : std_logic := '0';

	constant iCLK_period : time := 83.333333 ns; -- 12MHz
	constant FRAME_LEN : natural := 1600;
	
	file fo : text open WRITE_MODE is "STD_OUTPUT";

begin


	-- Instantiate the Unit Under Test (UUT)
	uut: top
	generic map(
		--TODO Make it round. To have change on every 1 us.
		CLK_FREQ         => 120000, -- Everything is 100x faster.
		CNT_BITS_COMPENS => -7 -- Less bits to avoid warnings.
	)
	port map(
		iCLK       => iCLK,
		inRST      => inRST,
		oLED       => oLED,
		o_pwm => o_pwm
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
