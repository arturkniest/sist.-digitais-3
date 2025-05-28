entity top_level is
    Port (
        clk_1MHz : in std_logic;
        rst      : in std_logic;
        data_bit : in std_logic;
        write    : in std_logic;
        ack      : in std_logic;
        dequeue  : in std_logic
    );
end top_level;

architecture arch of top_level is
    signal clk_100kHz : std_logic := '0';
    signal clk_10kHz  : std_logic := '0';
    signal clk_count  : integer := 0;

    -- sinais intermediários
    signal data_byte : std_logic_vector(7 downto 0);
    signal ready     : std_logic;
    signal status    : std_logic;
    signal len       : std_logic_vector(7 downto 0);
    signal fifo_out  : std_logic_vector(7 downto 0);

    component deserializador
        ...
    end component;

    component fila
        ...
    end component;
begin
    -- Divisor de Clock
    process(clk_1MHz)
    begin
        if rising_edge(clk_1MHz) then
            clk_count <= clk_count + 1;
            if clk_count mod 10 = 0 then
                clk_100kHz <= not clk_100kHz;
            end if;
            if clk_count mod 100 = 0 then
                clk_10kHz <= not clk_10kHz;
            end if;
        end if;
    end process;

    -- Instanciação dos módulos
    d_inst : deserializador port map (
        clk => clk_100kHz, rst => rst, data_in => data_bit,
        write_in => write, ack_in => ack, data_out => data_byte,
        data_ready => ready, status_out => status
    );

    f_inst : fila port map (
        clk => clk_10kHz, rst => rst, data_in => data_byte,
        enqueue_in => ready, dequeue_in => dequeue,
        data_out => fifo_out, len_out => len
    );
end arch;

