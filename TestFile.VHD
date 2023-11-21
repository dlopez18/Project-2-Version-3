
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use std.textio.all;


entity TestFile is
end TestFile;
--TESTY TEST --TEST.FILETEST
architecture Behavioral of TestFile is
    constant CLK_low    : time := 12 ns;
    constant CLK_high   : time := 8 ns;
    constant CLK_period : time := CLK_low + CLK_high;
    constant ResetTime  : time := 10 ns;
    signal clock , reset : std_logic;
    signal count         : std_logic_vector(10 downto 0);

    Component CommandCode is
        Port( CLK, comreset_sig  : in std_logic );
    end component;

begin
    dut : CommandCode Port map ( clock, reset );
reset_process : process
begin
    reset <= '0';
    wait for ResetTime;
    reset <= '1';
    wait;
end process reset_process;

clock_process : process
begin
    if (clock = '0') then
        clock <= '1';
        wait for CLK_high;
    else
        clock <= '0';
        wait for CLK_low;
        count <= STD_LOGIC_VECTOR(unsigned(count) + 1);
        end if;
end process clock_process;


end Behavioral;