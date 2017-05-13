library ieee;
use ieee.std_logic_1164.all;

entity sislab_out_arb is
  
  port (
    clk      : in  std_logic;                     -- System clock
    rst_n    : in  std_logic;                     -- Reset, negative active
    en       : in  std_logic;                     -- Enable
    send_in0 : in  std_logic_vector(1 downto 0);  -- send signal from port 0
    send_in1 : in  std_logic_vector(1 downto 0);  -- send signal from port 1
    send_in2 : in  std_logic_vector(1 downto 0);  -- send signal from port 2
    send_in3 : in  std_logic_vector(1 downto 0);  -- send signal from port 3
    lock_in0 : in  std_logic_vector(1 downto 0);  -- lock signal from port 0
    lock_in1 : in  std_logic_vector(1 downto 0);  -- lock signal from port 1
    lock_in2 : in  std_logic_vector(1 downto 0);  -- lock signal from port 2
    lock_in3 : in  std_logic_vector(1 downto 0);  -- lock signal from port 3
    vc_in    : out std_logic_vector(1 downto 0);  -- choose VC signal, onehot
    dir_in   : out std_logic_vector(1 downto 0)   -- direction of input
    );


end sislab_out_arb;

architecture rtl of sislab_out_arb is

--  SIGNAL mask_off0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
--  SIGNAL mask_off1 : STD_LOGIC_VECTOR(3 DOWNTO 0);

  signal send_net0 : std_logic_vector(3 downto 0);
  signal send_net1 : std_logic_vector(3 downto 0);

  signal has_rq0 : std_logic;
  signal has_rq1 : std_logic;
--  SIGNAL has_rq  : STD_LOGIC;

  signal dir_in0    : std_logic_vector(1 downto 0);
  signal dir_in1    : std_logic_vector(1 downto 0);
  signal dir_in_net : std_logic_vector(1 downto 0);
  signal vc_in_net  : std_logic_vector(1 downto 0);
  signal dir_in_ff  : std_logic_vector(1 downto 0);
  signal vc_in_ff   : std_logic_vector(1 downto 0);
  signal lock_in    : std_logic;
  
begin  -- rtl

  send_net0(0) <= send_in0(0);
  send_net0(1) <= send_in1(0);
  send_net0(2) <= send_in2(0);
  send_net0(3) <= send_in3(0);

  send_net1(0) <= send_in0(1);
  send_net1(1) <= send_in1(1);
  send_net1(2) <= send_in2(1);
  send_net1(3) <= send_in3(1);

  encode_vc0 : process (send_net0)
  begin  -- PROCESS encode_vc0
    if send_net0(0) = '1' then
      dir_in0 <= "00";
    elsif send_net0(1) = '1' then
      dir_in0 <= "01";
    elsif send_net0(2) = '1' then
      dir_in0 <= "10";
    elsif send_net0(3) = '1' then
      dir_in0 <= "11";
    else
      dir_in0 <= "00";
    end if;
  end process encode_vc0;
  has_rq0 <= (send_net0(0) or send_net0(1) or send_net0(2) or send_net0(3));

  encode_vc1 : process (send_net1)
  begin  -- PROCESS encode_vc1
    if send_net1(0) = '1' then
      dir_in1 <= "00";
    elsif send_net1(1) = '1' then
      dir_in1 <= "01";
    elsif send_net1(2) = '1' then
      dir_in1 <= "10";
    elsif send_net1(3) = '1' then
      dir_in1 <= "11";
    else
      dir_in1 <= "00";
    end if;
  end process encode_vc1;
  has_rq1 <= (send_net1(0) or send_net1(1) or send_net1(2) or send_net1(3));

  choose_dir_in : process (dir_in0, dir_in1, has_rq0, has_rq1)
  begin  -- PROCESS choose_dir_in
    if has_rq0 = '1' then
      dir_in_net <= dir_in0;
--      has_rq     <= '1';
      vc_in_net  <= "01";
    elsif has_rq1 = '1' then
      dir_in_net <= dir_in1;
--      has_rq     <= '1';
      vc_in_net  <= "10";
    else
      dir_in_net <= "00";
--      has_rq     <= '0';
      vc_in_net  <= "00";
    end if;
  end process choose_dir_in;

  -- purpose: rst_n
  -- type   : sequential
  -- inputs : clk, rst_n
  -- outputs: 
  store_routing_value : process (clk, rst_n)
  begin  -- PROCESS store_routing_value
    if rst_n = '0' then                 -- asynchronous reset (active low)
      dir_in_ff <= "00";
      vc_in_ff  <= "00";
    elsif clk'event and clk = '1' then  -- rising clock edge
      if lock_in = '0' and en = '1' then
        dir_in_ff <= dir_in_net;
        vc_in_ff  <= vc_in_net;
      end if;
    end if;
  end process store_routing_value;

  process (lock_in0, lock_in1, lock_in2, lock_in3, vc_in_ff, dir_in_ff)
  begin  -- PROCESS
    case vc_in_ff is
      when "01" =>
        case dir_in_ff is
          when "00"   => lock_in <= lock_in0(0);
          when "01"   => lock_in <= lock_in1(0);
          when "10"   => lock_in <= lock_in2(0);
          when "11"   => lock_in <= lock_in3(0);
          when others => lock_in <= '0';
        end case;
      when "10" =>
        case dir_in_ff is
          when "00"   => lock_in <= lock_in0(1);
          when "01"   => lock_in <= lock_in1(1);
          when "10"   => lock_in <= lock_in2(1);
          when "11"   => lock_in <= lock_in3(1);
          when others => lock_in <= '0';
        end case;
      when others => lock_in <= '0';
    end case;
  end process;

  select_routing : process (lock_in, dir_in_net, vc_in_net, dir_in_ff, vc_in_ff)
  begin  -- PROCESS select_routing
    if lock_in = '1' then
      dir_in <= dir_in_ff;
      vc_in  <= vc_in_ff;
    else
      dir_in <= dir_in_net;
      vc_in  <= vc_in_net;
    end if;
  end process select_routing;
  
end rtl;
