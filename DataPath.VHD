

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataPath is
    GENERIC(n : integer := 32);
    Port( 
        CLK, comreset_sig    : in std_logic;
        instruction       : in std_logic_vector(31 downto 0);
        -- CONTROL
        RegDst            : in std_logic;
        Jump              : in std_logic;
        Branch            : in std_logic;
        MemRead           : in std_logic;
        MemToReg          : in std_logic;
        ALUOp             : in std_logic_vector(3 downto 0);
        MemWrite          : in std_logic;
        ALUSrc            : in std_logic;
        RegWrite          : in std_logic;
        next_instruction  : out std_logic_vector(31 downto 0);
        ZeroCarry         : out std_logic );
end DataPath;

architecture Behavioral of DataPath is

--TWO SHIFT LEFT
    Component TwoShiftLeft is
        Port( 
            Shifty : in std_logic_vector(31 downto 0);
            output: out std_logic_vector(31 downto 0) );
    end Component;


--SIGN EXTENDER
    Component SignExtender is
        Port(
            value  : in std_logic_vector(15 downto 0);
            output : out std_logic_vector(31 downto 0) );
    end Component;


--MULTIPLEXER
    Component Multiplexer is
        Generic(n: integer);
        Port(
            muxy0    : in std_logic_vector(n-1 downto 0);
            muxy1    : in std_logic_vector(n-1 downto 0);
            mux_selector : in std_logic;
            output     : out std_logic_vector(n-1 downto 0));
    end Component;


--DATA MEMORY
    Component DataMem is
        Port (
            CLK            : in std_logic;
            comreset_sig      : in std_logic;
            memory_address : in std_logic_vector(n-1 downto 0);
            MemWrite       : in std_logic;
            MemRead        : in std_logic;
            value_input    : in std_logic_vector(n-1 downto 0);
            output         : out std_logic_vector(n-1 downto 0) );
        end component;

--REGISTERS
    Component RegisterFILE is
        Port( 
            CLK          : in std_logic;
            comreset_sig    : in std_logic;
            addy_0 : in std_logic_vector(4 downto 0);
            addy_1 : in std_logic_vector(4 downto 0);
            output  : in std_logic_vector(4 downto 0);
            write_data   : in std_logic_vector(n-1 downto 0);
            RegWrite     : in std_logic;  
    
            regi_0   : out std_logic_vector(n-1 downto 0);
            regi_1   : out std_logic_vector(n-1 downto 0) );
    end Component;

--PC
    Component ProgCounter is
        Port(
            CLK        : in  std_logic;
            comreset_sig  : in  std_logic;
            input      : in  std_logic_vector(31 downto 0);
            output     : out std_logic_vector(31 downto 0) );
    end Component;


--ADDER
    Component Adder is
      Port(
            value_0 : in  std_logic_vector(n - 1 downto 0);
            value_1 : in  std_logic_vector(n - 1 downto 0);
            output    : out std_logic_vector(n - 1 downto 0) );
    end Component;

--ALU
    Component ALU is
        port(
            input_value0   : in std_logic_vector(n - 1 downto 0);
            input_value1   : in std_logic_vector(n - 1 downto 0);
            controlsig : in std_logic_vector(3 downto 0);

            output      : out std_logic_vector(n - 1 downto 0);
            zero        : out std_logic );
    end Component;

constant PC_increment     : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
  signal PC_out             : std_logic_vector(31 downto 0);
  signal MuxToWriteRegister : std_logic_vector(4 downto 0);
  signal SignExtendToSLL    : std_logic_vector(31 downto 0);
  signal SLLToAdder         : std_logic_vector(31 downto 0);
  signal ReadData1ToALU     : std_logic_vector(n-1 downto 0);
  signal ReadData2ToMux     : std_logic_vector(n-1 downto 0);
  signal MuxToALU           : std_logic_vector(n-1 downto 0);
  signal ALUToDataMemory    : std_logic_vector(n-1 downto 0);
  signal DataMemoryToMux    : std_logic_vector(n-1 downto 0);
  signal MuxToWriteData     : std_logic_vector(n-1 downto 0);
  signal AdderToMux         : std_logic_vector(31 downto 0);
  signal MuxToMux           : std_logic_vector(31 downto 0);
  signal MuxToPC            : std_logic_vector(31 downto 0);
  signal Adder1ToMux        : std_logic_vector(31 downto 0);
  signal SLLToMux           : std_logic_vector(31 downto 0);
  signal SLLOut             : std_logic_vector(31 downto 0);
  signal ShiftJump          : std_logic_vector(31 downto 0);

begin

  SLLToMux  <= Adder1ToMux(31 downto 28) & SLLOut(27 downto 0);
  ShiftJump <= "000000" & instruction(25 downto 0);

  Memory        : DataMem        port map(CLK, comreset_sig, ALUToDataMemory, MemWrite, MemRead, ReadData2ToMux, DataMemoryToMux);
  ArithmeticLogicUnit    : ALU            port map(ReadData1ToALU, MuxToALU, ALUOp, ALUToDataMemory, ZeroCarry);
  MuxALU        : Multiplexer            generic map(32) port map(ReadData2ToMux, SignExtendToSLL, ALUSrc, MuxToALU);
  MuxReg        : Multiplexer            generic map(5)  port map(instruction(20 downto 16), instruction(15 downto 11), RegDst, MuxToWriteRegister);
  MuxMemory        : Multiplexer            generic map(32) port map(ALUToDataMemory, DataMemoryToMux, MemToReg, MuxToWriteData);
  MuxBranch     : Multiplexer            generic map(32) port map(Adder1ToMux, AdderToMux, Branch, MuxToMux);
  MuxJump       : Multiplexer            generic map(32) port map(MuxToMux, SLLToMux, Jump, MuxToPC);
  AdderProgCounter       : Adder          port map(PC_out, PC_increment, Adder1ToMux);
  AdderBranch   : Adder          port map(Adder1ToMux, SLLToAdder, AdderToMux);
  ShiftyJump   : TwoShiftLeft     port map(ShiftJump, SLLOut);
  ShiftyBranch : TwoShiftLeft     port map(SignExtendToSLL, SLLToAdder);
  ShiftExtend   : SignExtender     port map(instruction(15 downto 0), SignExtendToSLL);
  PC            : ProgCounter port map(CLK, comreset_sig, MuxToPC, PC_out);
  Registers    : RegisterFile      port map(CLK, comreset_sig, instruction(25 downto 21), instruction(20 downto 16), MuxToWriteRegister, MuxToWriteData, RegWrite, ReadData1ToALU, ReadData2ToMux);

  next_instruction <= PC_out;



end Behavioral;