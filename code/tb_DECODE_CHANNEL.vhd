library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_DECODE_CHANNEL is
end tb_DECODE_CHANNEL;


architecture Behavior of tb_DECODE_CHANNEL is

	component DECODE_CHANNEL is
		Generic(
			p_ch_R1	: INTEGER := 16;
			p_ch_R2	: INTEGER := 32;
			p_ch_R3	: INTEGER := 48;
			p_ch_R4	: INTEGER := 64
		);
		Port(
			i_CLK		: in STD_LOGIC;
			i_RST		: in STD_LOGIC;
			i_FS		: in STD_LOGIC;
			o_WR_R1	: out STD_LOGIC;
			o_WR_R2	: out STD_LOGIC;
			o_WR_R3	: out STD_LOGIC;
			o_WR_R4	: out STD_LOGIC
		);
	end component;

	signal w_CLK	: STD_LOGIC;	
	signal w_RST	: STD_LOGIC;
	signal w_FS		: STD_LOGIC;
	signal w_WR_R1 : STD_LOGIC;
	signal w_WR_R2 : STD_LOGIC;
	signal w_WR_R3 : STD_LOGIC;
	signal w_WR_R4 : STD_LOGIC;
	
begin
	
	
	DC:	DECODE_CHANNEL
	Generic Map(
		p_ch_R1	=> 16,
	   p_ch_R2	=> 32,
	   p_ch_R3	=> 48,
	   p_ch_R4	=> 64
	)
	Port Map(
		i_CLK		=> w_CLK,
		i_RST		=> w_RST,
		i_FS		=> w_FS,
		o_WR_R1	=> w_WR_R1,
		o_WR_R2	=> w_WR_R2,
		o_WR_R3	=> w_WR_R3,
		o_WR_R4	=> w_WR_R4
	);
	
	process
	begin
		w_CLK	<= '0';
		wait for 250 ns;
		w_CLK	<= '1';
		wait for 250 ns;
	end process;
	
	process
	begin
		w_FS	<= '1';
		wait for 500 ns;
		w_FS	<= '0';
		wait for 32000 ns;
	end process;
	
	process
	begin
		wait for 500 ns;
		w_RST		<= '0';
		wait for 100 ns;
		w_RST		<= '1';
		wait for 100 ns;
		wait;
	end process;

end Behavior;