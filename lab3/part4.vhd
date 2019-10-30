------------------------------------------
-- Part 4 combination of D latch, Pos Edge D flip-flop and Neg Edge D flip-flop

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity part4 is
	port( D, Clk	: in	std_logic;
			Q			: out std_logic_vector(2 downto 0));
end part4;

architecture behaviour of part4 is
	component g_d_latch
		port(D, Clk	: in 	std_logic;
			  Q		: out std_logic);
	end component;
	
	component pos_ff
		port (D, Clk : in std_logic;
				Q : out std_logic);	
	end component;
	
	component neg_ff
		port (D, Clk : in std_logic;
				Q : out std_logic);
	end component;
begin
	d_latch: g_d_latch port map (D, Clk, Q(2));
	ff1:		pos_ff	 port map (D, Clk, Q(1));
	ff2:		neg_ff	 port map (D, Clk, Q(0));
end behaviour;

-------------------------------------------
-- A gated D latch

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity g_d_latch is
	port(D, Clk : in std_logic;
		  Q		 : out std_logic);
end g_d_latch;

architecture behaviour of g_d_latch is
begin
	process (D, Clk)
	begin
		if clk = '1' then
			Q <= D;
		end if;
	end process;
end behaviour;

-----------------------------------------
-- Positive edge D flip-flop
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity pos_ff is
port (D, Clk : in std_logic;
		Q : out std_logic);
end pos_ff;

architecture behaviour of pos_ff is
begin
	process (Clk)
	begin
		if Clk'event AND Clk = '1' then
			q <= D;
		end if;
	end process;
end behaviour;

-----------------------------------------
-- Negative edge D flip-flop
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

entity neg_ff is
port (D, Clk : in std_logic;
		Q : out std_logic);
end neg_ff;

architecture behaviour of neg_ff is 
begin
	process
	begin
		wait until Clk'event AND Clk = '0';
		Q <= D;
	end process;
end behaviour;

------------------------------------------
