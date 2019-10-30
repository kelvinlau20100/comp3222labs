--gated D latch
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity part2 is
	port( Clk, D : in std_logic ;
			Q : out std_logic);
end part2;

architecture logicfunc of part2 is
	signal S_g, R_g, Q_a, Q_b : std_logic;
	ATTRIBUTE keep : boolean;
	ATTRIBUTE keep of S_g, R_g, Qa, Qb : SIGNAL IS true;
begin	
	S_g <= D NAND Clk;
	R_G <= (NOT D) NAND Clk;
	Q_a <= S_g NAND Q_b;
	Q_b <= R_g NAND Q_a;
	Q <= Q_a;
end logicfunc;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

package part2_package is
	component part2
		port( Clk, D : in std_logic;
				Q : out std_logic);
	end component;
end part2_package;