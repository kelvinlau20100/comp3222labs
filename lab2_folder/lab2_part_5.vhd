LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--INPUT A -> SW (7-4) B-> SW (3-0) c_in -> SW 8
--OUTPUTS S_1 -> HEX1 should display 1 if C_1 == 1
--S_0 -> binary input into sev_seg_decoder for HEX0
ENTITY part5 IS
	PORT(A, B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  c_in: IN STD_LOGIC;
		  S_0: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  S_1: OUT STD_LOGIC);
end part5;

ARCHITECTURE Behaviour of part5 IS
	SIGNAL T_0:STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Z_0: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL temp: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL C_1: STD_LOGIC;
BEGIN
	PROCESS(T_0, A, B, c_in)
	BEGIN
		T_0 <= ('0' & A) + ('0' & B) + ("0000" & c_in) ;
		-- & is concatenate operation must do this to match vector sizes
		-- There is probably a better way to do this Had to make vectors 5 bits in order to store up to 19
		IF T_0 > "1001" THEN
			Z_0 <= "01010";
			C_1 <= '1';
		ELSE
			Z_0 <= (OTHERS => '0');
			C_1 <= '0';
		END IF;
	END PROCESS;
	temp <= T_0 - Z_0;
	--Not sure if this is allowed you may have to change this to an addition to perform subtraction....
	-- Maybe using 2's complement, ask lab demo potentially
	S_0 <= temp(3 DOWNTO 0);
	S_1 <= C_1;
END Behaviour;
		
