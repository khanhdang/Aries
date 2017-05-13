library ieee;
use ieee.std_logic_1164.all;

entity sislab_nocr_inport is

  port (
    clk       : in  std_logic;          -- System clock
    en        : in  std_logic;          -- System enable signal
    rst_n     : in  std_logic;  -- System asynchronous reset, active low
    data_in   : in  std_logic_vector(33 downto 0);  -- Data in from previous router/IP.
    send_in   : in  std_logic_vector(1 downto 0);  -- send in from previous router/IP.
    accept_in : out std_logic_vector(1 downto 0);  -- accept in to previous router/IP.

    accept_out0 : in std_logic_vector(1 downto 0);  -- accept out from outport 0
    accept_out1 : in std_logic_vector(1 downto 0);  -- accept out from outport 1
    accept_out2 : in std_logic_vector(1 downto 0);  -- accept out from outport 2
    accept_out3 : in std_logic_vector(1 downto 0);  -- accept out from outport 3

    send_out0 : out std_logic_vector(1 downto 0);  -- send out to outport 0
    send_out1 : out std_logic_vector(1 downto 0);  -- send out to outport 1
    send_out2 : out std_logic_vector(1 downto 0);  -- send out to outport 2
    send_out3 : out std_logic_vector(1 downto 0);  -- send out to outport 3

    lock_out0 : out std_logic_vector(1 downto 0);  -- Lock out to outport 0
    lock_out1 : out std_logic_vector(1 downto 0);  -- Lock out to outport 1
    lock_out2 : out std_logic_vector(1 downto 0);  -- Lock out to outport 2
    lock_out3 : out std_logic_vector(1 downto 0);  -- Lock out to outport 3

    data_out0 : out std_logic_vector(33 downto 0);  -- Data out to crossbar 0
    dir_out0  : out std_logic_vector(1 downto 0);  -- Select outport send to crossbar 0
    data_out1 : out std_logic_vector(33 downto 0);  -- Data out to crossbar 1
    dir_out1  : out std_logic_vector(1 downto 0));  -- Select outport send to crossbar 1

end sislab_nocr_inport;

architecture rtl of sislab_nocr_inport is

  signal en_store_data_net : std_logic_vector(1 downto 0);
  signal data_net          : std_logic_vector(33 downto 0);
  signal dir_net           : std_logic_vector(1 downto 0);
  signal bop_net           : std_logic;
  signal eop_net           : std_logic;
  signal eop_reg           : std_logic_vector(1 downto 0);

  signal dir_out0_temp : std_logic_vector(1 downto 0);
  signal dir_out1_temp : std_logic_vector(1 downto 0);
  signal send_out      : std_logic_vector(1 downto 0);
  signal accept_out    : std_logic_vector(1 downto 0);
  signal lock_out      : std_logic_vector(1 downto 0);

  component sislab_in_arb
    port (
      clk               : in  std_logic;
      en                : in  std_logic;
      rst_n             : in  std_logic;
      send_in           : in  std_logic_vector(1 downto 0);
      accept_out        : in  std_logic_vector(1 downto 0);
      bop_net           : in  std_logic;
      eop_net           : in  std_logic;
      eop_reg           : in  std_logic_vector(1 downto 0);
      dir_net           : in  std_logic_vector(1 downto 0);
      dir_out0          : out std_logic_vector(1 downto 0);
      dir_out1          : out std_logic_vector(1 downto 0);
      lock              : out std_logic_vector(1 downto 0);
      en_store_data_net : out std_logic_vector(1 downto 0);
      send_out          : out std_logic_vector(1 downto 0);
      accept_in         : out std_logic_vector(1 downto 0));

  end component;

  component sislab_in_vc

    port (
      clk               : in  std_logic;
      en                : in  std_logic;
      rst_n             : in  std_logic;
      data_net          : in  std_logic_vector(33 downto 0);
      en_store_data_net : in  std_logic_vector(1 downto 0);
      eop_reg           : out std_logic_vector(1 downto 0);
      data_out0         : out std_logic_vector(33 downto 0);
      data_out1         : out std_logic_vector(33 downto 0));

  end component;

  component sislab_in_preprc
    port (
      data_in  : in  std_logic_vector(33 downto 0);
      data_net : out std_logic_vector(33 downto 0);
      dir_net  : out std_logic_vector(1 downto 0);
      bop_net  : out std_logic;
      eop_net  : out std_logic);
  end component;

begin  -- rtl

  dir_out0 <= dir_out0_temp;
  dir_out1 <= dir_out1_temp;



  sislab_in_arb_inst : sislab_in_arb
    
    port map (
      clk               => clk,
      en                => en,
      rst_n             => rst_n,
      send_in           => send_in,
      accept_out        => accept_out,
      en_store_data_net => en_store_data_net,
      bop_net           => bop_net,
      eop_net           => eop_net,
      eop_reg           => eop_reg,
      dir_net           => dir_net,
      dir_out0          => dir_out0_temp,
      dir_out1          => dir_out1_temp,
      lock              => lock_out,
      send_out          => send_out,
      accept_in         => accept_in);

  sislab_in_vc_inst : sislab_in_vc
    
    port map (
      clk               => clk,
      en                => en,
      rst_n             => rst_n,
      data_net          => data_net,
      en_store_data_net => en_store_data_net,
      eop_reg           => eop_reg,
      data_out0         => data_out0,
      data_out1         => data_out1);

  sislab_in_preprc_inst : sislab_in_preprc
    
    port map (
      data_in  => data_in,
      data_net => data_net,
      dir_net  => dir_net,
      eop_net  => eop_net,
      bop_net  => bop_net);

  -- purpose: demux to route send signal
  -- type   : combinational
  -- outputs: 
  handshake_vc0 : process (lock_out(0), send_out(0), dir_out0_temp, accept_out0(0), accept_out1(0), accept_out2(0), accept_out3(0))
  begin  -- PROCESS handshake_vc0
    case dir_out0_temp is
      when "00" =>
        send_out0(0)  <= send_out(0);
        send_out1(0)  <= '0';
        send_out2(0)  <= '0';
        send_out3(0)  <= '0';
        lock_out0(0)  <= lock_out(0);
        lock_out1(0)  <= '0';
        lock_out2(0)  <= '0';
        lock_out3(0)  <= '0';
        accept_out(0) <= accept_out0(0);
      when "01" =>
        send_out1(0)  <= send_out(0);
        send_out0(0)  <= '0';
        send_out2(0)  <= '0';
        send_out3(0)  <= '0';
        lock_out1(0)  <= lock_out(0);
        lock_out0(0)  <= '0';
        lock_out2(0)  <= '0';
        lock_out3(0)  <= '0';
        accept_out(0) <= accept_out1(0);
      when "10" =>
        send_out2(0)  <= send_out(0);
        send_out0(0)  <= '0';
        send_out1(0)  <= '0';
        send_out3(0)  <= '0';
        lock_out2(0)  <= lock_out(0);
        lock_out0(0)  <= '0';
        lock_out1(0)  <= '0';
        lock_out3(0)  <= '0';
        accept_out(0) <= accept_out2(0);
      when "11" =>
        send_out3(0)  <= send_out(0);
        send_out0(0)  <= '0';
        send_out1(0)  <= '0';
        send_out2(0)  <= '0';
        lock_out3(0)  <= lock_out(0);
        lock_out0(0)  <= '0';
        lock_out1(0)  <= '0';
        lock_out2(0)  <= '0';
        accept_out(0) <= accept_out3(0);
      when others =>
        send_out0(0)  <= '0';
        send_out1(0)  <= '0';
        send_out2(0)  <= '0';
        send_out3(0)  <= '0';
        lock_out0(0)  <= '0';
        lock_out1(0)  <= '0';
        lock_out2(0)  <= '0';
        lock_out3(0)  <= '0';
        accept_out(0) <= '0';
    end case;
  end process handshake_vc0;


  -- purpose: demux to route send signal
  -- type   : combinational
  -- outputs: 
  handshake_vc1 : process (lock_out(1), send_out(1), dir_out1_temp , accept_out0(1), accept_out1(1), accept_out2(1), accept_out3(1))
  begin  -- PROCESS handshake_vc1
    case dir_out1_temp is
      when "00" =>
        send_out0(1)  <= send_out(1);
        send_out1(1)  <= '0';
        send_out2(1)  <= '0';
        send_out3(1)  <= '0';
        lock_out0(1)  <= lock_out(1);
        lock_out1(1)  <= '0';
        lock_out2(1)  <= '0';
        lock_out3(1)  <= '0';
        accept_out(1) <= accept_out0(1);
      when "01" =>
        send_out1(1)  <= send_out(1);
        send_out0(1)  <= '0';
        send_out2(1)  <= '0';
        send_out3(1)  <= '0';
        lock_out1(1)  <= lock_out(1);
        lock_out0(1)  <= '0';
        lock_out2(1)  <= '0';
        lock_out3(1)  <= '0';
        accept_out(1) <= accept_out1(1);
      when "10" =>
        send_out2(1)  <= send_out(1);
        send_out0(1)  <= '0';
        send_out1(1)  <= '0';
        send_out3(1)  <= '0';
        lock_out2(1)  <= lock_out(1);
        lock_out0(1)  <= '0';
        lock_out1(1)  <= '0';
        lock_out3(1)  <= '0';
        accept_out(1) <= accept_out2(1);
      when "11" =>
        send_out3(1)  <= send_out(1);
        send_out0(1)  <= '0';
        send_out1(1)  <= '0';
        send_out2(1)  <= '0';
        lock_out3(1)  <= lock_out(1);
        lock_out0(1)  <= '0';
        lock_out1(1)  <= '0';
        lock_out2(1)  <= '0';
        accept_out(1) <= accept_out3(1);
      when others =>
        send_out0(1)  <= '0';
        send_out1(1)  <= '0';
        send_out2(1)  <= '0';
        send_out3(1)  <= '0';
        lock_out0(1)  <= '0';
        lock_out1(1)  <= '0';
        lock_out2(1)  <= '0';
        lock_out3(1)  <= '0';
        accept_out(1) <= '0';
    end case;
  end process handshake_vc1;

end rtl;
