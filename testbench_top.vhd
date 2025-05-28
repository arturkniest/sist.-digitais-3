library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench_top is
end testbench_top;

architecture sim of testbench_top is

    signal clk_1MHz   : std_logic := '0';
    signal rst        : std_logic := '1';
    signal data_bit   : std_logic := '0';
    signal write      : std_logic := '0';
    signal ack        : std_logic := '0';
    signal dequeue    : std_logic := '0';

    component top_level
        Port (
            clk_1MHz : in std_logic;
            rst      : in std_logic;
            data_bit : in std_logic;
            write    : in std_logic;
            ack      : in std_logic;
            dequeue  : in std_logic
        );
    end component;

begin

    uut: top_level
        port map (
            clk_1MHz => clk_1MHz,
            rst      => rst,
            data_bit => data_bit,
            write    => write,
            ack      => ack,
            dequeue  => dequeue
        );

    -- Clock 1MHz
    process
    begin
        wait for 500 ns;
        clk_1MHz <= not clk_1MHz;
    end process;

    -- Stimulus
    process
        procedure send_byte(b: std_logic_vector(7 downto 0)) is
        begin
            for i in 7 downto 0 loop
                data_bit <= b(i);
                write <= '1';
                wait for 10 us; -- simula clock 100kHz
                write <= '0';
                wait for 10 us;
            end loop;
        end procedure;

    begin
        wait for 20 us;
        rst <= '0';

        -- ---------- BOM CASO: inserção e remoção sincronizada ----------
        report "INÍCIO CASO BOM";
        for i in 0 to 5 loop
            send_byte(std_logic_vector(to_unsigned(i, 8)));
            ack <= '1';
            wait for 20 us;
            ack <= '0';

            dequeue <= '1';
            wait for 100 us;
            dequeue <= '0';
        end loop;

        -- ---------- CASO RUIM: inserção contínua até travar ----------
        report "INÍCIO CASO RUIM";
        for i in 0 to 10 loop
            send_byte(std_logic_vector(to_unsigned(i + 10, 8)));
            ack <= '1';
            wait for 20 us;
            ack <= '0';
        end loop;

        -- sem dequeue: fila cheia → deserializador trava
        wait for 200 us;
        report "FIM DA SIMULAÇÃO";
        wait;
    end process;

end sim;
