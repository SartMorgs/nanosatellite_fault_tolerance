library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity NETWORK is
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
end NETWORK;

architecture nt of NETWORK is

	signal w_DATA		: STD_LOGIC;

--------------------------------- CHANNEL ROUTERS --------------------------------------------
	--signal w_R1			: STD_LOGIC;
	--signal w_R2			: STD_LOGIC;
	--signal w_R3			: STD_LOGIC;
	--signal w_R4			: STD_LOGIC;

--------------------------------- WRITE-ENABLE ROUTERS --------------------------------------------
	signal w_WR_R1		: STD_LOGIC;
	signal w_WR_R2		: STD_LOGIC;
	signal w_WR_R3		: STD_LOGIC;
	signal w_WR_R4		: STD_LOGIC;

-------------------------------------- AUXILIARS -------------------------------------------------
	signal w_FS			: STD_LOGIC;
	signal w_CLK		: STD_LOGIC;
	
-------------------------------------- PLL COMPONENT -------------------------------------------
	component PLL is
		PORT
		(
			areset		: in STD_LOGIC  := '0';
			inclk0		: in STD_LOGIC  := '0';
			c1				: out STD_LOGIC ;
			locked		: out STD_LOGIC 
		);
	end component;
	
-------------------------------- FRAME-SYNC COMPONENT -------------------------------------------	
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
	

-------------------------------- DECODE-CHANNEL COMPONENT -------------------------------------------
	component DECODE_CHANNEL is
		Generic(
			p_ch_R1		: INTEGER := 16;
			p_ch_R2		: INTEGER := 32;
			p_ch_R3		: INTEGER := 48;
			p_ch_R4		: INTEGER := 64;
			p_w_SIZE		: integer := 16;
			p_r_COUNT	: integer := 4
		);
		Port(
			i_FS		: in STD_LOGIC;
			i_CLK		: in STD_LOGIC;
			i_RST		: in STD_LOGIC;
			o_WR_R1	: out STD_LOGIC;
			o_WR_R2	: out STD_LOGIC;
			o_WR_R3	: out STD_LOGIC;
			o_WR_R4	: out STD_LOGIC
		);
	end component;

-------------------------------------- ROUTER COMPONENT -----------------------------------------
	component ROUTER is
		Generic(
			p_type	: integer := 0;
			p_w_SIZE : integer := 16;
			p_b_SIZE	: integer := 10
		);
		Port(
			DATA		: inout STD_LOGIC;
			i_DATA	: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			o_DATA	: out STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			i_WR_P	: in STD_LOGIC;	
			o_WR_P	: out STD_LOGIC;
			i_CLK		: in STD_LOGIC;
			i_RST		: in STD_LOGIC;
			i_FS		: in STD_LOGIC;
			i_WR		: in STD_LOGIC
		);
	end component;

begin
	
	--w_DATA	<= w_i_R1 when w_WR_R1 = '1' else 
	--				w_i_R2 when w_WR_R2 = '1' else
	--				w_i_R3 when w_WR_R3 = '1' else
	--				w_i_R4 when w_WR_R4 = '1';
	
------------------------ PLL ------------------------
	c_PLL: PLL
	Port Map(
		areset	=> OPEN,
		inclk0	=>	i_CLK,
		c1			=> w_CLK,
		locked	=> OPEN
	);
	
------------------------ FRAME-SYNC ------------------------
	FS	: FRAME_SYNC
	Generic Map(
		p_w_SIZE		=> p_w_SIZE,
	   p_r_COUNT	=> 4
	)
	Port Map(
		i_CLK		=> w_CLK,
		i_RST		=> i_RST,
		o_FS		=> w_FS
	);
	
	
------------------------ DECODE-CHANNEL ------------------------
	DC	: DECODE_CHANNEL
	Generic Map(
		p_ch_R1		=> 17,
		p_ch_R2		=> 34,
		p_ch_R3		=> 51,
		p_ch_R4		=> 68,
		p_w_SIZE		=> 16,
		p_r_COUNT	=> 4
	)
	Port Map(
		i_FS		=>	w_FS,
		i_CLK		=> w_CLK,
		i_RST		=> i_RST,
		o_WR_R1	=> w_WR_R1,
		o_WR_R2	=> w_WR_R2,
		o_WR_R3	=> w_WR_R3,
		o_WR_R4	=> w_WR_R4
	);
	
------------------------ ROUTER 0 ------------------------
	R1: ROUTER
	Generic Map(
		p_type	=> 0,
		p_w_SIZE	=> p_w_SIZE,
		p_b_SIZE	=>	10
	)
	Port Map(
		DATA		=> w_DATA,
		i_DATA	=> i_PC1,
		o_DATA	=> o_PC1,
		i_WR_P	=> i_WR_PC1,
		o_WR_P	=> o_WR_PC1,
		i_CLK		=> w_CLK,
		i_RST		=> i_RST,
		i_FS		=> w_FS,
		i_WR		=> w_WR_R1
	);
	
------------------------ ROUTER 1 ------------------------
	R2: ROUTER
	Generic Map(
		p_type	=> 1,
		p_w_SIZE	=> p_w_SIZE,
		p_b_SIZE	=>	10
	)
	Port Map(
		DATA		=> w_DATA,
		i_DATA	=> i_PC2,
		o_DATA	=> o_PC2,
		i_WR_P	=> i_WR_PC2,
		o_WR_P	=> o_WR_PC2,
		i_CLK		=> w_CLK,
		i_RST		=> i_RST,
		i_FS		=> w_FS,
		i_WR		=> w_WR_R2
	);
	
------------------------ ROUTER 2 ------------------------
	R3: ROUTER
	Generic Map(
		p_type	=> 2,
		p_w_SIZE	=> p_w_SIZE,
		p_b_SIZE	=>	10
	)
	Port Map(
		DATA		=> w_DATA,
		i_DATA	=> i_PC3,
		o_DATA	=> o_PC3,
		i_WR_P	=> i_WR_PC3,
		o_WR_P	=> o_WR_PC3,
		i_CLK		=> w_CLK,
		i_RST		=> i_RST,
		i_FS		=> w_FS,
		i_WR		=> w_WR_R3
	);
	
------------------------ ROUTER 3 ------------------------
	R4: ROUTER
	Generic Map(
		p_type	=> 3,
		p_w_SIZE	=> p_w_SIZE,
		p_b_SIZE	=>	10
	)
	Port Map(
		DATA		=> w_DATA,
		i_DATA	=> i_PC4,
		o_DATA	=> o_PC4,
		i_WR_P	=> i_WR_PC4,
		o_WR_P	=> o_WR_PC4,
		i_CLK		=> w_CLK,
		i_RST		=> i_RST,
		i_FS		=> w_FS,
		i_WR		=> w_WR_R4
	);
	
end nt;