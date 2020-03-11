library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity ROUTER is
	Generic(
		p_type	: integer := 0;			-- NUMBER OF THE ROUTER (0 TO 3)
		p_w_SIZE : integer := 16;			-- WORD SIZE
		p_b_SIZE	: integer := 10			-- ROUTER OUT SIZE
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
end ROUTER;
	
architecture rt of ROUTER is

--------------------------------- PARALLEL-TO-SERIAL COMPONENT ---------------------------------------
	component P2S is
		Generic(
			p_w_SIZE	: integer := 16
		);
		Port(
			i_DATA		: in STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
			i_ND_OUT		: in STD_LOGIC;
			i_CLK			: in STD_LOGIC;
			i_EN			: in STD_LOGIC;
			i_RST			: in STD_LOGIC;
			o_DATA		: out STD_LOGIC
		);
	end component;

--------------------------------- SERIAL-TO-PARALLEL COMPONENT ---------------------------------------	
	component S2P is
		Generic(
			p_w_SIZE	: integer := 16
		);
		Port(
			i_DATA	: in STD_LOGIC;
			i_CLK		: in STD_LOGIC;
			i_EN		: in STD_LOGIC;
			o_DATA	: OUT STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0)
		);
	end component;

----------------------------------------- BUFFER SIGNALS ------------------------------------------------
	type buffer_type is array (0 to (p_b_SIZE-1)) of STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_BUFFER			: buffer_type;												-- BUFFER VECTOR
	signal w_BUFF				: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);
	signal w_C_READ			: integer range 0 to 9;									-- READ INDEX TO BUFFER
	signal w_C_WRITE			: integer range 0 to 10;								-- WRITE INDEX TO BUFFER
	
------------------------------------------ DATA SIGNALS ------------------------------------------------
	signal w_DO					: STD_LOGIC;											-- DATA OUT SIGNAL NETWORK
	signal w_DIN				: STD_LOGIC;											-- DATA IN SIGNAL NETWORK
	signal w_o_DATA			: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);	-- DATA OUT SIGNAL PC
	signal w_i_DATA			: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);	-- DATA IN SIGNAL PC
	signal w_EN_S2P			: STD_LOGIC;											-- ENABLE DATA_IN_NETWORK
	signal w_DATA_IN_NET		: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);	-- DATA IN SIGNAL NETWORK (16 BITS)
	
---------------------------------------- TDM CICLE SIGNALS --------------------------------------------
	signal w_TDM				: STD_LOGIC;
	
------------------------------ SWITCH COMUNICATION AUSXILIAR SIGNALS ----------------------------------
	signal w_EN_COM			: STD_LOGIC;											-- ENABLE COMUNICATION
	signal w_SOURCE			: STD_LOGIC_VECTOR(1 DOWNTO 0);					-- SOURCE SWITCH
	
begin
	
---------------------------------------- COMPONENT INSTANCE --------------------------------------------
	-- SERIAL-TO-PARALLEL
	STP: S2P
	Generic Map(
		p_w_SIZE => p_w_SIZE
	)
	Port Map(
		i_DATA	=> w_DIN,
		i_CLK		=> i_CLK,
		i_EN		=> w_EN_S2P,
		o_DATA	=>	w_DATA_IN_NET
	);
	
	-- PARALELL-TO-SERIAL
	PTS: P2S
	Generic Map(
		p_w_SIZE	=> p_w_SIZE
	)
	Port Map(
		i_DATA	=> w_o_DATA,
		i_ND_OUT	=> w_TDM,
		i_CLK		=> i_CLK,
		i_EN		=> i_WR,
		i_RST		=> i_RST,
		o_DATA	=>	w_DO 
	);
	
	-- If not data on bus, high impedance
	w_EN_S2P	<= not i_WR;
	DATA		<= w_DO when(i_WR = '1') else 'Z';
	w_DIN		<= DATA;
	
	-- buffer in receive data from network input when enable comunication is on
	w_BUFF	<= w_DATA_IN_NET when w_EN_COM = '1';

-- *************************************************************************************
--	TDM CICLE ZONE																								*
-- *************************************************************************************		

	TDM_CICLE: process(i_CLK, i_RST)
		variable count: integer range 0 to (p_w_SIZE-1) := 0;
	begin
		if(i_RST = '0') then
			w_TDM	<= '0';								-- TDM cicle doesn't start to specific router
			count	:= 0;									-- cicles count by zero
		elsif rising_edge(i_CLK) then
			if(i_WR = '1') then						-- Write Enable up
				-- Finish the TDM cicle to specific router
				if(count = (p_w_SIZE-1)) then
					w_TDM	<= '1';
				-- Count is increment
				elsif(count < (p_w_SIZE-1)) then
					count	:=	count + 1;
				-- Count by zero
				else
					count	:= 0;
				end if;	
			-- Conditions to reset state
			else
				count := 0;
				w_TDM	<= '0';
			end if;	
		end if;
	end process TDM_CICLE;
	
-- *************************************************************************************
--	DATA OUT NETWORK ZONE																					*
-- *************************************************************************************	

	DATA_OUT_NETWORK: process(i_CLK, i_RST)
	begin
		-- reset region
		if(i_RST =  '0') then			
			w_C_READ		<= 0;		-- Reset reader index (first position)
		elsif rising_edge(i_CLK) then
			-- Every new TDM cicle, new data out to network
			if(i_FS = '1') then
				-- Read data if the writer index is over that reader index
				if(w_C_READ < w_C_WRITE) then
					w_o_DATA	<= w_BUFFER(w_C_READ);	-- Data out
					-- Increase read index
					if(w_C_READ < p_b_SIZE) then
						w_C_READ <= w_C_READ + 1;
					end if;
				elsif(w_C_READ = p_b_SIZE) then
					w_C_READ	<= 0;
				else
					w_o_DATA	<= (others => '0');
				end if;
			end if;
		end if;
	end process DATA_OUT_NETWORK;
		
-- *************************************************************************************
--	DATA FROM PROCESSOR TO NETWORK																		*
-- *************************************************************************************
	
	PC_TO_NETWORK: process(i_WR_P)
	begin
		-- reset region
		if(i_RST =  '0') then
			-- Reset buffer out
			for ii in 0 to 9 loop
				w_BUFFER(ii) <= (OTHERS => '0');
			end loop;		
			w_C_WRITE	<= 0;	-- Reset writer index (first position)
		elsif(i_WR_P = '1') then
			-- Check full buffer
			if(w_C_WRITE >= p_b_SIZE) then
				if(w_C_READ > 0) then
					w_C_WRITE	<= 0;
				else
					w_C_WRITE	<= p_b_SIZE;
				end if;
			else
				w_BUFFER(w_C_WRITE)	<= i_DATA;
				-- Increase write index
				if(w_C_WRITE 	<= p_b_SIZE) then
					w_C_WRITE 	<= w_C_WRITE + 1;
				end if;
			end if;		
			
		end if;
	end process PC_TO_NETWORK;

-- *************************************************************************************
--	DATA FROM NETWORK TO PROCESSOR																		*
-- *************************************************************************************
	
	NETWORK_TO_PROCESSOR : process(i_FS, i_RST)
	begin
		if(i_RST = '0') then
			o_WR_P	<= '0';
		-- Every TDM's cicle, the data on buffer in is send to processor
		elsif(i_FS = '1') then
			o_WR_P	<= '1';
			o_DATA	<= w_BUFF;
		else
			o_WR_P	<= '0';
		end if;
	end process NETWORK_TO_PROCESSOR;
		
		
-- *************************************************************************************
--	ROUTER 0 ZONE																								*
-- *************************************************************************************
	R0: if p_type = 0 generate
		SWITCH_R0: process(i_CLK) is
			variable count: integer range 0 to (p_w_SIZE-1) := 0;
		begin
			if(i_RST	= '0') then
				count := 0;
				w_EN_COM <= '0';
			elsif rising_edge(i_CLK) then
				if(count < p_w_SIZE - 1) then
					count	:= count + 1;
				else
					-- The received data is direct to router0
					if(w_DATA_IN_NET = x"FF00") then
						if(w_EN_COM = '0') then
							w_EN_COM	<= '1';		-- Enbale Comunication
						else 
							w_EN_COM	<= '0';
						end if;
					else
						if(w_EN_COM	= '0') then
							count := 0;
							w_EN_COM	<= '0'; 		-- Comunication disable
						end if;
					end if;
				end if;
			end if;
		end process SWITCH_R0;
	end generate R0;

-- *************************************************************************************
--	ROUTER 1 ZONE																								
-- *************************************************************************************

	R1: if p_type = 1 generate
		SWITCH_R1: process(i_CLK) is
			variable count: integer range 0 to (p_w_SIZE-1) := 0;
		begin
			if(i_RST	= '0') then
				count := 0;
				w_EN_COM <= '0';
			elsif rising_edge(i_CLK) then
				if(count < p_w_SIZE - 1) then
					count	:= count + 1;
				else
					-- The received data is direct to router1
					if(w_DATA_IN_NET = x"FF40") then
						if(w_EN_COM = '0') then
							w_EN_COM	<= '1';		-- Enbale Comunication
						else 
							w_EN_COM	<= '0';
						end if;
					else
						if(w_EN_COM	= '0') then
							count := 0;
							w_EN_COM	<= '0'; 		-- Comunication disable
						end if;
					end if;
				end if;
			end if;
		end process SWITCH_R1;
	end generate R1;

-- *************************************************************************************
--	ROUTER 2 ZONE																								*
-- *************************************************************************************
	R2: if p_type = 2 generate
		SWITCH_R2: process(i_CLK) is
			variable count: integer range 0 to (p_w_SIZE-1) := 0;
		begin
			if(i_RST	= '0') then
				count := 0;
				w_EN_COM <= '0';
			elsif rising_edge(i_CLK) then
				if(count <  p_w_SIZE - 1) then
					count	:= count + 1;
				else
					-- The received data is direct to router2
					if(w_DATA_IN_NET = x"FF80") then
						if(w_EN_COM = '0') then
							w_EN_COM	<= '1';		-- Enbale Comunication
						else 
							w_EN_COM	<= '0';
						end if;
					else
						if(w_EN_COM	= '0') then
							count := 0;
							w_EN_COM	<= '0'; 		-- Comunication disable
						end if;
					end if;
				end if;
			end if;
		end process SWITCH_R2;
	end generate R2;


-- *************************************************************************************
--	ROUTER 3 ZONE																								*
-- *************************************************************************************
	R3: if p_type = 3 generate
		SWITCH_R3: process(i_CLK) is
			variable count: integer range 0 to (p_w_SIZE-1) := 0;
		begin
			if(i_RST	= '0') then
				count := 0;
				w_EN_COM <= '0';
			elsif rising_edge(i_CLK) then
				if(count <  p_w_SIZE - 1) then
					count	:= count + 1;
				else
					-- The received data is direct to router3
					if(w_DATA_IN_NET <= x"FFC0") then
						if(w_EN_COM = '0') then
							w_EN_COM	<= '1';		-- Enbale Comunication
						else 
							w_EN_COM	<= '0';
						end if;
					else
						if(w_EN_COM	= '0') then
							count := 0;
							w_EN_COM	<= '0'; 		-- Comunication disable
						end if;
					end if;
				end if;
			end if;
		end process SWITCH_R3;
	end generate R3;

end rt;