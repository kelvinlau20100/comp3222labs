LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity d_ff is
	port(
		Q : out std_logic;
		clk : in std_logic;
		reset : in std_logic;
		D : in std_logic
		);
end d_ff;

architecture behavioural of d_ff is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				Q <= '0';
			else
				Q <= D;
			end if;
		end if;
	end process;
end behavioural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

package d_ff_package is
	component d_ff
		port(
			Q : out std_logic;
			clk : in std_logic;
			reset: in std_logic;
			D : in std_logic
		);
	end component;
end d_ff_package;
	