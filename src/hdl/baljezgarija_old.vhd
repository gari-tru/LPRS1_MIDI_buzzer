
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
use ieee.std_logic_arith.all;

library work;

entity baljezgarija is
	generic(
		constant CLK_FREQ         : positive;
		constant CNT_BITS_COMPENS : integer
	);
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		
		o_pwm      : out std_logic;
		
		iBUS_A     : in  std_logic_vector(7 downto 0);
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WD    : in  std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic
	);
end entity baljezgarija;

architecture Behavioral of baljezgarija is


--user signals

  type state_type is (idle, upcount, downcount, processing);
  type state_type2 is (idle, upcount, processing);
  
  signal timer_value :std_logic_vector(31 downto 0);
  signal b2ip_value :std_logic_vector(7 downto 0);
  
  signal next_timer_value: std_logic_vector(31 downto 0);
  signal next_b2ip_value: std_logic_vector(7 downto 0);
  
  signal current_s,next_s: state_type;
  
  signal next_output_value:std_logic;
  signal output_value: std_logic;
  
  --signal next_my_timer_irq:std_logic;
  
  signal timer_reset_sinc: std_logic;
  
  --for timer 2
  
  signal timer2_value: std_logic_vector(31 downto 0);
  --b2ip_value is shared
  signal next_timer2_value: std_logic_vector(31 downto 0);
  signal current_s2, next_s2: state_type2;
  
	signal freq_reg    : std_logic_vector(15 downto 0); --freq
	signal volume_reg    : std_logic_vector(15 downto 0); --volume
	signal en_reg    : std_logic_vector(15 downto 0); -- dozvola
	signal duration_reg    : std_logic_vector(15 downto 0); --duration

begin

	process(iCLK, inRST)
	begin
		if inRST = '0' then
				freq_reg <= conv_std_logic_vector(CLK_FREQ/1, 16);
				volume_reg <= conv_std_logic_vector(999, 16);
				en_reg <= conv_std_logic_vector(1, 16);
				duration_reg <= (others => '1');
		elsif rising_edge(iCLK) then
			if iBUS_WE = '1' then
					if(iBUS_A = x"00") then
						freq_reg <= iBUS_WD;
					elsif(iBUS_A = x"01") then
						volume_reg <= iBUS_WD;
					elsif(iBUS_A = x"02") then
						en_reg <= iBUS_WD;
					elsif(iBUS_A = x"03") then
						duration_reg <= iBUS_WD;
					end if;
			end if;
		end if;
	end process;

	process(iBUS_A, output_value, freq_reg, volume_reg, en_reg, duration_reg)
	begin
		case iBUS_A is
			when x"00" =>
				oBUS_RD <= freq_reg; --freq
			when x"01" =>
				oBUS_RD <= volume_reg; --volume
			when x"02" =>
				oBUS_RD <= en_reg; --dozvola
			when x"03" =>
				oBUS_RD <= duration_reg; --duration
			when others =>
				oBUS_RD <= (others => '0');
		end case;
	end process;

 process (iCLK, inRST)
	begin
		if (inRST='0') then
			current_s <= idle;
			timer_value<=(others => '0');
			b2ip_value<=(others => '0');
			--o_irq <= '0';
			output_value<='0';
			
			--timer2 
			timer2_value<=(others => '0');
			current_s2<=idle;
			
		elsif (rising_edge(iCLK)) then 
			b2ip_value<=next_b2ip_value;
			timer_value<=next_timer_value;
			current_s <= next_s;
			output_value<=next_output_value;
			--o_irq <= next_my_timer_irq;
			
			--timer2
			timer2_value<=next_timer2_value;
			current_s2<=next_s2;
			
	 end if;
end process;

--state machine
process(current_s, en_reg, volume_reg, freq_reg, b2ip_value, timer_value, timer_reset_sinc, output_value)

	begin
	next_s<=current_s;
	next_b2ip_value<=b2ip_value+1;
	next_timer_value<=timer_value;
	next_output_value<=output_value;
	
	
		case current_s is

		when idle =>
			if (en_reg(0)='1') then 
				next_s<=upcount;
			else 
				next_s<=idle;
			end if;

		when upcount =>
			if (b2ip_value=99) then
				next_b2ip_value<=(others=>'0');
				if(timer_value=volume_reg) then
					next_output_value<='1';
					next_timer_value<=timer_value-1;
				end if;
				if(timer_value=freq_reg) then
					next_s<=downcount;
				else
					next_timer_value<=timer_value+1;
				end if;
			end if;
		when downcount=>
			if (b2ip_value=99) then
				next_b2ip_value<=(others=>'0');
				if(timer_value=volume_reg) then
					next_output_value<='0';
					next_timer_value<=timer_value+1;
				end if;
				if(timer_value=0) then
					next_s<=upcount;
				else
					next_timer_value<=timer_value-1;
				end if;
			end if;
		when processing=>
			next_b2ip_value<=(others=>'0');
			next_output_value<='0';
			next_timer_value<=(others=>'0');
			if(en_reg(1)='1') then
				next_s<=idle;
			end if;
			
		end case;
		
		if (timer_reset_sinc='1') then
			next_s<=processing;
		end if;
	end process;
  
  process(current_s2, en_reg, duration_reg, b2ip_value, timer2_value)
  
	begin
		next_s2<=current_s2;
		next_timer2_value<=timer2_value;
		--next_my_timer_irq<='0';
		timer_reset_sinc <= '0';
		
		case current_s2 is
		
		 when idle =>
			if (en_reg(0)='1') then 
				next_s2<=upcount;
			else 
				next_s2<=idle;
			end if;
		 when upcount =>
			if(b2ip_value=99) then
				if(timer2_value=duration_reg) then
					next_timer2_value<=(others=>'0');
					next_s2<=processing;
					--next_my_timer_irq<='1';
					timer_reset_sinc <= '1';
					--permission change
				else
					next_timer2_value<=timer2_value+1;
				end if;
			end if;
		 when processing =>
			if(en_reg(1)='1') then
				next_s2<=idle;
			end if;
		end case;


  end process;

  o_pwm<=output_value;

end architecture;
