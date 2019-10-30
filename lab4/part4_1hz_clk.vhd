-- this entity takes the 1 hz clock and counts from 0 to 9 at 1 Hz all that needs to be done is to feed this into a sev seg decoder


LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;

entity part4 is
	port(clk: in std_logic;
		  q: out std_logic_vector(3 downto 0)
		  );
end part4;

architecture behaviour of part4 is
	signal slow_clk: std_logic;
	signal count: std_logic_vector(3 downto 0);
	component slowdown 
			port(fast_clk: in std_logic;
				  slow_clk: out std_logic
			    );
	end component;
begin
	slowtheclock: slowdown port map (clk, slow_clk);
	process(slow_clk)
	begin
		if slow_clk'event and slow_clk = '1' then
			if count = "1001" then
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	q <= NOT count;
end behaviour;


--------------- get a 1 Hz clock -----------------------------------------------

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;

entity slowdown is
	port(fast_clk: in std_logic;
		  slow_clk: out std_logic
		 );
end slowdown;

architecture behaviour of slowdown is 
	signal count  : std_logic_vector(24 downto 0);
	signal toggle : std_logic;
begin
	process(fast_clk)
	begin
		if(fast_clk'event and fast_clk = '1') then
			if count = "1011111010111100001000000" then -- counts up to 25 million
				toggle <= not toggle;
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	slow_clk <= toggle;
end behaviour;