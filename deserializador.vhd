library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity deserializador is
    Port (
        clock : in  std_logic;
        reset : in  std_logic;
        data_in : in  std_logic;
        write_in : in  std_logic;
        ack_in : in  std_logic;
        
        data_out : out std_logic_vector(7 downto 0);
        data_ready : out std_logic;
        status_out : out std_logic
    );
end deserializador;

architecture behavior of deserializador is
    signal buffer : std_logic_vector(7 downto 0) := (others => '0'); --guarda os bits
    signal count : integer range 0 to 8 := 0; --numero de bits
    signal ready : std_logic := '0';
begin
    process(clock, reset)
    begin
        if reset = '1' then             --zera tudo 
            buffer <= (others => '0');
            count  <= 0;
            ready  <= '0';
            data_ready <= '0';
            status_out <= '0';

        elsif rising_edge(clock) then
            if ready = '1' then
                if ack_in = '1' then
                    ready <= '0';
                    count <= 0;
                    data_ready <= '0';
                    status_out <= '0';
                end if;

                    --  bota no buffer, aumenta o count
            elsif write_in = '1' then    
                buffer(count) <= data_in;
                count <= count + 1;
                         -- palavra ta pronta
                if count = 7 then
                    ready <= '1';
                    data_ready <= '1';
                    status_out <= '1';
                end if;
            end if;
                
        end if;
    end process;
            
    data_out <= buffer;
                
end behavior;
