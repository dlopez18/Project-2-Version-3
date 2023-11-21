--Arithmetic logic unit
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    GENERIC(n : integer := 32);
    Port( input_value0   : in STD_LOGIC_VECTOR(n-1 downto 0);
        input_value1   : in STD_LOGIC_VECTOR(n-1 downto 0);
        controlsig : in STD_LOGIC_VECTOR(3 downto 0);  
    
        output      : out STD_LOGIC_VECTOR(n - 1 downto 0);
        zero        : out STD_LOGIC );
end ALU;

architecture Behavioral of ALU is
    signal inpute_sig : STD_LOGIC_VECTOR(n - 1 downto 0);
    
    begin --calculations set
          inpute_sig <=
            --ADD D, R, R
            STD_LOGIC_VECTOR(UNSIGNED(input_value0) + UNSIGNED(input_value1)) after 1 ns when controlsig = "0000" else
            --SUB D, R, R
            STD_LOGIC_VECTOR(UNSIGNED(input_value0) - UNSIGNED(input_value1)) after 1 ns when controlsig = "0001" else
            --AND D, R, R
            input_value0 AND  input_value1 after 1 ns when controlsig = "0010" else
            --OR D, R, R
            input_value0 OR   input_value1 after 1 ns when controlsig = "0011" else
            --NOR D, R, R
            input_value0 NOR  input_value1 after 1 ns when controlsig = "0100" else
            --NAND D, R, R X
            input_value0 NAND input_value1 after 1 ns when controlsig = "0101" else
            --XOR D, R, R 
            input_value0 XOR  input_value1 after 1 ns when controlsig = "0110" else
            --SLL D, R, SHFT
            STD_LOGIC_VECTOR(shift_left(UNSIGNED(input_value0), to_integer(UNSIGNED(input_value1(10 downto 6))))) after 1 ns when controlsig = "0111" else
            --SRL D, R, SHFT
            STD_LOGIC_VECTOR(shift_right(UNSIGNED(input_value0), to_integer(UNSIGNED(input_value1(10 downto 6))))) after 1 ns when controlsig = "1000" else
            --ELSE
            (others => '0');
        
                zero <= '1' when (inpute_sig <= "00000000000000000000000000000000") else '0';
                output <= inpute_sig;

end Behavioral;
