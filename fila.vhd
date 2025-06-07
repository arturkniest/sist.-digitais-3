library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fila is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        data_in     : in  std_logic_vector(7 downto 0);
        enqueue_in  : in  std_logic;
        dequeue_in  : in  std_logic;
        data_out    : out std_logic_vector(7 downto 0);
        len_out     : out std_logic_vector(7 downto 0)
    );
end fila;

architecture Behavioral of fila is
    type fifo_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal buffer : fifo_array := (others => (others => '0'));
    signal head   : integer range 0 to 7 := 0;  -- posição para remover
    signal tail   : integer range 0 to 7 := 0;  -- posição para inserir
    signal count  : integer range 0 to 8 := 0;  -- quantidade atual
    signal data_out_reg : std_logic_vector(7 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            buffer       <= (others => (others => '0'));
            head         <= 0;
            tail         <= 0;
            count        <= 0;
            data_out_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- ENQUEUE
            if enqueue_in = '1' and count < 8 then
                buffer(tail) <= data_in;
                tail <= (tail + 1) mod 8;
                count <= count + 1;
            end if;

            -- DEQUEUE
            if dequeue_in = '1' and count > 0 then
                data_out_reg <= buffer(head);
                head <= (head + 1) mod 8;
                count <= count - 1;
            end if;
        end if;
    end process;

    data_out <= data_out_reg;
    len_out  <= std_logic_vector(to_unsigned(count, 8));

end Behavioral;