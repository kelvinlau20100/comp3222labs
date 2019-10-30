LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;

entity part2 is
	port( clk, reset, enable: in	std_logic;
			q						: out std_logic_vector(15 downto 0)
		 );
end part2;

architecture behaviour of part2 is
	signal count : std_logic_vector(15 downto 0);
begin
	process(clk, reset)
	begin
		if reset = '0' then
			count <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (enable = '1') then
				count <= count + 1;
			else
				count <= count;
			end if;
		end if;
	end process;
	q <= count;
end behaviour;