LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY part4 IS
	PORT(	KEY						:IN	std_logic_vector(3 DOWNTO 0);
		SW						:IN	std_logic_vector(9 DOWNTO 0);
		CLOCK_50					:IN	std_logic;
		LEDR						:OUT 	std_logic_vector(9 DOWNTO 0));
END part4;

ARCHITECTURE mixed OF part4 IS
	COMPONENT shiftrne IS
		GENERIC ( N : INTEGER := 4 ) ;
		PORT ( R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;
		       L, E, w : IN STD_LOGIC ;
		       Clock : IN STD_LOGIC ;
	 	       Q : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0) ) ;
	END COMPONENT;
	COMPONENT half_sec_timer IS
		PORT ( Clk, Start : IN STD_LOGIC ;
		       TOut : OUT STD_LOGIC);
	END COMPONENT;
	SIGNAL Clk, nReset, w, z, shft, TStart, TOut : std_logic;
	SIGNAL LR, CR, QL, QC : std_logic_vector(3 DOWNTO 0); -- length and code values and shift register contents
	SIGNAL sel : std_logic_vector(2 DOWNTO 0);
	
	--here we have all our necessary states
	TYPE state_t IS (Init, dot, pause, dash1, dash2, dash3, dot_treset, dash1_treset, dash2_treset, dash3_treset, pausedot_treset, pausedash_treset);
	SIGNAL y_Q, Y_D : state_t;
BEGIN
	Clk <= CLOCK_50;
	nReset <= KEY(0);
	w <= NOT KEY(1); -- start signal
	LEDR(3 DOWNTO 0) <= not QC; -- code register, here ive changed it as my LED's are active low so i need to not the output
	LEDR(7 DOWNTO 4) <= QL; -- length register, same as for LEDR
	LEDR(9) <= not z; -- Morse output symbol
	sel <= SW(2 DOWNTO 0);
	
	WITH sel SELECT
		CR <= "0010" WHEN "000", -- code register 0=dot, 1=dash, listed from lsb to msb
				"0001" WHEN "001",
				"0101" WHEN "010",
				"0001" WHEN "011",
				"0000" WHEN "100",
				"0100" WHEN "101",
				"0011" WHEN "110",
				"0000" WHEN "111",
				"0000" WHEN OTHERS;
				
	WITH sel SELECT	
		LR <= "0011" WHEN "000", -- length register in unary from lsb
				"1111" WHEN "001",
				"1111" WHEN "010",
				"0111" WHEN "011",
				"0001" WHEN "100",
				"1111" WHEN "101",
				"0111" WHEN "110",
				"1111" WHEN "111",
				"0000" WHEN OTHERS;
	
	LenReg: shiftrne PORT MAP (LR, w, shft,'0', Clk, QL);
	CodeReg: shiftrne PORT MAP (CR, w, shft, '0', Clk, QC);
	Timer: half_sec_timer PORT MAP (Clk, TStart, TOut);

	
-- since w is **not key(1)** we will treat it as a normal signal i.e, not the opposite polarity
-- Tout will be high when 0.5 seconds has been counted
-- QL(0) represents whether there morse code has a character left to display or not
-- QC(0) represents whether it is a dot or a dash
-- y_Q is our current state
-- we only need to consider w = '0' for init as in the shift register it is only used to load our registers with the switches
-- after that we go through the register until whatever is inside is finished
	FSM_transitions: PROCESS (y_Q, w, QL(0), QC(0), TOut)
		BEGIN
			CASE y_Q IS
				--first case here is that at INIT if length is 1 and data is 0 then we display a dot 
				--if length is 0 and data is 1 then we display the first stage of a dash
				when Init =>
					if w = '0' then
						Y_D <= Init;
					else
						if (QL(0) = '1' and QC(0) = '0') then
							Y_D <= dot;
						elsif (QL(0) = '1' and QC(0) = '1') then
							Y_D <= dash1;
						else 
							Y_D <= init;
						end if;
					end if;
				
				--here when displaying dot, if not yet 0.5s then stay at dot otherwise we need to jump to a state that resets the timer
				when dot =>
					if TOut = '0' then 
						Y_D <= dot;
					else 
						Y_D <= dot_treset;
					end if;
				
				-- we simply go to this state in order to reset the timer *this could be simplified as you will see further on
				when dot_treset =>
						Y_D <= pause;
				
				--here we either jump to a reset in which we go then go to either the timer reset before we display a dot, a dash or to init
				when pause =>
					if TOut = '0' then
						Y_D <= pause;
					elsif (QL(0) = '1' and QC(0) = '0') then
						Y_D <= pausedot_treset;
					elsif (QL(0) = '1' and QC(0) = '1') then
							Y_D <= pausedash_treset;
					else
						Y_D <= Init;
					end if;
			
				when pausedot_treset =>
					Y_D <= dot;
				
				when pausedash_treset=>
					Y_D <= dash1;
				
				-- at dash1 we wait for 0.5s before we move on to timer reset and then dash2
				when dash1 =>
					if TOut = '0' then
						Y_D <= dash1;
					else
						Y_D <= dash1_treset;
					end if;
				
				when dash1_treset =>
					Y_D <= dash2;
				
				-- similar to dash1 wait for 0.5s before timer reset and then dash3
				when dash2 =>
					if TOut = '0' then
						y_D <= dash2;
					else
							y_D <= dash2_treset;
					end if;

					
				when dash2_treset =>
					y_D <= dash3;	

				--here we have reached the 3rd stage and now should have been displaying for 0.5x3 = 1.5s so we move onto pause again
				when dash3 =>
					if TOut = '0' then
						y_D <= dash3_treset;
					else
						y_D <= pause;
					end if;
		
				
				when dash3_treset =>
					y_D <= pause;
					
			END CASE;
		END PROCESS;
		
		
		--nReset = '0' because the Key is at high when not pushed and low when pushed this is simply making the current state = to next state
		FSM_state: PROCESS (Clk, nReset)
			BEGIN
				IF (nReset = '0') THEN
					y_Q <= Init;
				ELSIF (Clk'event AND Clk = '1') THEN
					y_Q <= Y_D;
				END IF;
			END PROCESS;
		
	
	
		-- here we need to define the outputs what needs to occur is that at certain points we will either shift to the next location of both the 
		-- data and length registers. We do this by making shft = '1' shft == E for the shiftrne block
		-- TStart == start for the half_sec_timer block, when start = 1 it resets the timer if we set start = 0 it then counts up to 25million before
		-- toggling TOut this is why previously we needed all the extra states to reset the timer
		-- There is probably a better way of implementing the timer reset based on QC(0) and QL(0) but for now this is what I have come up with
		FSM_outputs: PROCESS (y_Q)
			BEGIN
				CASE y_Q IS
			--we always shft at init as that lets us load a new word into the registers
			--we also constantly restart the timer so that its at 0 whenever we go to next state
			when Init =>
				z <= '0';
				shft <= '1';
				TStart <= '1';
			
			-- when we are dot we want output LED on and we don't want to shift, we also start the 0.5s timer
			when dot =>
				z <= '1';
				shft <= '0';
				TStart <= '0';
				
			-- all we want to do is reset timer but we turn led off here because 0.5s is over but we shift so that we can check what we need to output next
			-- at pause
			when dot_treset =>
				TStart <= '1';
				shft <= '1';
				z <= '0';
				
			-- no output, start timer to wait 0.5s, don't shift as we already have stuff loaded from before
			when pause =>
				z <= '0';
				shft <= '0';
				TStart <= '0';
			
			-- no output, reset timer, don't shift and then go straight to outputting the dot
			when pausedot_treset =>
				z <= '0';
				shft <= '0';
				TStart <= '1';
			
			-- no output, reset timer, don't shift and then go straight to outputting first stage of dash
			when pausedash_treset =>
				z <= '0';
				shft <= '0';
				TStart <= '1';
			
			-- output, start timer for 0.5s, don't shift and then go to next stage of dash
			when dash1 =>
				z <= '1';
				shft <= '0';
				TStart <= '0';
			
			-- output on as we are displaying the 1onger 1.5s dash, reset the timer, don't shift
			when dash1_treset =>
				z <= '1';
				shft <= '0';
				TStart <= '1';
			
			-- output on, wait for 0.5s, don't shift
			when dash2 =>
				z <= '1';
				shft <= '0';
				TStart <= '0';
				
			-- output on, reset timer
			when dash2_treset =>
				z <= '1';
				shft <= '0';
				TStart <= '1';
			
			--output on, start timer, don't shift yet
			when dash3 =>
				z <= '1';
				shft <= '0';
				TStart <= '0';		
			
			--output off as 1.5s shouldve been calculated, reset the timer and shift the registers so that pause can evaluate what to do next
			when dash3_treset =>
				z <= '0';
				TStart <= '1';
				shft <= '1';
				
				END CASE;
			END PROCESS;

END mixed;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY shiftrne IS
	GENERIC ( N : INTEGER := 4 ) ;
	PORT ( R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;
			 L, E, w : IN STD_LOGIC ;
			 Clock : IN STD_LOGIC ;
			 Q : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0) ) ;
END shiftrne ;

ARCHITECTURE Behavior OF shiftrne IS
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL (Clock'EVENT AND Clock = '1');
		IF (E = '1') THEN -- if enabled
			IF (L = '1') THEN -- depending upon the load signal
				Q <= R; -- either load a new word in parallel
			ELSE 
				Genbits: FOR i IN 0 TO N-2 LOOP -- or shift the word to right
					Q(i) <= Q(i+1);
				END LOOP;
				Q(N-1) <= w;
			END IF;
		END IF;
	END PROCESS;
END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY half_sec_timer IS
	PORT ( Clk, Start : IN STD_LOGIC ;
			 TOut : OUT STD_LOGIC);
END half_sec_timer;

ARCHITECTURE Behavior OF half_sec_timer IS
	SIGNAL Q : INTEGER RANGE 0 TO 25000000;
BEGIN
	PROCESS (Clk)
	BEGIN
		IF (Clk'event AND Clk = '1') THEN
			IF (Start = '1') THEN
				TOut <= '0';
				Q <= 0;
			ELSIF (Q = 25000000) THEN
				TOut <= '1';
				Q <= 0;
			ELSE
				TOut <= '0';
				Q <= Q + 1;
			END IF;
		END IF;
	END PROCESS;
END Behavior;
