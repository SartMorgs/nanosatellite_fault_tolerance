library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_NETWORK is
	Generic(
		p_w_SIZE	: INTEGER := 16
	);
end tb_NETWORK;

architecture Behavior of tb_NETWORK is

-------------------------- SIGNAL ----------------------
	signal w_CLK		: STD_LOGIC;
	signal w_RST		: STD_LOGIC;
	-- WRITE ENABLE PROCESSADORES->ROTEADORES
	signal w_i_WR_PC1	: STD_LOGIC;
	signal w_i_WR_PC2	: STD_LOGIC;
	signal w_i_WR_PC3	: STD_LOGIC;
	signal w_i_WR_PC4	: STD_LOGIC;
	-- WRITE ENABLE ROTEADORES->PROCESSADORES
	signal w_o_WR_PC1	: STD_LOGIC;
	signal w_o_WR_PC2	: STD_LOGIC;
	signal w_o_WR_PC3	: STD_LOGIC;
	signal w_o_WR_PC4	: STD_LOGIC;
	-- ENTRADA DOS PROCESSADORES
	signal w_i_PC1		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_i_PC2		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_i_PC3		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_i_PC4		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	-- SAÍDAS DOS PROCESSADORES
	signal w_o_PC1		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_o_PC2		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_o_PC3		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_o_PC4		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	
	component NETWORK is
		Generic(
			p_w_SIZE	: INTEGER := 16
		);
		Port(
			i_CLK		: in STD_LOGIC;
			i_RST		: in STD_LOGIC;
			-- WRITE ENABLE PROCESSADORES->ROTEADORES
			i_WR_PC1	: in STD_LOGIC;
			i_WR_PC2	: in STD_LOGIC;
			i_WR_PC3	: in STD_LOGIC;
			i_WR_PC4	: in STD_LOGIC;
			-- WRITE ENABLE ROTEADORES->PROCESSADORES
			o_WR_PC1	: out STD_LOGIC;
			o_WR_PC2	: out STD_LOGIC;
			o_WR_PC3	: out STD_LOGIC;
			o_WR_PC4	: out STD_LOGIC;
			-- ENTRADA DOS PROCESSADORES
			i_PC1		: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			i_PC2		: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			i_PC3		: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			i_PC4		: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			-- SAÍDAS DOS PROCESSADORES
			o_PC1		: out STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			o_PC2		: out STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			o_PC3		: out STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			o_PC4		: out STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0)
		);
	end component;

begin

	NET: NETWORK
	Generic Map(
		p_w_SIZE	=> 16
	)
	Port Map(
		i_CLK		=> w_CLK,
		i_RST		=> w_RST,
		i_WR_PC1	=> w_i_WR_PC1,
		i_WR_PC2	=> w_i_WR_PC2,
		i_WR_PC3	=> w_i_WR_PC3,
		i_WR_PC4	=> w_i_WR_PC4,
		o_WR_PC1	=> w_o_WR_PC1,
		o_WR_PC2	=> w_o_WR_PC2,
		o_WR_PC3	=> w_o_WR_PC3,
		o_WR_PC4	=> w_o_WR_PC4,
		i_PC1		=> w_i_PC1,
		i_PC2		=> w_i_PC2,
		i_PC3		=> w_i_PC3,
		i_PC4		=> w_i_PC4,
		o_PC1		=> w_o_PC1,
		o_PC2		=> w_o_PC2,
		o_PC3		=> w_o_PC3,
		o_PC4		=> w_o_PC4
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
		w_RST	<= '0';
		wait for 1000 ns;
		w_RST	<= '1';
		wait;
	end process;
	
	
	PC1:	Process
	begin
		wait for 1000 ns;
		w_i_WR_PC1	<= '1';
		w_i_PC1		<= x"0001";
		wait for 1000 ns;
		w_i_WR_PC1	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC1	<= '1';
		w_i_PC1		<= x"FF40";
		wait for 1000 ns;
		w_i_WR_PC1	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC1	<= '1';
		w_i_PC1		<= x"A511";
		wait for 1000 ns;
		w_i_WR_PC1	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC1	<= '1';
		w_i_PC1		<= w_i_PC1 + 5;
		wait for 1000 ns;
		w_i_WR_PC1	<= '0';
		wait for 1000 ns;
		
		wait;
	end process;
	
	PC2:	Process
	begin
		--wait for 17000 ns;
		wait for 1000 ns;
		w_i_WR_PC2	<= '1';
		w_i_PC2		<= x"0001";
		wait for 1000 ns;
		w_i_WR_PC2	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC2	<= '1';
		w_i_PC2		<= x"FF80";
		wait for 1000 ns;
		w_i_WR_PC2	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC2	<= '1';
		w_i_PC2		<= x"9210";
		wait for 1000 ns;
		w_i_WR_PC2	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC2	<= '1';
		w_i_PC2		<= w_i_PC1 + 5;
		wait for 1000 ns;
		w_i_WR_PC2	<= '0';
		wait for 1000 ns;
		
		wait;
	end process;
	
	PC3:	Process
	begin
		--wait for 33000 ns;
		wait for 1000 ns;
		w_i_WR_PC3	<= '1';
		w_i_PC3		<= x"0001";
		wait for 1000 ns;
		w_i_WR_PC3	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC3	<= '1';
		w_i_PC3		<= x"8321";
		wait for 1000 ns;
		w_i_WR_PC3	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC3	<= '1';
		w_i_PC3		<= w_i_PC1 + 5;
		wait for 1000 ns;
		w_i_WR_PC3	<= '0';
		wait for 1000 ns;
		
		
		w_i_WR_PC3	<= '1';
		w_i_PC3		<= x"FFB0";
		wait for 1000 ns;
		w_i_WR_PC3	<= '0';
		wait for 1000 ns;
		
		wait;
	end process;
	
	PC4:	Process
	begin
		--wait for 49000 ns;
		wait for 1000 ns;
		w_i_WR_PC4	<= '1';
		w_i_PC4		<= x"0001";
		wait for 1000 ns;
		w_i_WR_PC4	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC4	<= '1';
		w_i_PC4		<= x"6503";
		wait for 1000 ns;
		w_i_WR_PC4	<= '0';
		wait for 1000 ns;
		
		w_i_WR_PC4	<= '1';
		w_i_PC4		<= w_i_PC1 + 5;
		wait for 1000 ns;
		w_i_WR_PC4	<= '0';
		wait for 1000 ns;
		
		
		w_i_WR_PC4	<= '1';
		w_i_PC4		<= x"FF00";
		wait for 1000 ns;
		w_i_WR_PC4	<= '0';
		wait for 1000 ns;
		
		wait;
	end process;
	
end Behavior;