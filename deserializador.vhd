library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity deserializador is
    Port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        data_in      : in  std_logic;
        write_in     : in  std_logic;
        ack_in       : in  std_logic;
        data_out     : out std_logic_vector(7 downto 0);
        data_ready   : out std_logic;
        status_out   : out std_logic
    );
end deserializador;

architecture behavior of deserializador is
    signal buffer : std_logic_vector(7 downto 0) := (others => '0');
    signal count  : integer range 0 to 8 := 0;
    signal ready  : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            buffer     <= (others => '0');
            count      <= 0;
            ready      <= '0';
            data_ready <= '0';
            status_out <= '0';
        elsif rising_edge(clk) then
            if ready = '1' then
                if ack_in = '1' then
                    ready      <= '0';
                    count      <= 0;
                    data_ready <= '0';
                    status_out <= '0';
                end if;
            elsif write_in = '1' then
                buffer(count) <= data_in;
                count <= count + 1;
                if count = 7 then
                    ready      <= '1';
                    data_ready <= '1';
                    status_out <= '1';
                end if;
            end if;
        end if;
    end process;
    data_out <= buffer;
end behavior;
