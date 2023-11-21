
--If it breaks, this is the file that did it--Troubleshoot later
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
    Port(
        instruction : in std_logic_vector(31 downto 0);
        ZeroCarry   : in std_logic;
        --CONTROL
        RegDst      : out std_logic;
        Jump        : out std_logic;
        Branch      : out std_logic;
        MemRead     : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector (3 downto 0);
        MemWrite    : out std_logic;
        ALUSrc      : out std_logic;
        RegWrite    : out std_logic );
end Control;

architecture Behavioral of Control is
    signal data : std_logic_vector(11 downto 0); 
    begin
      --ADD D, R, R
      data <= "100000000001" when (instruction(31 downto 26) = "000000" and instruction(10 downto 0)  = "00000100000") else
      -- SUB D, R, R
      "100000001001" when (instruction(31 downto 26) = "000000" and instruction(10 downto 0)  = "00000100010") else
      -- AND D, R, R
      "100000010001" when (instruction(31 downto 26) = "000000" and instruction(10 downto 0)  = "00000100100") else
      -- OR D, R, R
      "100000011001" when (instruction(31 downto 26) = "000000" and instruction(10 downto 0)  = "00000100101") else
      -- NOR D, R, R
      "100000100001" when (instruction(31 downto 26) = "000000" and instruction(10 downto 0)  = "00000100111") else
      -- XOR D, R, R
      "100000110001" when (instruction(31 downto 26) = "000000" and instruction(5 downto 0)   = "100110") else
      -- SLL D, R, SHFT
      "100000111011" when (instruction(31 downto 26) = "000000" and instruction(5 downto 0)   = "000000") else
      -- SRL D, R, SHFT
      "100001000011" when (instruction(31 downto 26) = "000000" and instruction(5 downto 0)   = "000010") else
      -- SLT D, R, R
      "100001001001" when (instruction(31 downto 26) = "000000" and instruction(10 downto 0)  = "00000101010") else
      -- ADDI D, R, R
      "000000000011" when instruction(31 downto 26) = "001000" else
      -- LW
      "000110000011" when instruction(31 downto 26) = "100011" else
      -- SW
      "000000000110" when instruction(31 downto 26) = "101011" else
      -- ANDI D, R, R
      "000000010011" when instruction(31 downto 26) = "001100" else
      -- ORI D, R, R
      "000000011011" when instruction(31 downto 26) = "001101" else
      -- BEQ D
      "001000001000" when instruction(31 downto 26) = "000100" else
      -- BNEQ D
      "001000110010" when instruction(31 downto 26) = "000101" else
      -- SLTI D
      "000001001011" when instruction(31 downto 26) = "001010" else
      -- J D
      "010000000000" when instruction(31 downto 26) = "000010" else
      (others =>'0');
  
  RegDst   <= data(11);
  Jump     <= data(10);
  Branch   <= data(9) AND (ZeroCarry XOR instruction(26));
  MemRead  <= data(8);
  MemToReg <= data(7);
  ALUOp    <= data(6 downto 3);  
  MemWrite <= data(2);
  ALUSrc   <= data(1);
  RegWrite <= data(0);



end Behavioral;