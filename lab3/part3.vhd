LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.part2_package.all;

entity part3 is
	port( Clk, D : in std_logic;
			Q : out std_logic);
end part3;

architecture struct of part3 is
	signal Q_m : std_logic;
	attribute keep : boolean;
	attribute keep of Q_m : signal is true;
begin
	dlatch_0 : part2 port map ((NOT Clk), D, Q_m);
	dlatch_1 : part2 port map (clk, Q_m, Q);
end struct;