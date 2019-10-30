LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part2 IS
	PORT (
			Clock : in std_logic;
			Reset : in std_logic;
			w : in std_logic;
			z : out std_logic;
			leds : out std_logic_vector(3 downto 0)
			);
END part2;


ARCHITECTURE Behavior OF part2 IS

	
	TYPE State_type IS (A, B, C, D, E, F, G, H, I);
	--Attribute to declare a specific encoding for the states
	attribute syn_encoding : string;
	attribute syn_encoding of State_type : type is "0000 0001 0010 0011 0100 0101 0110 0111 1000";
	
	SIGNAL y_Q, Y_D : State_type; -- y_Q is present state, y_D is next state
	signal notclock : std_logic;
	
BEGIN
	notclock <= not clock;
	PROCESS (w, y_Q) -- state table
	BEGIN
		case y_Q IS
			WHEN A => 
				if (w = '0') then
					Y_D <= B;
				else
					Y_D <= F;
				end if;
			when B =>
				if (w = '0') then
					Y_D <= C;
				else
					Y_D <= F;
				end if;
			when C => 
				if (w = '0') then
					Y_D <= D;
				else
					Y_D <= F;
				end if;
			when D =>
				if (w = '0') then
					Y_D <= E;
				else
					Y_D <= F;
				end if;
			when E =>
				if (w = '0') then
					Y_D <= E;
				else
					Y_D <= F;
				end if;
			when F =>
				if (w = '0') then
					Y_D <= B;
				else
					Y_D <= G;
				end if;
			when G =>
				if (w = '0') then
					Y_D <= B;
				else
					Y_D <= H;
				end if;
			when H =>
				if (w = '0') then
					Y_D <= B;
				else
					Y_D <= I;
				end if;
			when I =>
				if (w = '0') then
					Y_D <= B;
				else
					Y_D <= I;
				end if;				
		END CASE;
	END PROCESS; -- state table
	
	PROCESS (notclock, Reset) -- state flip-flops
	BEGIN
		if (rising_edge(notclock)) then
			if (Reset = '1') then
				y_Q <= A;
			else
				y_Q <= y_D;
			end if;
		end if;
	END PROCESS;

	--assignments for output z and the LEDs
	z <= '0' when (y_Q = E or y_Q = I) else '1';
	process (y_Q)
	begin
		if y_Q = A then
			leds <= not "0000";
		elsif y_Q = B then
			leds <= not "0001";
		elsif y_Q = C then
			leds <= not "0010";
		elsif y_Q = D then
			leds <= not "0011";
		elsif y_Q = E then
			leds <= not "0100";
		elsif y_Q = F then
			leds <= not "0101";
		elsif y_Q = G then
			leds <= not "0110";
		elsif y_Q = H then
			leds <= not "0111";
		elsif y_Q = I then
			leds <= not "1000";
		end if;
	end process;
		
END Behavior;
