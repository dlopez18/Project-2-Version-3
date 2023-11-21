library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SignExtender is
    Port(
        value  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0) );
end SignExtender;

architecture Behavioral of SignExtender is

begin
    output <= "0000000000000000" & value when (value(15) = '0') else
           "1111111111111111" & value;

end Behavioral;
