
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012,2021
--
-- Computer system top level
--
-- authors:
-- Ivan Kastelan (ivan.kastelan@rt-rk.com)
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;

entity top is
	generic(
		-- Default frequency used in synthesis.
		constant CLK_FREQ         : positive := 12000000;
		constant CNT_BITS_COMPENS : integer  := 0
	);
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		oLED       : out std_logic_vector(15 downto 0);
		
		o_pwm : out std_logic
	);
end entity top;


architecture arch of top is

	signal sINSTR : std_logic_vector(14 downto 0);
	signal sPC     : std_logic_vector(15 downto 0);
	signal sBUS_A  : std_logic_vector(15 downto 0);
	signal sBUS_RD : std_logic_vector(15 downto 0);
	signal sMEM_RD : std_logic_vector(15 downto 0);
	signal sBUS_WD : std_logic_vector(15 downto 0);
	signal sBUS_WE : std_logic;
	signal sMEM_WE : std_logic;
	
	signal sPWM_RD : std_logic_vector (15 downto 0);
	signal sPWM_WE : std_logic;

begin

	cpu_top_i: entity work.cpu_top
	port map(
		iCLK    => iCLK,
		inRST   => inRST,
		oPC     => sPC,
		iINSTR  => sINSTR,
		oADDR   => sBUS_A,
		oDATA   => sBUS_WD,
		oMEM_WE => sBUS_WE,
		iDATA   => sBUS_RD,
		oLED    => oLED
	);

	i_instr_rom: entity work.instr_rom
	port map(
		iA => sPC,
		oQ => sINSTR
	);

	i_data_ram: entity work.data_ram
	port map(
		iCLK  => iCLK,
		inRST => inRST,
		iA    => sBUS_A(7 downto 0),
		iD    => sBUS_WD,
		iWE   => sMEM_WE,
		oQ    => sMEM_RD
	);
	
	i_bzz: entity work.baljezgarija
	generic map(
		CLK_FREQ         => CLK_FREQ,
		CNT_BITS_COMPENS => CNT_BITS_COMPENS
	)
	port map(
		iCLK => iCLK,
		inRST => inRST,
		o_pwm => o_pwm,
		iBUS_A     => sBUS_A(7 downto 0),
		oBUS_RD    => sPWM_RD,
		iBUS_WE    => sPWM_WE,
		iBUS_WD    => sBUS_WD
	);
	
	-- Data Write Enable demux.
	process(sBUS_A, sBUS_WE)
	begin
		sMEM_WE <= '0';
		sPWM_WE <= '0';
		case sBUS_A(9 downto 8) is
			when "00" =>
				sMEM_WE <= sBUS_WE;
			when "01" =>
				sPWM_WE <= sBUS_WE;
			when others =>
				
		end case;
	end process;
	-- Data Read mux.
	process(sBUS_A, sMEM_RD, sPWM_RD)
	begin
		case sBUS_A(9 downto 8) is
			when "00" =>
				sBUS_RD <= sMEM_RD;
			when "01" =>
				sBUS_RD <= sPWM_RD;
			when others =>
				sBUS_RD <= (others => '0');
		end case;
	end process;

end architecture;
