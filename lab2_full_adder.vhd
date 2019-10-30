LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder IS
	PORT (x, y, Cin : IN STD_LOGIC;
			s, Cout : OUT STD_LOGIC);
END full_adder;

ARCHITECTURE LogicFunc of full_adder IS
BEGIN
	s <= x XOR y XOR Cin;
	COUT <= (x AND y) OR (Cin and x) OR (Cin AND y);
END LogicFunc;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE full_adder_package IS
	COMPONENT full_adder
		PORT ( x, y, Cin : IN STD_LOGIC;
				s, Cout : OUT STD_LOGIC);
	END COMPONENT;
END full_adder_package;
		


			