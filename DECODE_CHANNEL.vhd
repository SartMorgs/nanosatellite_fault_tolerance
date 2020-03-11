library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODE_CHANNEL is
	Generic(
		-- CHANNELS LIMITS
		p_ch_R1	: INTEGER := 16;
		p_ch_R2	: INTEGER := 32;
		p_ch_R3	: INTEGER := 48;
		p_ch_R4	: INTEGER := 64;
		
		-- SIZES
		p_w_SIZE		: integer := 16;
		p_r_COUNT	: integer := 4
	);
	Port(		
		-- NETWORK INPUTS
		i_FS		: in STD_LOGIC;
		i_CLK		: in STD_LOGIC;
		i_RST		: in STD_LOGIC;
		
		-- ROUTER'S WRITE ENABLE
		o_WR_R1	: out STD_LOGIC;
		o_WR_R2	: out STD_LOGIC;
		o_WR_R3	: out STD_LOGIC;
		o_WR_R4	: out STD_LOGIC
	);
end DECODE_CHANNEL;

architecture dc of DECODE_CHANNEL is
	-- COUNT CLOCK PULSE
	signal count	: INTEGER range 0 to p_ch_R4;
		
begin

-------------------------------- WRITE ENABLE TDM CHANNELS ------------------------------------
	o_WR_R1											<= '1' when (count >= 0 and count < p_ch_R1 and i_RST = '1') else '0';
	o_WR_R2											<= '1' when (count >= p_ch_R1 and count < p_ch_R2) else '0';
	o_WR_R3											<= '1' when (count >= p_ch_R2 and count < p_ch_R3) else '0';
	o_WR_R4											<= '1' when (count >= p_ch_R3 and count < p_ch_R4) else '0';

	
	TDM_CICLE_COUNT: Process(i_CLK, i_RST, i_FS)
	begin
		if(i_RST = '0') then
			count 	<= 0;
		elsif rising_edge(i_CLK) then
			if(i_FS = '0') then
				count <= count + 1;
				if (count = p_ch_R4) then
					count <= 0;
				end if;
			else
				count	<= 0;
			end if;
		end if;
	end process TDM_CICLE_COUNT;
	
end dc;