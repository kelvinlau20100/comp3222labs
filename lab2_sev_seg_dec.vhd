LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sev_seg_dec IS
	PORT(B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 M: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END sev_seg_dec;

ARCHITECTURE LogicFunc of sev_seg_dec IS
BEGIN	
	--M(6) -> 6 and M(0) -> 0 for the seven segment display where it is active low
	
	M(0) <= (B(2) AND (NOT B(1)) AND (NOT B(0))) OR ( (NOT B(3)) AND (NOT B(2)) AND (NOT B(1)) AND B(0));
	M(1) <= B(2) AND (B(1) XOR B(0));
	M(2) <= (NOT B(2)) AND B(1) AND (NOT B(0));
	M(3) <= (B(2) AND ( ( (NOT B(1)) AND (NOT B(0)) ) OR ( B(1) AND B(0) ) ) ) OR ((NOT B(3)) AND (NOT B(2)) AND (NOT B(1)) AND B(0));
	M(4) <= B(0) OR (B(2) AND (NOT B(1)));
	M(5) <= ((NOT B(2)) AND B(1)) OR (B(1) AND B(0)) OR ((NOT B(3)) AND (NOT B(2)) AND B(0));
	M(6) <= ((NOT B(3)) AND (NOT B(2)) AND (NOT B(1))) OR (B(2) AND B(1) and B(0));
	
	
END LogicFunc;
	
LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE ssd_package IS
	COMPONENT sev_seg_dec
		PORT(B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 M: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;
END ssd_package;