-- Testbench para o módulo top do Trabalho 3 - Sistemas Digitais PUCRS

library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;

entity tb_top is end tb_top;

architecture sim of tb_top is

-- Sinais para conectar ao top
signal clk_1mhz   : std_logic := '0';
signal reset      : std_logic := '1';
signal serial_in  : std_logic := '0';
signal write_in   : std_logic := '0';
signal ack_in     : std_logic := '0';
signal dequeue    : std_logic := '0';

signal data_out   : std_logic_vector(7 downto 0);
signal len_out    : std_logic_vector(7 downto 0);
signal status     : std_logic;
signal ready      : std_logic;

constant CLK_PERIOD : time := 1 us; -- 1 MHz clock

begin

-- Instância do DUT
uut: entity work.top
    port map (
        clk_1mhz   => clk_1mhz,
        reset      => reset,
        serial_in  => serial_in,
        write_in   => write_in,
        ack_in     => ack_in,
        dequeue    => dequeue,
        data_out   => data_out,
        len_out    => len_out,
        status     => status,
        ready      => ready
    );

-- Clock de 1 MHz
clk_process : process
begin
    while now < 2 ms loop
        clk_1mhz <= '0';
        wait for CLK_PERIOD / 2;
        clk_1mhz <= '1';
        wait for CLK_PERIOD / 2;
    end loop;
    wait;
end process;

-- Estímulos
stim_proc: process
    procedure send_byte(b: std_logic_vector(7 downto 0)) is
    begin
        for i in 7 downto 0 loop
            serial_in <= b(i);
            write_in  <= '1';
            wait for 10 us; -- espera o clock de 100 kHz
            write_in  <= '0';
            wait for 10 us;
        end loop;
    end;

begin
    -- Reset inicial
    wait for 5 us;
    reset <= '0';

    -- CASO BOM: envia 3 bytes com dequeues espaçados
    send_byte("10101010");
    ack_in <= '1'; wait for 10 us; ack_in <= '0';

    wait for 100 us;
    send_byte("11110000");
    ack_in <= '1'; wait for 10 us; ack_in <= '0';

    wait for 100 us;
    send_byte("00001111");
    ack_in <= '1'; wait for 10 us; ack_in <= '0';

    -- Remove um dado
    wait for 20 us;
    dequeue <= '1'; wait for 10 us; dequeue <= '0';

    -- CASO RUIM: envia mais de 8 bytes sem dequeues
    for i in 0 to 9 loop
        send_byte(std_logic_vector(to_unsigned(i, 8)));
        ack_in <= '1'; wait for 10 us; ack_in <= '0';
    end loop;

    wait;
end process;

end sim;