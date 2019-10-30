LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.full_adder_package.all; 

ENTITY adder4 IS
	PORT (Cin: IN STD_LOGIC;
			X: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Y: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			S: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cout: OUT STD_LOGIC);
END adder4;

ARCHITECTURE Structure OF adder4 IS
	SIGNAL C : STD_LOGIC_VECTOR(1 to 3) ;
	
BEGIN
	add0: full_adder PORT MAP ( X(0), Y(0), Cin, S(0), C(1));
	add1: full_adder PORT MAP ( X(1), Y(1), C(1), S(1), C(2));
	add2: full_adder PORT MAP ( X(2), Y(2), C(2), S(2), C(3));
	add3: full_adder PORT MAP ( X(3), Y(3), C(3), S(3), Cout);
	
END Structure;


		


			