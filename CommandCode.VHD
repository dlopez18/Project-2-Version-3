library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CommandCode is
    GENERIC (n : integer := 32);
    Port( CLK, comreset_sig : in STD_LOGIC );
end CommandCode;

architecture Behavioral of CommandCode is

Component Control is
    Port( 
    instruction : in STD_LOGIC_VECTOR(31 downto 0);
    ZeroCarry   : in STD_LOGIC;
    
    --CONTROL
    RegDst      : out STD_LOGIC;
    Jump        : out STD_LOGIC;
    Branch      : out STD_LOGIC;
    MemRead     : out STD_LOGIC;
    MemtoReg    : out STD_LOGIC;
    ALUOp       : out STD_LOGIC_VECTOR (3 downto 0);
    MemWrite    : out STD_LOGIC;
    ALUSrc      : out STD_LOGIC;
    RegWrite    : out STD_LOGIC );
end component;

Component DataPath is
Port( 
    CLK, comreset_sig    : in STD_LOGIC;
    instruction       : in STD_LOGIC_VECTOR(31 downto 0);
    -- CONTROL
    RegDst            : in STD_LOGIC;
    Jump              : in STD_LOGIC;
    Branch            : in STD_LOGIC;
    MemRead           : in STD_LOGIC;
    MemToReg          : in STD_LOGIC;
    ALUOp             : in STD_LOGIC_VECTOR(3 downto 0);
    MemWrite          : in STD_LOGIC;
    ALUSrc            : in STD_LOGIC;
    RegWrite          : in STD_LOGIC;
    next_instruction  : out STD_LOGIC_VECTOR(31 downto 0);
    ZeroCarry         : out STD_LOGIC );
end component;

Component InstructionMem is
    Port(
    reg_addy : in  STD_LOGIC_VECTOR(31 downto 0);
    instr   : out STD_LOGIC_VECTOR(31 downto 0) );
end Component;

signal RegDst_TL, Jump_TL, Branch_TL, MemRead_TL, MemToReg_TL : STD_LOGIC;
signal MemWrite_TL, ALUSrc_TL, RegWrite_TL , ZeroCarry_TL : STD_LOGIC;
signal ALUOp_TL : STD_LOGIC_VECTOR(3 downto 0);
signal NextInstruction, instr : STD_LOGIC_VECTOR(31 downto 0);



begin

CU : Control  
    Port map( 
        instr,
        ZeroCarry_TL,
        RegDst_TL,
        Jump_TL,
        Branch_TL,
        MemRead_TL,
        MemToReg_TL,
        ALUOp_TL,
        MemWrite_TL,
        ALUSrc_TL,
        RegWrite_TL 
    );
    
DP : DataPath        
    Port Map( 
        CLK,
        comreset_sig,
        instr,
        RegDst_TL,
        Jump_TL,
        Branch_TL,
        MemRead_TL,
        MemToReg_TL,
        ALUOp_TL,
        MemWrite_TL,
        ALUSrc_TL,
        RegWrite_TL,
        NextInstruction,
        ZeroCarry_TL 
    );
    
    
I : InstructionMem  
    Port Map( 
        NextInstruction, 
        instr 
    );

end Behavioral;