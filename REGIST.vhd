library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity REGIST is
	Generic(
		p_w_SIZE	: INTEGER := 16
	);
	Port(
		i_CLK		: in STD_LOGIC;
		i_RST		: in STD_LOGIC;
		i_WR		: in STD_LOGIC;
		i_DATA	: in STD_LOGIC_VECTOR((p_w_SIZE - 1) DOWNTO 0);
		o_DATA	: out STD_LOGIC_VECTOR((p_w_SIZE - 1) DOWNTO 0)
	);
end REGIST;

architecture reg of REGIST is

begin

	process(i_CLK, i_RST)
	begin
		if(i_RST = '0') then
			o_DATA		<= (others => '0');
		elsif rising_edge(i_CLK) then
			if(i_WR = '0') then
				o_DATA	<= i_DATA;
			end if;
		end if;
	end process;

end reg;