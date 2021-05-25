library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ROUTER is
end tb_ROUTER;

architecture Behavior of tb_ROUTER is

	signal w_DATA		: STD_LOGIC;
	signal w_DATA_IN	: STD_LOGIC;							-- ROUTER DATA IN (NETWORK)
	signal w_DATA_OUT	: STD_LOGIC;							-- ROUTER DATA OUT (NETWORK)
	signal w_i_DATA	: STD_LOGIC_VECTOR(15 DOWNTO 0);	-- ROUTER DATA IN (PC)
	signal w_i_WR_P	: STD_LOGIC;							-- WRITE ENABLE IN (PC)
	signal w_CLK		: STD_LOGIC;
	signal w_RST		: STD_LOGIC;
	signal w_FS			: STD_LOGIC;
	signal w_WR			: STD_LOGIC;
	signal w_o_WR_P	: STD_LOGIC;							-- WRITE ENABLE OUT (PC)
	signal w_o_DATA	: STD_LOGIC_VECTOR(15 DOWNTO 0);	-- ROUTER FATA OUT (PC)

	component ROUTER is
		Generic(
			p_type	: integer := 0;		-- NUMBER OF THE ROUTER (0 TO 3)
			p_w_SIZE : integer := 16;		-- WORD SIZE
			p_b_SIZE	: integer := 10		-- ROUTER OUT SIZE
		);
		Port(
			-- ROUTER'S BUS
			DATA		: inout STD_LOGIC;
			
			-- PC'S PORT
			i_DATA	: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			o_DATA	: out STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			i_WR_P	: in STD_LOGIC;	
			o_WR_P	: out STD_LOGIC;
			
			-- NETWORK'S PORT
			i_CLK		: in STD_LOGIC;
			i_RST		: in STD_LOGIC;
			i_FS		: in STD_LOGIC;
			i_WR		: in STD_LOGIC
		);
	end component;

begin

	R	: ROUTER
	Generic Map(
		p_type	=> 0,			-- NUMBER OF THE ROUTER (0 TO 3)
		p_w_SIZE => 16,		-- WORD SIZE
		p_b_SIZE	=> 10		-- ROUTER OUT SIZE
	)
	Port Map(
		DATA		=>	w_DATA,
		i_DATA	=> w_i_DATA,
		o_DATA	=> w_o_DATA,
		i_WR_P	=> w_i_WR_P,
		o_WR_P	=> w_o_WR_P,
		i_CLK		=> w_CLK,
		i_RST		=> w_RST,
		i_FS		=> w_FS,
		i_WR		=> w_WR
	);

	process
	begin
		w_FS	<= '1';
		wait for 250 ns;
		w_FS	<= '0';
		wait for 32000 ns;
	end process;
	
	
	process
	begin
		w_CLK	<= '0';
		wait for 250 ns;
		w_CLK	<= '1';
		wait for 250 ns;
	end process;
	
	
	process
	begin
		w_WR		<= '0';
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '0';
		wait for 500 ns;
		w_DATA	<= '0';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '0';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA	<= '0';
		wait for 500 ns;
		w_DATA	<= '0';
		wait for 500 ns;
		w_DATA	<= '1';
		wait for 500 ns;
		w_DATA 	<= '0';
		wait for 16000 NS;
		w_WR			<= '1';
		wait for 8000 ns;
	end process;
	
	process
	begin
		wait for 500 ns;
		w_RST	<= '0';
		wait for 500 ns;
		w_RST	<= '1';
		wait for 500 ns;
	
		wait for 500 ns;

		w_i_WR_P	<= '1';
		w_i_DATA	<= x"0123";
		wait for 500 ns;
		w_i_WR_P	<= '0';
		wait for 100 ns;
		
		w_i_WR_P	<= '1';
		w_i_DATA	<= x"3210";
		wait for 500 ns;
		w_i_WR_P	<= '0';
		wait for 100 ns;
		
		w_i_WR_P	<= '1';
		w_i_DATA	<= x"4567";
		wait for 500 ns;
		w_i_WR_P	<= '0';
		wait for 100 ns;
		
		w_i_WR_P	<= '1';
		w_i_DATA	<= x"7654";
		wait for 500 ns;
		w_i_WR_P	<= '0';
		wait for 100 ns;
		
		wait;
	end process;
	
--	process(w_WR, w_DATA_IN, w_DATA_OUT)
--	begin
--		if(w_WR = '1') then
--			w_DATA	<= w_DATA_OUT;
--		elsif(w_WR = '0') then
--			w_DATA	<= w_DATA_IN;
--		end if;
--	end process;

end Behavior;