
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ProgCounter is
    GENERIC (n : integer := 32);
    Port( -- input
          CLK        : in  std_logic;
          comreset_sig  : in  std_logic;
          input      : in  std_logic_vector(31 downto 0);
          output : out std_logic_vector(31 downto 0) );
end ProgCounter;

architecture Behavioral of ProgCounter is

begin
    process(CLK)
        begin
            if comreset_sig = '0' then
              output <= (others => '0' );
            elsif rising_edge(CLK) then
              output <= input;
            end if;
    end process;
end Behavioral;
