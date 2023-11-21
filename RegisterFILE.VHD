library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFILE is
    GENERIC(n : integer := 32);
    Port(
        CLK          : in std_logic;
        comreset_sig    : in std_logic;
        addy_0 : in std_logic_vector(4 downto 0);
        addy_1 : in std_logic_vector(4 downto 0);
        output  : in std_logic_vector(4 downto 0);
        write_data   : in std_logic_vector(n - 1 downto 0);
        RegWrite     : in std_logic;  

        regi_0   : out std_logic_vector(n-1 downto 0);
        regi_1   : out std_logic_vector(n-1 downto 0) );
end RegisterFILE;

architecture Behavioral of RegisterFILE is

    type   registers_type is array (0 to 31) of std_logic_vector(n-1 downto 0);
    signal reg : registers_type := ((others => (others => '0')));

    begin
        process(CLK)
            begin
            --sets and selects registers
                if comreset_sig = '0' then 
                  reg(to_integer(unsigned(output))) <= (others => '0');
                  else if rising_edge(CLK) and RegWrite = '1' then
                    reg(to_integer(unsigned(output))) <= write_data;
                  end if;
                end if;
        end process;

  regi_0 <= reg(to_integer(unsigned(addy_0)));  
  regi_1 <= reg(to_integer(unsigned(addy_1)));  




end Behavioral;
