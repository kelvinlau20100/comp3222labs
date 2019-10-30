LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

-----the overall system is implemented here
entity part5 is
	port( SW				: in std_logic_vector(7 downto 0);
			clk, resetn : in std_logic;
			HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0)
		 );
end part5;

architecture behaviour of part5 is
	component circ_A
		port( SW			 		 : in std_logic_vector(7 downto 0);
				clk, resetn		 : in std_logic;
				disp1 			 : out std_logic_vector(7 downto 0);
				reg8		 		 : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component to_7seg
		Port ( A		: in  STD_LOGIC_VECTOR (3 downto 0);
				 seg7 : out  STD_LOGIC_VECTOR (6 downto 0)
           );
	end component;
	
	signal first_hex 						 : std_logic_vector(7 downto 0);
	signal reg8		  						 : std_logic_vector(7 downto 0);
	signal disp3, disp2, disp1, disp0 : std_logic_vector(3 downto 0);
begin
	circA_unit: circ_A port map (SW(7 downto 0), clk, resetn, first_hex, reg8);
	disp3 <= reg8(7 downto 4);
	disp2 <= reg8(3 downto 0);
	disp1 <= first_hex(7 downto 4);
	disp0 <= first_hex(3 downto 0);
	to_7seg_0: to_7seg port map (disp0, HEX0);
	to_7seg_1: to_7seg port map (disp1, HEX1);
	to_7seg_2: to_7seg port map (disp2, HEX2);
	to_7seg_3: to_7seg port map (disp3, HEX3);
end behaviour;	
	


----------------------------------------------------------------------------

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

--Essentially disp1 is the 8 bit number we want to display on HEX1 and HEX0
--reg8 is the 8 bit number we want to display on HEX3 and HEX2 in addition here I have made the asynchronous reset active high

entity circ_A is
	port( SW			 		 : in std_logic_vector(7 downto 0);
			clk, resetn		 : in std_logic;
			disp1 			 : out std_logic_vector(7 downto 0);
			reg8		 		 : out std_logic_vector(7 downto 0)
			);			
end circ_A;

architecture behaviour of circ_A is
begin
	disp1 <= SW(7 downto 0);
	process (clk, resetn)
	begin
		if resetn = '1' then
			reg8 <= "00000000";
 	   elsif clk'event AND clk = '1' then
			reg8 <= SW(7 downto 0);
		end if;
	end process;
end behaviour;

-------------------------------------------------
-- 8 bit BCD converter *this is not necessary i just mis interpreted the question

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

--disp1 -> the higher decimal place disp0 -> lower decimal place
--A -> the 8 bit input, maximum input is 99
entity bcd_conv is
	port(A		: in	std_logic_vector(7 downto 0);
		  disp1	: out std_logic_vector(3 downto 0);
		  disp0	: out std_logic_vector(3 downto 0)
		 );
end bcd_conv; 

architecture behaviour of bcd_conv is
	signal temp : std_logic_vector(7 downto 0);
begin
	process(A, temp)
	begin
		if A >= "1011010" then --check if A >= 90
			temp <= A - "1011010";
			disp0 <= temp(3 downto 0);
			disp1 <= "1001";
		elsif A >= "1010000" then --check if A >= 80
			temp <= A - "1010000";
			disp0 <= temp(3 downto 0);
			disp1 <= "1000";
		elsif A >= "1000110" then --check if A >= 70
			temp <= A - "1010110";
			disp0 <= temp(3 downto 0);
			disp1 <= "0111";
		elsif A >= "111100" then --check if A >= 60
			temp <= A - "111100";
			disp0 <= temp(3 downto 0);
			disp1 <= "0110";
		elsif A >= "110010" then --check if A >= 50
			temp <= A - "110010";
			disp0 <= temp(3 downto 0);
			disp1 <= "0101";
		elsif A >= "101000" then --check if A >= 40
			temp <= A - "101000";
			disp0 <= temp(3 downto 0);
			disp1 <= "0100";
		elsif A >= "11110" then --check if A >= 30
			temp <= A - "11110";
			disp0 <= temp(3 downto 0);
			disp1 <= "0011";
		elsif A >= "10100" then --check if A >= 20
			temp <= A - "10100";
			disp0 <= temp(3 downto 0);
			disp1 <= "0010";
		elsif A >= "1010" then --check if A >= 10
			temp <= A - "1010";
			disp0 <= temp(3 downto 0);
			disp1 <= "0001";
		else
			disp0 <= A(3 downto 0);
			disp1 <= "0000";
		end if;
	end process;
end behaviour;


---------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity to_7seg is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (6 downto 0)
             );
end to_7seg;

architecture Behavioral of to_7seg is

begin

--'a' corresponds to MSB of seg7 and 'g' corresponds to LSB of seg7.
process (A)
BEGIN
    case A is
        when "0000"=> seg7 <="0000001";  -- '0'
        when "0001"=> seg7 <="1001111";  -- '1'
        when "0010"=> seg7 <="0010010";  -- '2'
        when "0011"=> seg7 <="0000110";  -- '3'
        when "0100"=> seg7 <="1001100";  -- '4' 
        when "0101"=> seg7 <="0100100";  -- '5'
        when "0110"=> seg7 <="0100000";  -- '6'
        when "0111"=> seg7 <="0001111";  -- '7'
        when "1000"=> seg7 <="0000000";  -- '8'
        when "1001"=> seg7 <="0000100";  -- '9'
        when "1010"=> seg7 <="0001000";  -- 'A'
        when "1011"=> seg7 <="1100000";  -- 'b'
        when "1100"=> seg7 <="0110001";  -- 'C'
        when "1101"=> seg7 <="1000010";  -- 'd'
        when "1110"=> seg7 <="0110000";  -- 'E'
        when "1111"=> seg7 <="0111000";  -- 'F'
        when others =>  NULL;
    end case;
end process;

end Behavioral;