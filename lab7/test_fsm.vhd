LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity test_fsm is
	port(clk, w, halfsect, len, dat, nReset	: in std_logic;
		  z, tstart, shft  							: out std_logic
		 );
end test_fsm;

architecture behaviour of test_fsm is
	TYPE State_type is(init, dot, pause, dash1, dash2, dash3, dot_treset, dash1_treset, dash2_treset, dash3_treset, pausedot_treset, pausedash_treset);
	signal y_Q, y_D : State_type; -- y_q is current state, y_D is next state

--before going onto the next state, we must reset our 0.5 second timer	
begin
	process(w, halfsect, len, dat, y_Q)
	begin
		case y_Q is
			when init =>
				if w = '0' then
					y_D <= init;
				else
					if (len = '1' and dat = '0') then
						y_D <= dot;
					elsif (len = '1' and dat = '1') then
						y_D <= dash1;
					else
						y_D <= init;
					end if;
				end if;
			
			when dot =>
				if w = '0' then
					y_D <= init;
				else
					if halfsect = '0' then
						y_D <= dot;
					else 
						y_D <= dot_treset;
					end if;
				end if;
			
			when dot_treset =>
				y_D <= pause;
			
			when pause => 
				if w = '0' then
					y_D <= init;
				else
					if halfsect = '0' then
						y_D <= pause;
					elsif (len = '1' and dat = '0') then
						y_D <= pausedot_treset;
					elsif (len = '1' and dat = '1') then
						y_D <= pausedash_treset;
					else
						y_D <= init;
					end if;
				end if;
			
			when pausedash_treset =>
				y_D <= dash1;
			
			when pausedot_treset =>
				y_D <= dot;
				
			when dash1 => 
				if w = '0' then
					y_D <= init;
				else
					if halfsect = '0' then
						y_D <= dash1;
					else
						y_D <= dash1_treset;
					end if;
				end if;
			
			when dash1_treset =>
				y_D <= dash2;
				
			when dash2 => 
				if w = '0' then
					y_D <= init;
				else
					if halfsect = '0' then
						y_D <= dash2;
					else
						y_D <= dash2_treset;
					end if;
				end if;
			
			when dash2_treset =>
				y_D <= dash3;
				
			when dash3 => 
				if w = '0' then
					y_D <= init;
				else
					if halfsect = '0' then
						y_D <= dash3_treset;
					else
						y_D <= pause;
					end if;
				end if;
			
			when dash3_treset =>
				y_D <= pause;
			
		end case;
	end process;
	
	
	process(clk, nReset)
	begin
		if (nReset = '1') THEN
					y_Q <= Init;
		elsif (clk'event and clk = '1') then
			y_Q <= y_D;
		end if;
	end process;
	
	
	process(y_Q)
	begin
		case y_Q is
			when init =>
				z <= '0';
				shft <= '1';
				tstart <= '1';
				
			when dot =>
				z <= '1';
				shft <= '0';
				tstart <= '0';
			
			when dot_treset =>
				tstart <= '1';
				shft <= '1';
				z <= '0';
			when pause =>
				z <= '0';
				shft <= '0';
				tstart <= '0';
			
			when pausedot_treset =>
				z <= '0';
				shft <= '0';
				tstart <= '1';
			
			when pausedash_treset =>
				z <= '0';
				shft <= '0';
				tstart <= '1';
				
			when dash1 =>
				z <= '1';
				shft <= '0';
				tstart <= '0';
			
			when dash1_treset =>
				z <= '1';
				shft <= '0';
				tstart <= '1';
				
			when dash2 =>
				z <= '1';
				shft <= '0';
				tstart <= '0';
			
			when dash2_treset =>
				z <= '1';
				shft <= '0';
				tstart <= '1';
				
			when dash3 =>
				z <= '1';
				shft <= '0';
				tstart <= '0';		
			
			when dash3_treset =>
				z <= '0';
				tstart <= '1';
				shft <= '1';
				
		end case;
	end process;

end behaviour;
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					