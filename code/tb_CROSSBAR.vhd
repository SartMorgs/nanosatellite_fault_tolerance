library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_CROSSBAR is
end tb_CROSSBAR;

architecture Behavioral of tb_CROSSBAR is
	
	signal w_R1			: STD_LOGIC;
	signal w_R2			: STD_LOGIC;
	signal w_R3			: STD_LOGIC;
	signal w_R4			: STD_LOGIC;
	signal w_i_R1		: STD_LOGIC;
	signal w_o_R1		: STD_LOGIC;
	signal w_i_R2		: STD_LOGIC;
	signal w_o_R2		: STD_LOGIC;
	signal w_i_R3		: STD_LOGIC;
	signal w_o_R3		: STD_LOGIC;
	signal w_i_R4		: STD_LOGIC;
	signal w_o_R4		: STD_LOGIC;
	signal w_FS			: STD_LOGIC;
	signal w_CLK		: STD_LOGIC;
	signal w_RST		: STD_LOGIC;
	signal w_WR_R1		: STD_LOGIC;
	signal w_WR_R2		: STD_LOGIC;
	signal w_WR_R3		: STD_LOGIC;
	signal w_WR_R4		: STD_LOGIC;

	component CROSSBAR is
		Generic(
			p_w_SIZE		: integer := 16;
			p_r_COUNT	: integer := 4
		);
		Port(
			io_R1		: inout STD_LOGIC;
			io_R2		: inout STD_LOGIC;
			io_R3		: inout STD_LOGIC;
			io_R4		: inout STD_LOGIC;
			i_FS		: in STD_LOGIC;
			i_CLK		: in STD_LOGIC;
			i_RST		: in STD_LOGIC;
			i_WR_R1	: in STD_LOGIC;
			i_WR_R2	: in STD_LOGIC;
			i_WR_R3	: in STD_LOGIC;
			i_WR_R4	: in STD_LOGIC
		);
	end component;

begin

	CRS: CROSSBAR
	Generic Map(
		p_w_SIZE		=> 16,
		p_r_COUNT	=>	4
	)
	Port Map(
		io_R1		=> w_R1,
		io_R2		=> w_R2,
		io_R3		=> w_R3,
		io_R4		=> w_R4,
		i_FS		=> w_FS,
		i_CLK		=> w_CLK,
		i_RST		=> w_RST,
		i_WR_R1	=> w_WR_R1,
		i_WR_R2	=> w_WR_R2,
		i_WR_R3	=> w_WR_R3,
		i_WR_R4	=>	w_WR_R4
	);
	
	CLK: Process
	begin
		w_CLK	<= '1';
		wait for 20 ns;
		w_CLK	<= '0';
		wait for 20 ns;
	end process;
	
	RST: Process
	begin
		wait for 50 ns;
		w_RST	<= '0';
		wait for 100 ns;
		w_RST	<= '1';
		wait;
	end process;
	
	WR: Process
	begin
		w_WR_R1	<= '1';
		w_WR_R2	<= '0';
		w_WR_R3	<= '0';
		w_WR_R4	<= '0';
		wait for 640 ns;
		
		w_WR_R1	<= '0';
		w_WR_R2	<= '1';
		w_WR_R3	<= '0';
		w_WR_R4	<= '0';
		wait for 640 ns;
		
		w_WR_R1	<= '0';
		w_WR_R2	<= '0';
		w_WR_R3	<= '1';
		w_WR_R4	<= '0';
		wait for 640 ns;
		
		w_WR_R1	<= '0';
		w_WR_R2	<= '0';
		w_WR_R3	<= '0';
		w_WR_R4	<= '1';
		wait for 640 ns;
	end process;
	
	DATA: Process
	begin
	--------------------------------- R1 TRANSMITINDO -----------------------------------
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;		
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		
--------------------------------- R2 TRANSMITINDO -----------------------------------
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;		
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		
--------------------------------- R3 TRANSMITINDO -----------------------------------
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;		
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '1';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		w_R1	<= '0';
		wait for 20 ns;
		
--------------------------------- R3 TRANSMITINDO -----------------------------------
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;		
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '1';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
		w_R2	<= '0';
		wait for 20 ns;
	end process;
	
--	DATA: Process
--	begin
--		
--		w_i_R1	<= '0';
--		w_i_R2	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		
--		
--		-- R2 ESCREVENDO
--		wait for 640 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '1';
--		w_i_R3	<= '1';
--		w_i_R4	<= '1';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		w_i_R1	<= '0';
--		w_i_R3	<= '0';
--		w_i_R4	<= '0';
--		wait for 40 ns;
--		
--		
--		wait;
--	end process;
	
--	Process(w_CLK)
--	begin
--		if(w_WR_R1 = '1') then
--			w_R1	<= w_o_R1;
--		elsif(w_WR_R1 = '0') then
--			w_R1	<= w_i_R1;
--		end if;
--	
--		if(w_WR_R2 = '1') then
--			w_R2	<= w_o_R2;
--		elsif(w_WR_R2 = '0') then
--			w_R2	<= w_i_R2;
--		end if;
--		
--		if(w_WR_R3 = '1') then
--			w_R3	<= w_o_R3;
--		elsif(w_WR_R3 = '0') then
--			w_R3	<= w_i_R3;
--		end if;
--	
--		if(w_WR_R4 = '1') then
--			w_R4	<= w_o_R4;
--		elsif(w_WR_R4 = '0') then
--			w_R4	<= w_i_R4;
--		end if;
--	end process;

end Behavioral;