
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2020
--
-- Input/Output controler for RGB matrix
--
-- authors:
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity rgb_matrix_io_ctrl is
	generic(
		constant CLK_FREQ         : positive;
		constant CNT_BITS_COMPENS : integer
	);
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		onCOL      : out std_logic_vector(7 downto 0);
		oMUX_ROW   : out std_logic_vector(2 downto 0);
		oMUX_COLOR : out std_logic_vector(1 downto 0);
		iBUS_A     : in  std_logic_vector(7 downto 0);
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WD    : in  std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic
	);
end entity rgb_matrix_io_ctrl;

architecture Behavioral of rgb_matrix_io_ctrl is

	subtype tRGB is std_logic_vector(2 downto 0);
	type tRGB_MATRIX is array (0 to 7, 0 to 7) of tRGB;
	-- Indexing goes like: sBUS_MATRIX(y, x)
	signal sBUS_MATRIX : tRGB_MATRIX;
	signal sOUT_MATRIX : tRGB_MATRIX;
	
	
	signal sSYNC_MATRIX : std_logic;
	signal sFRAME_SYNC  : std_logic;
	
	-- TODO Refactor
	signal en_row                 : std_logic;
	
	signal mux_row       : std_logic_vector(2 downto 0);
	signal rows_done              : std_logic;
	
	signal mux_color : std_logic_vector(1 downto 0);
	signal round_done             : std_logic;

begin
	
	process(iCLK, inRST)
	begin
		if inRST = '0' then
			sBUS_MATRIX <= (others => (others => "000"));
			sOUT_MATRIX <= (others => (others => "000"));
		elsif rising_edge(iCLK) then
			if sSYNC_MATRIX = '1' then
				sOUT_MATRIX <= sBUS_MATRIX;
				sBUS_MATRIX <= (others => (others => "000"));
			else
				if iBUS_WE = '1' then
					if iBUS_A(7 downto 6) = "00" then
						sBUS_MATRIX(
							conv_integer(iBUS_A(5 downto 3)),
							conv_integer(iBUS_A(2 downto 0))
						) <= iBUS_WD(2 downto 0);
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process(iBUS_A, sBUS_MATRIX, sFRAME_SYNC)
	begin
		if iBUS_A(7 downto 6) = "00" then
			oBUS_RD <= "0000000000000" & sBUS_MATRIX(
				conv_integer(iBUS_A(5 downto 3)),
				conv_integer(iBUS_A(2 downto 0))
			);
		elsif iBUS_A = "01000000" then
			oBUS_RD <= "000000000000000" & sFRAME_SYNC;
		else
			oBUS_RD <= x"deda";
		end if;
	end process;
	
	sSYNC_MATRIX <= '1' when mux_color = "10" and rows_done = '1' else '0';
	sFRAME_SYNC <= '1' when mux_color = "11" else '0';
	
	--TODO Refactor
	-- 12000000Hz/5000/8/4/75 = 1Hz
	-- 12000000Hz/(12000000Hz/2400Hz)/8/4/75 = 1Hz
	
	en_row_cnt_inst: entity work.counter
	generic map(
		CNT_MOD  => CLK_FREQ/2400,
		CNT_BITS => 13+CNT_BITS_COMPENS
	)
	port map(
		i_clk  => iCLK,
		in_rst => inRST,
		
		i_rst  => '0',
		i_en   => '1',
		o_cnt  => open,
		o_tc   => en_row
	);
	
	-- Time-multiplexing.
	mux_row_cnt_inst: entity work.counter
	generic map(
		CNT_MOD  => 8,
		CNT_BITS => 3
	)
	port map(
		i_clk  => iCLK,
		in_rst => inRST,
		
		i_rst  => '0',
		i_en   => en_row,
		o_cnt  => mux_row,
		o_tc   => rows_done
	);

	mux_color_cnt_inst: entity work.counter
	generic map(
		CNT_MOD  => 4,
		CNT_BITS => 2
	)
	port map(
		i_clk  => iCLK,
		in_rst => inRST,
		
		i_rst  => '0',
		i_en   => rows_done,
		o_cnt  => mux_color,
		o_tc   => round_done
	);
	
	process(iCLK, inRST)
	begin
		if inRST = '0' then
			onCOL <= (others => '1');
			oMUX_ROW <= (others => '0');
			oMUX_COLOR <= (others => '0');
		elsif rising_edge(iCLK) then
			
			for col in 0 to 7 loop
				case mux_color is
					when "00" => -- Red
						onCOL(col) <= not
							sOUT_MATRIX(conv_integer(mux_row), col)(0);
					when "01" => -- Green
						onCOL(col) <= not
							sOUT_MATRIX(conv_integer(mux_row), col)(1);
					when "10" => -- Blue
						onCOL(col) <= not
							sOUT_MATRIX(conv_integer(mux_row), col)(2);
					when others =>
				end case;
			end loop;
			
			oMUX_ROW <= mux_row;
			oMUX_COLOR <= mux_color;
		end if;
	end process;
	
end architecture;
