LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.d_ff_package.all;

------state machine must be initialised by reset high first

entity part1 is
	port(
		reset : in std_logic;
		clk : in std_logic;
		w : in std_logic;
		z : out std_logic;
		y_Q : out std_logic_vector(8 downto 0)
	);
end part1;

architecture behaviour of part1 is
	signal temp_y_Q, y_D : std_logic_vector(8 downto 0);
	
begin
	--generate the d flip flops (Q, CLK, D)
	G1: for i in 1 to 8 generate
		dffs: d_ff port map(
						temp_y_Q(i), clk, reset, y_D(i)
						);
		end generate;
		
	init_dff: d_ff port map(
						temp_y_Q(0), clk, reset, y_D(0)
						);
	
	--original FSM code
	--init_dff: d_ff port map(
	--					temp_y_Q(0), clk, not reset, '1'
	--					);

	--create the necessary logic
	
	--modified FSM onehot states
	y_D(0) <= '1';	
	y_D(1) <= (not w) and (temp_y_Q(8) or temp_y_Q(7) or temp_y_Q(6) or temp_y_Q(5) or (not temp_y_Q(0)));
	
	--original FSM code
	--	y_D(0) <= '0';	
	--y_D(1) <= (not w) and (temp_y_Q(8) or temp_y_Q(7) or temp_y_Q(6) or temp_y_Q(5) or temp_y_Q(0));
	
	y_D(2) <= (not w) and temp_y_Q(1);
	y_D(3) <= (not w) and temp_y_Q(2);
	y_D(4) <= (not w) and (temp_y_Q(4) or temp_y_Q(3));
	
	y_D(5) <= w and (temp_y_Q(4) or temp_y_Q(3) or temp_y_Q(2) or temp_y_Q(1) or (not temp_y_Q(0)));
	--y_D(5) <= w and (temp_y_Q(4) or temp_y_Q(3) or temp_y_Q(2) or temp_y_Q(1) or temp_y_Q(0));
	y_D(6) <= w and temp_y_Q(5);
	y_D(7) <= w and temp_y_Q(6);
	y_D(8) <= w and (temp_y_Q(8) or temp_y_Q(7));
	
	--define outputs
	y_Q <= temp_y_Q;
	z <= temp_y_Q(8) or temp_y_Q(4);
end behaviour;