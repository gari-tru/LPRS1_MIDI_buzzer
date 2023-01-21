
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library std;
use std.textio.all;

use ieee.math_real.all;

library work;

entity int_div_tb is
end int_div_tb;

architecture Behavior of int_div_tb is
	constant n_beg : integer := -254; -- TODO 255
	constant n_end : integer := 255;
	
	constant d_beg : integer := 2; -- TODO 1
	constant d_end : integer := 255;
	
	constant i_clk_period : time := 10 ns; -- 100MHz
	
	signal i_clk       : std_logic := '0';
	signal in_rst      : std_logic := '0';
	signal i_num       : std_logic_vector(23 downto 0);
	signal i_den       : std_logic_vector(7 downto 0);
	signal o_res       : std_logic_vector(15 downto 0);
	
	signal non_shifted_num : integer;
	signal num         : integer;
	signal den         : integer;
	signal exp_res     : integer;
	signal obs_res     : integer;
	
	
	file fo : text open WRITE_MODE is "STD_OUTPUT";

begin


	-- Instantiate the Unit Under Test (UUT)
	uut: entity work.int_div
	port map(
		i_clk     => i_clk,
		in_rst    => in_rst,

		i_num     => i_num,
		i_den     => i_den,
		o_res     => o_res
	);


	-- Clock process definitions
	i_clk_proc: process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;


	playground: if 1 = 0 generate
		-- Stimulus process
		gen_proc: process
		begin
			in_rst <= '0';
			wait for i_clk_period;
			in_rst <= '1';

			num <= -10;
			den <= 2;
			wait for 0 ns;
			i_num <= conv_std_logic_vector(num, 24);
			i_den <= conv_std_logic_vector(den, 8);
			wait for i_clk_period;
			

			num <= +10;
			den <= 2;
			wait for 0 ns;
			i_num <= conv_std_logic_vector(num, 24);
			i_den <= conv_std_logic_vector(den, 8);
			wait for i_clk_period;

		
			wait;
		end process;
	end generate;
	
	full_test: if 0 = 0 generate
		-- Stimulus process
		gen_proc: process
		begin
			in_rst <= '0';
			wait for i_clk_period;
			in_rst <= '1';
			
			for n in n_beg to n_end loop
				for d in d_beg to d_end loop
					
					non_shifted_num <= n;
					num <= n*256; -- << 8
					den <= d;
					wait for 0 ns;
					i_num <= conv_std_logic_vector(num, 24);
					i_den <= conv_std_logic_vector(den, 8);
					
					wait for i_clk_period;
					
				end loop;
			end loop;

		
			wait;
		end process;

		mon_proc: process
			variable num : integer;
			variable den : integer;
			variable l : line;
		begin
			wait for 19*i_clk_period;
		
			for n in n_beg to n_end loop
				for d in d_beg to d_end loop
				
					num := n*256; -- << 8
					den := d;
					exp_res <= num/den;
					obs_res <= conv_integer(signed(o_res));
					wait for 0 ns;
					
					if abs(exp_res - obs_res) > 1 then
						write(l, string'("Fail:"));
						write(l, string'("    t = "));
							write(l, time'image(now));
							--write(l, integer'image(time'pos(now)/1000000));
							--write(l, integer'image(integer(floor(real(time'pos(now))/1000000.0))));
							--write(l, real'image(floor(real(time'pos(now))/1000000.0)));
							--write(l, string'(" ns"));
						write(l, string'(" ns"));
						write(l, string'("    n = "));
							write(l, integer'image(n));
						write(l, string'("    num = "));
							write(l, integer'image(num));
						write(l, string'("    d = "));
							write(l, integer'image(d));
						write(l, string'("    exp_res = "));
							write(l, integer'image(exp_res));
						write(l, string'("    obs_res = "));
							write(l, integer'image(obs_res));
						writeline(fo, l);
					end if;
					
					wait for i_clk_period;
				end loop;
			end loop;
		
			write(l, string'("End"));
			writeline(fo, l); 
			wait;
		end process;
	end generate;


end architecture;
