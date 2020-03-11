library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FRAME_SYNC is
end tb_FRAME_SYNC;

architecture Behavior of tb_FRAME_SYNC is

	component FRAME_SYNC is
		Generic(
			p_w_SIZE		: integer := 16;
			p_r_COUNT	: integer := 4
		);
		Port(
			i_CLK			: in STD_lOGIC;
			i_RST			: in STD_LOGIC;
			o_FS			: out STD_LOGIC
		);
	end component;
	
	signal w_CLK	: STD_LOGIC;
	signal w_RST	: STD_LOGIC;
	signal w_FS		: STD_LOGIC;
	
begin
	
	FS	: FRAME_SYNC
	Generic Map(
		p_w_SIZE		=> 16,	
		p_r_COUNT	=> 4
	)
	Port Map(
		i_CLK			=> w_CLK,
		i_RST			=> w_RST,
		o_FS			=> w_FS
	);
	
	
	process
	begin
		w_CLK	<= '1';
		wait for 250 ns;
		w_CLK	<= '0';
		wait for 250 ns;
	end process;
	
	process
	begin
		wait for 500 ns;
		w_RST	<= '0';
		wait for 100 ns;
		w_RST	<= '1';
		wait for 100 ns;
		wait;
	end process;

end Behavior;