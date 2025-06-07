

library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;

entity top is Port ( clk_1mhz  : in  std_logic; -- clock de entrada reset     : in  std_logic; serial_in : in  std_logic; -- entrada de bits write_in  : in  std_logic; -- sinal para indicar escrita de bit ack_in    : in  std_logic; -- sinal de acknowledge para o deserializador dequeue   : in  std_logic; -- sinal para remoção da fila

data_out  : out std_logic_vector(7 downto 0); -- dado retirado da fila
    len_out   : out std_logic_vector(7 downto 0); -- tamanho atual da fila
    status    : out std_logic;                    -- status_out do deserializador
    ready     : out std_logic                     -- data_ready do deserializador
);

end top;

architecture Behavioral of top is

-- Sinais de clock divididos
signal clk_100khz : std_logic := '0';
signal clk_10khz  : std_logic := '0';

-- Contadores para dividir clock
signal count_100khz : integer range 0 to 4 := 0;  -- Divide 1MHz por 10 (5 ciclos altos/baixos)
signal count_10khz  : integer range 0 to 49 := 0; -- Divide 1MHz por 100 (50 ciclos altos/baixos)

-- Conexões internas
signal des_data_out   : std_logic_vector(7 downto 0);
signal des_data_ready : std_logic;
signal des_status     : std_logic;

signal fifo_enqueue : std_logic;

begin ----------------------------------------------------------------------------- -- Divisor de clock 100kHz (1MHz / 10) process(clk_1mhz) begin if rising_edge(clk_1mhz) then if count_100khz = 4 then clk_100khz <= not clk_100khz; count_100khz <= 0; else count_100khz <= count_100khz + 1; end if; end if; end process;

-- Divisor de clock 10kHz (1MHz / 100)
process(clk_1mhz)
begin
    if rising_edge(clk_1mhz) then
        if count_10khz = 49 then
            clk_10khz <= not clk_10khz;
            count_10khz <= 0;
        else
            count_10khz <= count_10khz + 1;
        end if;
    end if;
end process;

-----------------------------------------------------------------------------
-- Instância do deserializador
u_des : entity work.deserializador
    port map (
        clock      => clk_100khz,
        reset      => reset,
        data_in    => serial_in,
        write_in   => write_in,
        ack_in     => ack_in,
        data_out   => des_data_out,
        data_ready => des_data_ready,
        status_out => des_status
    );

-----------------------------------------------------------------------------
-- Controle de enqueue: só colocamos na fila se não estiver cheia
fifo_enqueue <= '1' when (des_data_ready = '1' and len_out < "1000") else '0';

-----------------------------------------------------------------------------
-- Instância da fila
u_fifo : entity work.fila
    port map (
        clk        => clk_10khz,
        reset      => reset,
        data_in    => des_data_out,
        enqueue_in => fifo_enqueue,
        dequeue_in => dequeue,
        data_out   => data_out,
        len_out    => len_out
    );

-----------------------------------------------------------------------------
-- Sinais de saída
status <= des_status;
ready  <= des_data_ready;

end Behavioral;