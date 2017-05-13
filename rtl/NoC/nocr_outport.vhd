library ieee;
use ieee.std_logic_1164.all;

entity nocr_outport is

  port (
    clk   : in std_logic;               -- System clock
    en    : in std_logic;               -- System Enable
    rst_n : in std_logic;               -- System reset, active low

    send_in0 : in std_logic_vector(1 downto 0);  -- send signal from port 0
    send_in1 : in std_logic_vector(1 downto 0);  -- send signal from port 1
    send_in2 : in std_logic_vector(1 downto 0);  -- send signal from port 2
    send_in3 : in std_logic_vector(1 downto 0);  -- send signal from port 3

    lock_in0 : in std_logic_vector(1 downto 0);  -- Lock send signal from port 0
    lock_in1 : in std_logic_vector(1 downto 0);  -- Lock send signal from port 1
    lock_in2 : in std_logic_vector(1 downto 0);  -- Lock send signal from port 2
    lock_in3 : in std_logic_vector(1 downto 0);  -- Lock send signal from port 3

    data_in0 : in std_logic_vector(33 downto 0);  -- Data_in from crossbar 0
    data_in1 : in std_logic_vector(33 downto 0);  -- data_in from crossbar 1

    accept_in0 : out std_logic_vector(1 downto 0);  -- accept signal to port 0
    accept_in1 : out std_logic_vector(1 downto 0);  -- accept signal to port 1
    accept_in2 : out std_logic_vector(1 downto 0);  -- accept signal to port 2
    accept_in3 : out std_logic_vector(1 downto 0);  -- accept signal to port 3

    dir_in0 : out std_logic_vector(1 downto 0);  -- Direction select to crossbar 0
    dir_in1 : out std_logic_vector(1 downto 0);  -- Direction select to crossbar 1

    data_out   : out std_logic_vector(33 downto 0);  -- Data out to next router/IP.
    send_out   : out std_logic_vector(1 downto 0);  -- send out to next router/IP.
    accept_out : in  std_logic_vector(1 downto 0)  -- send out to next router/IP.
    );

end nocr_outport;

architecture rtl of nocr_outport is
  component out_arb is
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

  end component;

  component out_vc is
    port (
      vc_in  : in std_logic_vector(1 downto 0);  -- Select virtual channel
      dir_in : in std_logic_vector(1 downto 0);  -- Select direction of data

      data_in0 : in std_logic_vector(33 downto 0);  -- Data from crossbar vc0 to outport
      data_in1 : in std_logic_vector(33 downto 0);  -- Data from crossbar vc1 to outport

      send_in0 : in std_logic_vector(1 downto 0);  -- send  from port 0
      send_in1 : in std_logic_vector(1 downto 0);  -- send from port 1
      send_in2 : in std_logic_vector(1 downto 0);  -- send from port 2
      send_in3 : in std_logic_vector(1 downto 0);  -- send from port 3

      accept_in0 : out std_logic_vector(1 downto 0);  -- accept to port 0
      accept_in1 : out std_logic_vector(1 downto 0);  -- accept to port 1
      accept_in2 : out std_logic_vector(1 downto 0);  -- accept to port 2
      accept_in3 : out std_logic_vector(1 downto 0);  -- accept to port 3

      dir_in0 : out std_logic_vector(1 downto 0);  -- Direct for virtual channel 0 crossbar
      dir_in1 : out std_logic_vector(1 downto 0);  -- Direct for virtual channel 1 crossbar

      data_out   : out std_logic_vector(33 downto 0);  -- Data out (to next router/IP)
      send_out   : out std_logic_vector(1 downto 0);  -- send out (handshake signal)
      accept_out : in  std_logic_vector(1 downto 0)  -- accept out (handshake signal)
      );
  end component;

  signal vc_in  : std_logic_vector(1 downto 0);
  signal dir_in : std_logic_vector(1 downto 0);


begin

  out_arb_inst : out_arb
    port map(
      clk   => clk,
      en    => en,
      rst_n => rst_n,

      send_in0 => send_in0,
      send_in1 => send_in1,
      send_in2 => send_in2,
      send_in3 => send_in3,

      lock_in0 => lock_in0,
      lock_in1 => lock_in1,
      lock_in2 => lock_in2,
      lock_in3 => lock_in3,

      vc_in  => vc_in,
      dir_in => dir_in
      );
  out_vc_inst : out_vc
    port map(
      vc_in  => vc_in,
      dir_in => dir_in,

      data_in0 => data_in0,
      data_in1 => data_in1,

      send_in0 => send_in0,
      send_in1 => send_in1,
      send_in2 => send_in2,
      send_in3 => send_in3,

      accept_in0 => accept_in0,
      accept_in1 => accept_in1,
      accept_in2 => accept_in2,
      accept_in3 => accept_in3,

      dir_in0 => dir_in0,
      dir_in1 => dir_in1,

      data_out   => data_out,
      send_out   => send_out,
      accept_out => accept_out
      );

end rtl;

