library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TwoShiftLeft is
    Port(
        Shifty  : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0) );
end TwoShiftLeft;

architecture Behavioral of TwoShiftLeft is

begin
    output <= std_logic_vector(unsigned(Shifty) sll 2);

end Behavioral;