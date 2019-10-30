LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Comparator HDL Description
ENTITY compar IS
	PORT(V: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  z: OUT STD_LOGIC);
END compar;

ARCHITECTURE LogicFunc of compar IS
BEGIN
	z <= V(3) AND (V(2) OR V(1));
END LogicFunc;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE compar_package IS
	COMPONENT compar
		PORT(V: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		     z: OUT STD_LOGIC);
	END COMPONENT;
END compar_package;

---------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Circuit A HDL Description
ENTITY circ_A IS 
	PORT(V: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		  A: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END circ_A;

ARCHITECTURE LogicFunc of circ_A IS
BEGIN
	A(2) <= V(2) AND V(1);
	A(1) <= NOT V(1);
	A(0) <= V(0);
END LogicFunc;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE circ_A_package IS
	COMPONENT circ_A
		PORT(V: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		     A: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;
END circ_A_package;

--------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 2-to-1 Multiplexer
ENTITY mux IS
	PORT(s: IN STD_LOGIC;
		  X, Y: IN STD_LOGIC;
		  m: OUT STD_LOGIC);
END mux;

ARCHITECTURE LogicFunc of mux IS
BEGIN 
	m <= (NOT (s) AND X) OR (s AND Y);
END LogicFunc;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE mux_package IS
	COMPONENT mux
		PORT(s: IN STD_LOGIC;
			  X, Y: IN STD_LOGIC;
		     m: OUT STD_LOGIC);
	END COMPONENT;
END mux_package;

--------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Circuit B ouputs '0' when z = 0 and '1' when z = 1

ENTITY circ_B IS
	PORT(z: IN STD_LOGIC;
			B: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END circ_B;

ARCHITECTURE LogicFunc of circ_B IS
BEGIN
	B(0) <= z;
	B(1) <= '0';
	B(2) <= '0';
	B(3) <= z;
	B(4) <= z;
	B(5) <= z;
	B(6) <= '1';
END LogicFunc;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE circ_B_package IS
	COMPONENT circ_B
		PORT(z: IN STD_LOGIC;
				B: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;
END circ_B_package;

	
