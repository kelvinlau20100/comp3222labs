LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use work.t_ff_pkg.all ;
-- can just take this and feed the 8bit output Q into a a sev seg decoder
entity eight_bit_counter is
	port(En, Clk, Clear: in 	std_logic;
		  Q				 : out 	std_logic_vector(7 downto 0)
		 );
end eight_bit_counter;

architecture behaviour of eight_bit_counter is
	signal Q_temp 		: std_logic_vector(7 downto 0);
	signal mul_ands	: std_logic_vector(6 downto 0);
	
begin
	t_ff0: t_ff port map (Clk, En, clear, Q_temp(0));
	mul_ands(0) <= En and Q_temp(0);
	
	t_ff1: t_ff port map (clk, mul_ands(0), clear, Q_temp(1));
	mul_ands(1) <= mul_ands(0) and Q_temp(1);
	
	t_ff2: t_ff port map (clk, mul_ands(1), clear, Q_temp(2));
	mul_ands(2) <= mul_ands(1) and Q_temp(2);
	
	t_ff3: t_ff port map (clk, mul_ands(2), clear, Q_temp(3));
	mul_ands(3) <= mul_ands(2) and Q_temp(3);

	t_ff4: t_ff port map (clk, mul_ands(3), clear, Q_temp(4));
	mul_ands(4) <= mul_ands(3) and Q_temp(4);	
	
	t_ff5: t_ff port map (clk, mul_ands(4), clear, Q_temp(5));
	mul_ands(5) <= mul_ands(4) and Q_temp(5);
	
	t_ff6: t_ff port map (clk, mul_ands(5), clear, Q_temp(6));
	mul_ands(6) <= mul_ands(5) and Q_temp(6);

	t_ff7: t_ff port map (clk, mul_ands(6), clear, Q_temp(7));

	Q <= Q_temp;
end behaviour; 