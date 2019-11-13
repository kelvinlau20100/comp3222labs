LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY part1 IS
	PORT (DIN : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			Resetn, Clock, Run : IN STD_LOGIC;
			Done : BUFFER STD_LOGIC;
			BusWires : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0)
			);
END part1;

ARCHITECTURE Behavior OF part1 IS

	-- declare components
	-- declare signals
	component regn is 
		GENERIC (n : INTEGER := 9);
		PORT (R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				Rin, Clock : IN STD_LOGIC;
				Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0)
				);
	end component;
	
	component dec3to8 is
		PORT (W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				En : IN STD_LOGIC;
				Y : OUT STD_LOGIC_VECTOR(0 TO 7)
				);
	end component;
	
	signal Hi : std_logic;
	
	signal R0 : std_logic_vector(8 downto 0);
	signal R1 : std_logic_vector(8 downto 0);
	signal R2 : std_logic_vector(8 downto 0);
	signal R3 : std_logic_vector(8 downto 0);
	signal R4 : std_logic_vector(8 downto 0);
	signal R5 : std_logic_vector(8 downto 0);
	signal R6 : std_logic_vector(8 downto 0);
	signal R7 : std_logic_vector(8 downto 0);
	Signal IR : std_logic_vector(8 downto 0); -- Instruction Register
	signal A  : std_logic_vector(8 downto 0);
	signal G  : std_logic_vector(8 downto 0);
	
	signal IRin : std_logic; -- choose to load Din to IR
	signal Rin : std_logic_vector(7 downto 0); -- choose which register to load the bus into
	signal Ain : std_logic;
	signal Gin : std_logic;
	
	signal Xreg : std_logic_vector(7 downto 0); -- this are the registers which we look to load or not through the time cycles
	signal Yreg : std_logic_vector(7 downto 0);

	signal Rout : std_logic_vector(7 downto 0);	
	signal DINout : std_logic; -- choose to select Din onto the bus
	signal Gout : std_logic; -- choose to load the addsub result onto the bus

	
	signal I : std_logic_vector(2 downto 0); --contains the instructions
	signal AddSub : std_logic; --chooses whether to add or sub in the add/sub module
	signal Temp_Sum : std_logic_vector(8 downto 0); -- temporary variable to store the add/sub sum
	
	TYPE State_type IS (T0, T1, T2, T3);
	SIGNAL Tstep_Q, Tstep_D: State_type;
	--
BEGIN
	Hi <= '1';
	I <= IR(8 DOWNTO 6); 										-- this is the instruction we want
	decX: dec3to8 PORT MAP (IR(5 DOWNTO 3), Hi, Xreg);	-- this is register 1
	decY: dec3to8 PORT MAP (IR(2 DOWNTO 0), Hi, Yreg);	-- this is register 2

	
---------------------------------------------------------------------------------------------------------------------------------------------------------	
	statetable: PROCESS (Tstep_Q, Run, Done)
	BEGIN
	
		--when T0 stay in T0 until run is asserted then start going else check if done then go to T0 otherwise go to next time step
		-- we don't need to check because T2 will never assert the Done signal
		
		CASE Tstep_Q IS
			WHEN T0 => -- data is loaded into IR in this time step
				IF (Run = '0') THEN
					Tstep_D <= T0;
				ELSE 
					Tstep_D <= T1;
				END IF;
				
			-- other states

			when T1 =>
				if (Done = '1') then
					Tstep_D <= T0;
				else
					Tstep_D <= T2;
				end if;
			
			when T2 =>
					Tstep_D <= T3;
				
			when T3 =>
				if (Done = '1') then
					Tstep_D <= T0;
				else
					Tstep_D <= T3;
				end if;					
		END CASE;
	END PROCESS;

--------------------------------------------------------------------------------------------------------------------------------
	
--------------------------------------------------------------------------------------------------------------------------------	
	-- follow the table basically assert all the different control signals depending on what time step we are at
	controlsignals: PROCESS (Tstep_Q, I, Xreg, Yreg)
	BEGIN
		-- specify initial values
		Done <= '0';
		Ain <= '0';
		Gin <= '0';
		Gout <= '0';
		Rin <= "00000000";
		Rout <= "00000000";
		IRin <= '0';
		DINout <= '0';
		AddSub <= '0';
		
		CASE Tstep_Q IS
			WHEN T0 => -- store DIN in IR as long as Tstep_Q = 0
				IRin <= '1';
			WHEN T1 => -- define signals in time step T1
				CASE I IS
				---
					when "000" => -- mv
						Rout <= Yreg;
						Rin <= Xreg;
						Done <= '1';
					when "001" => -- mvi
						DINout <= '1';
						Rin <= Xreg;
						Done <= '1';
					when others => --add/sub
						Ain <= '1';
						Rout <= Xreg;
				END CASE;
			WHEN T2 => -- define signals in time step T2
				CASE I IS
				---
					when "010" => --add
						Rout <= Yreg;
						Gin <= '1';
					when "011" => --sub
						Rout <= Yreg;
						Gin <= '1';
						AddSub <= '1';
					when others => -- mv/mvi do nothing
				END CASE;
			WHEN T3 => -- define signals in time step T3
				CASE I IS
				---
					when "010" => --add
						Gout <= '1';
						Rin <= Xreg;
						Done <= '1';
					when "011" => -- sub
						Gout <= '1';
						Rin <= Xreg;
						Done <= '1';
					when others => -- mv/mvi do nothing
				END CASE;
		END CASE;
	END PROCESS;
	
---------------------------------------------------------------------------------------------------------------------------------


	fsmflipflops: PROCESS (Clock, Resetn)
	BEGIN
		if (Resetn = '0') then
			Tstep_Q <= T0;
		elsif rising_edge(Clock) then
			Tstep_Q <= Tstep_D;
		end if;
	END PROCESS;

---------------------------------------------------------------------------------------------------------------------------------	

	-- instantiate registers and the adder/subtracter unit
	
	reg_IR : regn PORT MAP (DIN, IRin, Clock, IR);
	reg_0: regn PORT MAP (BusWires, Rin(0), Clock, R0);
	reg_1: regn PORT MAP (BusWires, Rin(1), Clock, R1);
	reg_2: regn PORT MAP (BusWires, Rin(2), Clock, R2);
	reg_3: regn PORT MAP (BusWires, Rin(3), Clock, R3);
	reg_4: regn PORT MAP (BusWires, Rin(4), Clock, R4);
	reg_5: regn PORT MAP (BusWires, Rin(5), Clock, R5);
	reg_6: regn PORT MAP (BusWires, Rin(6), Clock, R6);
	reg_7: regn PORT MAP (BusWires, Rin(7), Clock, R7);
	
	reg_A: regn PORT MAP (BusWires, Ain, Clock, A);
	
	alu: with AddSub select
		Temp_Sum <= A + BusWires when '0',
			  A - BusWires when others;
			  
	reg_G: regn PORT MAP (Temp_Sum, Gin, Clock, G);
	
	
	-- define the bus
	with (Rout & Gout & DINout) select
		BusWires <= R0 when "0000000100",
						R1 when "0000001000",
						R2 when "0000010000",
						R3 when "0000100000",
						R4 when "0001000000",
						R5 when "0010000000",
						R6 when "0100000000",
						R7 when "1000000000",
						G  when "0000000010",
						DIN when others;
						
END Behavior;

------------------------------------------------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dec3to8 IS
	PORT (W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			En : IN STD_LOGIC;
			Y : OUT STD_LOGIC_VECTOR(0 TO 7));
END dec3to8;

ARCHITECTURE Behavior OF dec3to8 IS
BEGIN
	PROCESS (W, En)
	BEGIN
		IF (En = '1') THEN
			CASE W IS
				WHEN "000" => Y <= "10000000";
				WHEN "001" => Y <= "01000000";
				WHEN "010" => Y <= "00100000";
				WHEN "011" => Y <= "00010000";
				WHEN "100" => Y <= "00001000";
				WHEN "101" => Y <= "00000100";
				WHEN "110" => Y <= "00000010";
				WHEN "111" => Y <= "00000001";
			END CASE;
		ELSE
			Y <= "00000000";
		END IF;
	END PROCESS;
END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn IS
	GENERIC (n : INTEGER := 9);
	PORT (R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			Rin, Clock : IN STD_LOGIC;
			Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END regn;

ARCHITECTURE Behavior OF regn IS
BEGIN
	PROCESS (Clock)
	BEGIN
		IF (rising_edge(Clock)) THEN
			IF (Rin = '1') THEN
				Q <= R;
			END IF;
		END IF;
	END PROCESS;
END Behavior;
