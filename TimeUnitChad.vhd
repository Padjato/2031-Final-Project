SIGNAL unit : STD_LOGIC;

FUNCTION TIME_TO_TICKS(
    time_value  : INTEGER;
    time_unit   : STD_LOGIC;
    freq_select : STD_LOGIC
) RETURN INTEGER IS

    VARIABLE ticks : INTEGER;

BEGIN

    IF time_unit = '1' THEN

        IF freq_select = '0' THEN
            ticks := time_value * 10;
        ELSE
            ticks := time_value * 100;
        END IF;

    ELSE

        IF freq_select = '0' THEN
            ticks := (time_value + 99) / 100;
        ELSE
            ticks := (time_value + 9) / 10;
        END IF;

    END IF;

    RETURN ticks;

END FUNCTION;

WRITE PROCESS
WHEN r_units =>
    unit <= IO_DATA(0);

READ PROCESS
WHEN r_units =>
    read_data(0) <= unit;
