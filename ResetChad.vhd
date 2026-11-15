PROCESS(CLOCK, RESETN)
BEGIN
    IF RESETN = '0' THEN
        curr_time <= (OTHERS => '0');

    ELSIF rising_edge(CLOCK) THEN

        IF reset_ctrl = '1' THEN

            IF direction = '0' THEN
                -- Count down: reset to the designated time
                curr_time <= time_init;
            ELSE
                -- Count up: reset to zero
                curr_time <= (OTHERS => '0');
            END IF;

        END IF;

    END IF;
END PROCESS;
