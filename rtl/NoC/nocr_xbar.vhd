library ieee;
use ieee.std_logic_1164.all;

entity nocr_xbar is

  port (
    data_in0 : in std_logic_vector(33 downto 0);  -- Data from inport 0
    dir_in0  : in std_logic_vector(1 downto 0);   -- Direction from inport 0

    data_in1 : in std_logic_vector(33 downto 0);  -- Data from inport 1
    dir_in1  : in std_logic_vector(1 downto 0);   -- Direction from inport 1

    data_in2 : in std_logic_vector(33 downto 0);  -- Data from inport 2
    dir_in2  : in std_logic_vector(1 downto 0);   -- Direction from inport 2

    data_in3 : in std_logic_vector(33 downto 0);  -- Data from inport 3
    dir_in3  : in std_logic_vector(1 downto 0);   -- Direction from inport 3

    data_in4 : in std_logic_vector(33 downto 0);  -- Data from inport 4
    dir_in4  : in std_logic_vector(1 downto 0);   -- Direction from inport 4

    data_out0 : out std_logic_vector(33 downto 0);  -- Data to outport 0
    dir_out0  : in  std_logic_vector(1 downto 0);  -- Direction from outport 0

    data_out1 : out std_logic_vector(33 downto 0);  -- Data to outport 1
    dir_out1  : in  std_logic_vector(1 downto 0);  -- Direction from outport 1

    data_out2 : out std_logic_vector(33 downto 0);  -- Data to outport 2
    dir_out2  : in  std_logic_vector(1 downto 0);  -- Direction from outport 2

    data_out3 : out std_logic_vector(33 downto 0);  -- Data to outport 3
    dir_out3  : in  std_logic_vector(1 downto 0);  -- Direction from outport 3

    data_out4 : out std_logic_vector(33 downto 0);  -- Data to outport 4
    dir_out4  : in  std_logic_vector(1 downto 0));  -- Direction from outport 4

end nocr_xbar;

architecture rtl of nocr_xbar is

  signal data_0_1, data_0_2, data_0_3, data_0_4 : std_logic_vector(33 downto 0);
  signal data_1_0, data_1_2, data_1_3, data_1_4 : std_logic_vector(33 downto 0);
  signal data_2_1, data_2_0, data_2_3, data_2_4 : std_logic_vector(33 downto 0);
  signal data_3_1, data_3_2, data_3_0, data_3_4 : std_logic_vector(33 downto 0);
  signal data_4_1, data_4_2, data_4_3, data_4_0 : std_logic_vector(33 downto 0);

begin  -- rtl

  --u0 : ENTITY work.crossbar
  --  PORT MAP (
  --    data_in0  => data_in0,
  --    data_in1  => data_in1,
  --    data_in2  => data_in2,
  --    data_in3  => data_in3,
  --    data_in4  => data_in4,
  --    dir_in0   => dir_in0,
  --    dir_in1   => dir_in1,
  --    dir_in2   => dir_in2,
  --    dir_in3   => dir_in3,
  --    dir_in4   => dir_in4,
  --    data_out0 => data_out0,
  --    data_out1 => data_out1,
  --    data_out2 => data_out2,
  --    data_out3 => data_out3,
  --    data_out4 => data_out4,
  --    dir_out0  => dir_out0,
  --    dir_out1  => dir_out1,
  --    dir_out2  => dir_out2,
  --    dir_out3  => dir_out3,
  --    dir_out4  => dir_out4);

  D0 : process(dir_in4, data_in4)
  begin
    case dir_in4 is
      when "00" =>
        data_4_0 <= data_in4;
        data_4_1 <= (others => '0');
        data_4_2 <= (others => '0');
        data_4_3 <= (others => '0');
      when "01" =>
        data_4_0 <= (others => '0');
        data_4_1 <= data_in4;
        data_4_2 <= (others => '0');
        data_4_3 <= (others => '0');
      when "10" =>
        data_4_0 <= (others => '0');
        data_4_1 <= (others => '0');
        data_4_2 <= data_in4;
        data_4_3 <= (others => '0');
      when "11" =>
        data_4_0 <= (others => '0');
        data_4_1 <= (others => '0');
        data_4_2 <= (others => '0');
        data_4_3 <= data_in4;
      when others => null;
    end case;
  end process;

  D1 : process(dir_in0, data_in0)
  begin
    case dir_in0 is
      when "00" =>
        data_0_4 <= data_in0;
        data_0_1 <= (others => '0');
        data_0_2 <= (others => '0');
        data_0_3 <= (others => '0');
      when "01" =>
        data_0_4 <= (others => '0');
        data_0_1 <= data_in0;
        data_0_2 <= (others => '0');
        data_0_3 <= (others => '0');
      when "10" =>
        data_0_4 <= (others => '0');
        data_0_1 <= (others => '0');
        data_0_2 <= data_in0;
        data_0_3 <= (others => '0');
      when "11" =>
        data_0_4 <= (others => '0');
        data_0_1 <= (others => '0');
        data_0_2 <= (others => '0');
        data_0_3 <= data_in0;
      when others => null;
    end case;

  end process;

  D2 : process(dir_in1, data_in1)
  begin
    case dir_in1 is
      when "00" =>
        data_1_0 <= data_in1;
        data_1_4 <= (others => '0');
        data_1_2 <= (others => '0');
        data_1_3 <= (others => '0');
      when "01" =>
        data_1_0 <= (others => '0');
        data_1_4 <= data_in1;
        data_1_2 <= (others => '0');
        data_1_3 <= (others => '0');
      when "10" =>
        data_1_0 <= (others => '0');
        data_1_4 <= (others => '0');
        data_1_2 <= data_in1;
        data_1_3 <= (others => '0');
      when "11" =>
        data_1_0 <= (others => '0');
        data_1_4 <= (others => '0');
        data_1_2 <= (others => '0');
        data_1_3 <= data_in1;
      when others => null;
    end case;

  end process;
  D3 : process(dir_in2, data_in2)
  begin
    case dir_in2 is
      when "00" =>
        data_2_0 <= data_in2;
        data_2_1 <= (others => '0');
        data_2_4 <= (others => '0');
        data_2_3 <= (others => '0');
      when "01" =>
        data_2_0 <= (others => '0');
        data_2_1 <= data_in2;
        data_2_4 <= (others => '0');
        data_2_3 <= (others => '0');
      when "10" =>
        data_2_0 <= (others => '0');
        data_2_1 <= (others => '0');
        data_2_4 <= data_in2;
        data_2_3 <= (others => '0');
      when "11" =>
        data_2_0 <= (others => '0');
        data_2_1 <= (others => '0');
        data_2_4 <= (others => '0');
        data_2_3 <= data_in2;
      when others => null;
    end case;

  end process;
  D4 : process(dir_in3, data_in3)
  begin
    case dir_in3 is
      when "00" =>
        data_3_0 <= data_in3;
        data_3_1 <= (others => '0');
        data_3_2 <= (others => '0');
        data_3_4 <= (others => '0');
      when "01" =>
        data_3_0 <= (others => '0');
        data_3_1 <= data_in3;
        data_3_2 <= (others => '0');
        data_3_4 <= (others => '0');
      when "10" =>
        data_3_0 <= (others => '0');
        data_3_1 <= (others => '0');
        data_3_2 <= data_in3;
        data_3_4 <= (others => '0');
      when "11" =>
        data_3_0 <= (others => '0');
        data_3_1 <= (others => '0');
        data_3_2 <= (others => '0');
        data_3_4 <= data_in3;
      when others => null;
    end case;
  end process;

  M0 : process(dir_out4, data_0_4, data_1_4, data_2_4, data_3_4)
  begin
    case dir_out4 is
      when "00" =>
        data_out4 <= data_0_4;
      when "01" =>
        data_out4 <= data_1_4;
      when "10" =>
        data_out4 <= data_2_4;
      when "11" =>
        data_out4 <= data_3_4;
      when others => null;
    end case;
  end process;

  M1 : process(dir_out0, data_4_0, data_1_0, data_2_0, data_3_0)
  begin
    case dir_out0 is
      when "00" =>
        data_out0 <= data_4_0;
      when "01" =>
        data_out0 <= data_1_0;
      when "10" =>
        data_out0 <= data_2_0;
      when "11" =>
        data_out0 <= data_3_0;
      when others => null;
    end case;
  end process;

  M2 : process(dir_out1, data_0_1, data_4_1, data_2_1, data_3_1)
  begin
    case dir_out1 is
      when "00" =>
        data_out1 <= data_0_1;
      when "01" =>
        data_out1 <= data_4_1;
      when "10" =>
        data_out1 <= data_2_1;
      when "11" =>
        data_out1 <= data_3_1;
      when others => null;
    end case;
  end process;

  M3 : process(dir_out2, data_0_2, data_1_2, data_4_2, data_3_2)
  begin
    case dir_out2 is
      when "00" =>
        data_out2 <= data_0_2;
      when "01" =>
        data_out2 <= data_1_2;
      when "10" =>
        data_out2 <= data_4_2;
      when "11" =>
        data_out2 <= data_3_2;
      when others => null;
    end case;
  end process;

  M4 : process(dir_out3, data_0_3, data_1_3, data_2_3, data_4_3)
  begin
    case dir_out3 is
      when "00" =>
        data_out3 <= data_0_3;
      when "01" =>
        data_out3 <= data_1_3;
      when "10" =>
        data_out3 <= data_2_3;
      when "11" =>
        data_out3 <= data_4_3;
      when others => null;
    end case;
  end process;


end rtl;
