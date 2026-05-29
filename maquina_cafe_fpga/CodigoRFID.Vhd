--Codigo Da RFID com a placa FPGA
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RFID_FSM is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        RFID_IN     : in  STD_LOGIC;
        
        RFID_OK     : out STD_LOGIC;
        RFID_ERROR  : out STD_LOGIC;
        LED_STATUS  : out STD_LOGIC
    );
end RFID_FSM;

architecture Behavioral of RFID_FSM is

    -- Definição dos estados
    type state_type is (q0, q1, q2, q3);
    signal current_state, next_state : state_type;

begin

    ----------------------------------------------------------------
    -- Processo de mudança de estado
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= q0;

        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Processo da FSM
    ----------------------------------------------------------------
    process(current_state, RFID_IN)
    begin

        -- Valores padrão
        RFID_OK    <= '0';
        RFID_ERROR <= '0';
        LED_STATUS <= '0';

        case current_state is

            --------------------------------------------------------
            -- q0 = ESPERA
            --------------------------------------------------------
            when q0 =>

                if RFID_IN = '1' then
                    next_state <= q1;
                else
                    next_state <= q0;
                end if;

            --------------------------------------------------------
            -- q1 = LEITURA
            --------------------------------------------------------
            when q1 =>

                if RFID_IN = '1' then
                    next_state <= q2;
                else
                    next_state <= q1;
                end if;

            --------------------------------------------------------
            -- q2 = COMPARAÇÃO
            --------------------------------------------------------
            when q2 =>

                if RFID_IN = '1' then
                    next_state <= q3;
                else
                    next_state <= q0;
                end if;

            --------------------------------------------------------
            -- q3 = LIBERADO
            --------------------------------------------------------
            when q3 =>

                RFID_OK    <= '1';
                LED_STATUS <= '1';

                next_state <= q0;

            when others =>
                next_state <= q0;

        end case;
    end process;

end Behavioral;