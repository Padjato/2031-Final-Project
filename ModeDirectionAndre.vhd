
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Timer_Mode_Direction IS
    PORT (
        CLOCK     : IN STD_LOGIC;
        RESETN    : IN STD_LOGIC;

        IO_ADDR   : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        IO_DATA 	: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IO_WRITE  : IN STD_LOGIC;
		  IO_READ 	: IN STD_LOGIC;
		  RUNNING 	: IN STD_LOGIC; --SET TO WHATEVER WE DECIDE RUNNING IS!!!(1 is actively running, 0 is paused, stopped, finished)

        MODE_OUT      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        DIRECTION_OUT : OUT STD_LOGIC
    );
END Timer_Mode_Direction;

ARCHITECTURE arch OF Timer_Mode_Direction IS

    -- Stores the selected mode
    -- 00 = One-shot
    -- 01 = Periodic
    -- 10 = Stopwatch
    -- 11 = Reserved
    SIGNAL mode_reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

    -- Stores the selected direction
    -- 0 = Count up
    -- 1 = Count down
    SIGNAL direction_reg : STD_LOGIC := '0';
	 SIGNAL read_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    PROCESS(CLOCK, RESETN)
    BEGIN
        IF RESETN = '0' THEN
            mode_reg <= "00";
            direction_reg <= '0';

        ELSIF RISING_EDGE(CLOCK) THEN

            IF IO_WRITE = '1' AND RUNNING = '0' THEN

                CASE IO_ADDR IS

                    -- MODE register: 0x72
                    WHEN "000" & X"72" =>

                        -- Ignore reserved/unused mode 11
                        IF IO_DATA(1 DOWNTO 0) /= "11" THEN
                            mode_reg <= IO_DATA(1 DOWNTO 0);
                        END IF;

                    -- DIRECTION register: 0x73
                    WHEN "000" & X"73" =>
                        direction_reg <= IO_DATA(0);

                    WHEN OTHERS =>
                        NULL;

                END CASE;

            END IF;

        END IF;
    END PROCESS;
	 
	PROCESS(IO_ADDR, mode_reg, direction_reg)
	BEGIN
    read_data <= (OTHERS => '0');

    CASE IO_ADDR IS

        WHEN "000" & X"72" =>
            read_data(1 DOWNTO 0) <= mode_reg;

        WHEN "000" & X"73" =>
            read_data(0) <= direction_reg;

        WHEN OTHERS =>
            NULL;

    END CASE;
	END PROCESS;
	
	IO_DATA <= read_data
    WHEN IO_READ = '1' AND
         (IO_ADDR = ("000" & X"72") OR
          IO_ADDR = ("000" & X"73"))
    ELSE (OTHERS => 'Z');

   MODE_OUT <= mode_reg;
	DIRECTION_OUT <= '0' WHEN mode_reg = "10"
		ELSE direction_reg;

END arch;
