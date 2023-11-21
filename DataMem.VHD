

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataMem is
    GENERIC(n : integer := 32);
    Port(
        CLK            : in std_logic;
        comreset_sig      : in std_logic;
        memory_address : in std_logic_vector(n-1 downto 0);
        MemWrite       : in std_logic;
        MemRead        : in std_logic;
        value_input    : in std_logic_vector(n-1 downto 0);

        output       : out std_logic_vector(n-1 downto 0) );
end DataMem;

architecture Behavioral of DataMem is
    type mem_type is array  (127 downto 0) of std_logic_vector(n - 1 downto 0); -- should be 2^30 words
    signal mem: mem_type;
    
    begin
    
        Process(CLK, comreset_sig)
        begin
            if comreset_sig = '0' then
                mem <= (others => (others=>'0'));
            elsif rising_edge(CLK) and MemWrite = '1' then
                mem(to_integer(unsigned(memory_address))) <= value_input;
            end if;
        end Process;
            output <= (mem(to_integer(unsigned(memory_address)))) when MemRead = '1' else (others => '0');
    
end Behavioral;