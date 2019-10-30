LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.compar_package.all;
USE work.circ_A_package.all;
use work.mux_package.all;
use work.ssd_package.all;
use work.circ_B_package.all;

ENTITY part2 IS
	PORT(v: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  h1, h0: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
end part2;

Architecture Behaviour of part2 IS
	SIGNAL a: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL z: STD_LOGIC;
	SIGNAL m: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	compar_unit: compar PORT MAP (v(3 DOWNTO 0), z);	
	circ_A_unit: circ_A PORT MAP(v(2 DOWNTO 0), a(2 DOWNTO 0));
	mux_3: mux PORT MAP(z, v(3), '0', m(3));
	mux_2: mux PORT MAP(z, v(2), a(2), m(2));
	mux_1: mux PORT MAP(z, v(1), a(1), m(1));
	mux_0: mux PORT MAP(z, v(0), a(0), m(0));
	circ_B_unit: circ_B PORT MAP(z, h1(6 DOWNTO 0));
	ssd_unit: sev_seg_dec PORT MAP(m(3 DOWNTO 0), h0(6 DOWNTO 0));
	
END Behaviour;