LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity T_ff is
	port( Clk, T, clear : in		std_logic;
			Q		 		  : out		std_logic
		 );
end T_ff;

architecture behaviour of T_ff is
	signal Q_1 : std_logic;
begin
	process(clk, clear)
	begin
		if clear = '0' then
			Q_1 <= '0';
		elsif (clk'event and clk = '1') then
			Q_1 <= T xor Q_1;
		end if;
	end process;
	
	Q <= Q_1;
end behaviour;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

package t_ff_pkg is
	component T_ff
		port( Clk, T, clear : in		std_logic;
				Q		 		  : out		std_logic
			 );
	end component;
end t_ff_pkg;