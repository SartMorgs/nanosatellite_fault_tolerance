library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity S2P is
	Generic(
		p_w_SIZE	: integer := 16
	);
	Port(
		i_DATA	: in STD_LOGIC;
		i_CLK		: in STD_LOGIC;
		i_EN		: in STD_LOGIC;
		o_DATA	: OUT STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0)
	);
end S2P;

architecture sp of S2P is

	signal w_REG	: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);

begin

	o_DATA <= w_REG;
	
	process(i_CLK)
	begin
		if falling_edge(i_CLK) then
			if(i_EN = '1') then
				w_REG	<= w_REG((p_w_SIZE-2) DOWNTO 0) & i_DATA;
			end if;
		end if;
	end process;

end sp;