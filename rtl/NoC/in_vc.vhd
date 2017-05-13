library ieee;
use ieee.std_logic_1164.all;

entity in_vc is

  port (
    clk               : in  std_logic;
    en                : in  std_logic;
    rst_n             : in  std_logic;
    data_net          : in  std_logic_vector(33 downto 0);
    en_store_data_net : in  std_logic_vector(1 downto 0);
    eop_reg           : out std_logic_vector(1 downto 0);
    data_out0         : out std_logic_vector(33 downto 0);
    data_out1         : out std_logic_vector(33 downto 0));

end in_vc;

architecture rtl of in_vc is

  signal data_out0_wire : std_logic_vector(33 downto 0);
  signal data_out1_wire : std_logic_vector(33 downto 0);

begin  -- rtl

  eop_reg(0) <= data_out0_wire(32);
  eop_reg(1) <= data_out1_wire(32);
  data_out0  <= data_out0_wire;
  data_out1  <= data_out1_wire;
  -- purpose: data was store when vc_sto_en = 1
  -- type   : sequential
  -- inputs : clk, rst_n, prc_dat
  -- outputs: dat_vc0, dat_vc1
  data : process (clk, rst_n)
  begin  -- PROCESS data
    if rst_n = '0' then                      -- asynchronous reset (active low)
      data_out0_wire <= (others => '0');
      data_out1_wire <= (others => '0');
    elsif clk'event and clk = '1' then       -- rising clock edge
      if en = '1' then
        if en_store_data_net = "01" then     -- one-hot "01"
          data_out0_wire <= data_net;
        elsif en_store_data_net = "10" then  -- one-hot "10"
          data_out1_wire <= data_net;
        end if;
      end if;
    end if;
  end process data;

--  -- purpose: Update dir bits
--  -- type   : sequential
--  -- inputs : clk, rst_n, prc_dir
--  -- outputs: dir_vc0, dir_vc1
--  dir : PROCESS (clk, rst_n)
--  BEGIN  -- PROCESS dir
--    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
--      dir_vc0 <= (OTHERS => '0');
--      dir_vc1 <= (OTHERS => '0');
--    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
--      IF prc_bop = '1' AND en = '1' THEN
--        IF vc_sto_en = "01" THEN        -- one-hot "01"
--          dir_vc0 <= prc_dir;
--        ELSIF vc_sto_en = "10" THEN     -- one-hot "10"
--          dir_vc1 <= prc_dir;
--        END IF;
--      END IF;
--    END IF;
--  END PROCESS dir;
--
end rtl;
