library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity CROSSBAR is
	Generic(
		p_w_SIZE		: integer := 16;
		p_r_COUNT	: integer := 4
	);
	Port(
		-- ROUTER'S	BUS
		io_R1		: inout STD_LOGIC;
		io_R2		: inout STD_LOGIC;
		io_R3		: inout STD_LOGIC;
		io_R4		: inout STD_LOGIC;
		
		-- NETWORK INPUTS
		i_FS		: in STD_LOGIC;
		i_CLK		: in STD_LOGIC;
		i_RST		: in STD_LOGIC;
		
		-- ROUTER'S WRITE ENABLE
		i_WR_R1	: in STD_LOGIC;
		i_WR_R2	: in STD_LOGIC;
		i_WR_R3	: in STD_LOGIC;
		i_WR_R4	: in STD_LOGIC
	);
end CROSSBAR;

architecture crb of CROSSBAR is

	signal w_i_BUFFER	: STD_LOGIC_VECTOR((p_w_SIZE-1) DOWNTO 0);		-- BUFFER DATA IN CROSSBAR
	
------------------------------ SELECT CHANNEL COMUNICATION SIGNAL ------------------------------------
	signal c_CH		: STD_LOGIC_VECTOR(p_r_COUNT DOWNTO 0);			-- BUS CONTROL
	signal CHR1		: STD_LOGIC_VECTOR((p_r_COUNT-2) DOWNTO 0);		-- SWITCH CONTROL BUFFER ROUTER-1
	signal CHR2		: STD_LOGIC_VECTOR((p_r_COUNT-2) DOWNTO 0);		-- SWITCH CONTROL BUFFER ROUTER-2
	signal CHR3		: STD_LOGIC_VECTOR((p_r_COUNT-2) DOWNTO 0);		-- SWITCH CONTROL BUFFER ROUTER-3
	signal CHR4		: STD_LOGIC_VECTOR((p_r_COUNT-2) DOWNTO 0);		-- SWITCH CONTROL BUFFER ROUTER-4
	
------------------------------------ COMMUNICATION SIGNALS --------------------------------------------
	signal w_DATA			: STD_LOGIC;
	signal w_io_R1			: STD_LOGIC;
	signal w_io_R2			: STD_LOGIC;
	signal w_io_R3			: STD_LOGIC;
	signal w_io_R4			: STD_LOGIC;
	
--------------------------------------- AUXILIAR SIGNALS --------------------------------------------
	signal w_CHECK_COM			: STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal w_CICLE					: STD_LOGIC_VECTOR((p_r_COUNT-1) DOWNTO 0);
	
--------------------------------------- ROUTER SIGNALS --------------------------------------------
	signal w_R1				: STD_LOGIC;
	signal w_R2				: STD_LOGIC;
	signal w_R3				: STD_LOGIC;
	signal w_R4				: STD_LOGIC;
	
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

--------------------------------SERIAL-TO-PARALLEL COMPONENT -------------------------------------------
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
	
	
begin

--	c_P2S	: P2S
--	Generic Map(
--		p_w_SIZE	=> p_w_SIZE
--	);
--	Port Map(
--		i_DATA	=>	w_o_BUFFER,		-- O Sinal vem do Buffer
--		i_ND_OUT	=> ,
--		i_CLK		=> i_CLK,
--		i_EN		=> c_CH(p_r_COUNT),
--		i_RST		=> i_RST,
--		o_DATA	=> w_OUT				-- O sinal vai para a saída
--	);
	
	c_S2P	: S2P
	Generic Map(
		p_w_SIZE	=> p_w_SIZE
	)
	Port Map(
		i_DATA	=> w_DATA,
		i_CLK		=> i_CLK,
		i_EN		=> '1',
		o_DATA	=>	w_i_BUFFER
	);
	
	
	-- Recebe o index do roteador que está transmitindo 
	c_CH(p_r_COUNT DOWNTO (p_r_COUNT-1))	<= "00" when i_WR_R1 = '1' else
															"01" when i_WR_R2 = '1' else
															"10" when i_WR_R3 = '1' else
															"11" when i_WR_R4 = '1';
															
	-- Recebe informações de chaveamento do roteador que está escrevendo (se está comunicando e com quem)
	c_CH((p_r_COUNT-2) DOWNTO 0)				<= CHR1 when i_WR_R1 = '1' else
															CHR2 when i_WR_R2 = '1' else
															CHR3 when i_WR_R3 = '1' else
															CHR4 when i_WR_R4 = '1';
														
	io_R1												<= w_R1 when ((i_WR_R1 = '0') AND (c_CH((p_r_COUNT-1) DOWNTO 0) = "00")) else 'Z';
	io_R2												<= w_R2 when ((i_WR_R2 = '0') AND (c_CH((p_r_COUNT-1) DOWNTO 0) = "01")) else 'Z';
	io_R3												<= w_R3 when ((i_WR_R3 = '0') AND (c_CH((p_r_COUNT-1) DOWNTO 0) = "10")) else 'Z';
	io_R4												<= w_R4 when ((i_WR_R4 = '0') AND (c_CH((p_r_COUNT-1) DOWNTO 0) = "11")) else 'Z';
														
	-- O barramento recebe o dado vindo do roteador que está comunicando
	w_DATA											<= io_R1 when i_WR_R1 = '1' else
															io_R2 when i_WR_R2 = '1' else
															io_R3 when i_WR_R3 = '1' else
															io_R4 when i_WR_R4 = '1' else 'Z';
															
	
	w_CHECK_COM(1)												<= c_CH(1);
	w_CHECK_COM(0)												<= c_CH(0);
	
	Process(i_RST, i_CLK)
	begin
		if(i_RST = '0') then
			CHR1		<= (others => '0');
			CHR2		<= (others => '0');
			CHR3		<= (others => '0');
			CHR4		<= (others => '0');
		elsif rising_edge(i_CLK) then
			-- Recebe início ou final de comunicação: armazena os dados de quem está comunicando com quem ou finaliza comunicação
			if(w_i_BUFFER((p_w_SIZE-1) DOWNTO (p_w_SIZE-8)) = x"FF") then
				-- Router 1 comunicando e sem chaveamento
				if(i_WR_R1 = '1' AND CHR1(2) = '0') then
					CHR1(p_r_COUNT-2) <= '1';							-- Chaveia comunicação
					-- Endereço do receptor
					CHR1(p_r_COUNT-3) <= w_i_BUFFER(p_w_SIZE-9);
					CHR1(0)				<= w_i_BUFFER(p_w_SIZE-10);
					w_CICLE(0)			<= '1';
				-- Router 1 comunicando e chaveado
				elsif(i_WR_R1 = '1' AND CHR1(2) = '1' AND w_CICLE(0) = '0') then
					-- Fecha comunicação
					CHR1(p_r_COUNT-2) <= '0';
					CHR1(p_r_COUNT-3) <= '0';
					CHR1(0)				<= '0';
				end if;
				-- Router 2 comunicando e sem chaveamento
				if(i_WR_R2 = '1' AND CHR2(2) = '0') then
					CHR2(p_r_COUNT-2) <= '1';							-- Chaveia comunicação
					-- Endereço do receptor
					CHR2(p_r_COUNT-3) <= w_i_BUFFER(p_w_SIZE-9);
					CHR2(0)				<= w_i_BUFFER(p_w_SIZE-10);
					w_CICLE(1)			<= '1';
				-- Router 2 comunicando e chaveado
				elsif(i_WR_R2 = '1' AND CHR2(2) = '1' AND w_CICLE(1) = '0') then
					-- Fecha comunicação
					CHR2(p_r_COUNT-2) <= '0';
					CHR2(p_r_COUNT-3) <= '0';
					CHR2(0)				<= '0';
				end if;
				-- Router 3 comunicando e sem chaveamento
				if(i_WR_R3 = '1' AND CHR3(2) = '0') then
					CHR3(p_r_COUNT-2) <= '1';							-- Chaveia comunicação
					-- Endereço do receptor
					CHR3(p_r_COUNT-3) <= w_i_BUFFER(p_w_SIZE-9);
					CHR3(0)				<= w_i_BUFFER(p_w_SIZE-10);
					w_CICLE(2)			<= '1';
				-- Router 3 comunicando e chaveado
				elsif(i_WR_R3 = '1' AND CHR3(2) = '1' AND w_CICLE(2) = '0') then
					-- Fecha comunicação
					CHR3(p_r_COUNT-2) <= '0';
					CHR3(p_r_COUNT-3) <= '0';
					CHR3(0)				<= '0';
				end if;
				-- Router 4 comunicando e sem chaveamento
				if(i_WR_R4 = '1' AND CHR4(2) = '0') then
					CHR4(p_r_COUNT-2) <= '1';							-- Chaveia comunicação
					-- Endereço do receptor
					CHR4(p_r_COUNT-3) <= w_i_BUFFER(p_w_SIZE-9);
					CHR4(0)				<= w_i_BUFFER(p_w_SIZE-10);
					w_CICLE(3)			<= '1';
				-- Router 4 comunicando e chaveado
				elsif(i_WR_R4 = '1' AND CHR4(2) = '1' AND w_CICLE(3) = '0') then
					-- Fecha comunicação
					CHR4(p_r_COUNT-2) <= '0';
					CHR4(p_r_COUNT-3) <= '0';
					CHR4(0)				<= '0';
				end if;
			end if;
		end if;
	end Process;
	
	
	COM: Process(i_CLK, c_CH)
	begin
		if rising_edge(i_CLK) then
			case w_CHECK_COM is
				when "00"	=>
					w_R1	<= w_DATA;
				when "01"	=>
					w_R2	<= w_DATA;
				when "10"	=>
					w_R3	<= w_DATA;
				when "11"	=>
					w_R4	<= w_DATA;
				when others	=>
					
			end case;
		end if;
	end process COM;
	
	CHECK: Process(i_CLK)
	begin
		if(i_RST = '0') then
			w_CICLE	<= (others => '0');
		elsif falling_edge(i_CLK) then
			if(i_WR_R1 = '0') then
				w_CICLE(0) <= '0';
			end if;
			if(i_WR_R2 = '0') then
				w_CICLE(1) <= '0';
			end if;
			if(i_WR_R3 = '0') then
				w_CICLE(2) <= '0';
			end if;
			if(i_WR_R4 = '0') then
				w_CICLE(3) <= '0';
			end if;
		end if;
	end process CHECK;

end crb;