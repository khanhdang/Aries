library ieee;
use ieee.std_logic_1164.all;

entity sislab_in_preprc is

  port (
    data_in  : in  std_logic_vector(33 downto 0);
    data_net : out std_logic_vector(33 downto 0);
    dir_net  : out std_logic_vector(1 downto 0);
    bop_net  : out std_logic;
    eop_net  : out std_logic);

end sislab_in_preprc;

architecture rtl of sislab_in_preprc is

begin  -- rtl
  -- purpose: base on BOP we shift bit in header flit and output dir bits
  -- type   : combinational
  -- inputs : data_in
  -- outputs: data_net, dir_net, bop_net
  sislab_in_preprc : process (data_in)
  begin  -- PROCESS sislab_in_preprc
    case data_in(33) is
      when '1' =>
        data_net(33 downto 18) <= data_in(33 downto 18);
        data_net(17 downto 16) <= "00";
        bop_net                <= data_in(33);
        dir_net(1 downto 0)    <= data_in(1 downto 0);
        eop_net                <= data_in(32);
        data_net(15 downto 0)  <= data_in(17 downto 2);
      when '0' =>
        data_net <= data_in;
        dir_net  <= "00";
        bop_net  <= '0';
        eop_net  <= '0';
      when others => null;
    end case;
  end process sislab_in_preprc;

end rtl;
