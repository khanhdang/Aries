library ieee;
use ieee.std_logic_1164.all;

entity sislab_out_vc is
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
    dir_in0    : out std_logic_vector(1 downto 0);  -- Direct for virtual channel 0 crossbar
    dir_in1    : out std_logic_vector(1 downto 0);  -- Direct for virtual channel 1 crossbar

    data_out   : out std_logic_vector(33 downto 0);  -- Data out (to next router/IP)
    send_out   : out std_logic_vector(1 downto 0);  -- send out (handshake signal)
    accept_out : in  std_logic_vector(1 downto 0)  -- accept out (handshake signal)
    );
end sislab_out_vc;
architecture rtl of sislab_out_vc is

begin
  -- @brief: Select data_out from data_in_vc
  Select_data_out : process(vc_in, data_in0, data_in1)
  begin
    case vc_in is
      when "01"   => data_out <= data_in0;
      when "10"   => data_out <= data_in1;
      when others => data_out <= (others => '0');
    end case;
  end process;
  -- @brief: Select send_out from send_in
  Select_send_out : process(send_in0, send_in1, send_in2, send_in3, vc_in, dir_in)
  begin
    if vc_in = "01" then
      case dir_in is
        when "00"   => send_out(0) <= send_in0(0);
        when "01"   => send_out(0) <= send_in1(0);
        when "10"   => send_out(0) <= send_in2(0);
        when "11"   => send_out(0) <= send_in3(0);
        when others => send_out(0) <= '0';
      end case;
      send_out(1) <= '0';
    elsif vc_in = "10" then
      case dir_in is
        when "00"   => send_out(1) <= send_in0(1);
        when "01"   => send_out(1) <= send_in1(1);
        when "10"   => send_out(1) <= send_in2(1);
        when "11"   => send_out(1) <= send_in3(1);
        when others => send_out(1) <= '0';
      end case;
      send_out(0) <= '0';
    else
      send_out <= "00";
    end if;
  end process;

  -- @brief: Select accept_in from accept_out
  Select_accept_out : process(accept_out, vc_in, dir_in)
  begin
    if vc_in = "01" then
      case dir_in is
        when "00" =>
          accept_in0(0) <= accept_out(0);
          accept_in0(1) <= '0';
          accept_in1    <= "00";
          accept_in2    <= "00";
          accept_in3    <= "00";
        when "01" =>
          accept_in1(0) <= accept_out(0);
          accept_in1(1) <= '0';
          accept_in0    <= "00";
          accept_in2    <= "00";
          accept_in3    <= "00";
        when "10" =>
          accept_in2(0) <= accept_out(0);
          accept_in2(1) <= '0';
          accept_in0    <= "00";
          accept_in1    <= "00";
          accept_in3    <= "00";
        when "11" =>
          accept_in3(0) <= accept_out(0);
          accept_in3(1) <= '0';
          accept_in0    <= "00";
          accept_in1    <= "00";
          accept_in2    <= "00";
        when others =>
          accept_in0 <= "00";
          accept_in1 <= "00";
          accept_in2 <= "00";
          accept_in3 <= "00";
      end case;
    elsif vc_in = "10" then
      case dir_in is
        when "00" =>
          accept_in0(1) <= accept_out(1);
          accept_in0(0) <= '0';
          accept_in1    <= "00";
          accept_in2    <= "00";
          accept_in3    <= "00";
        when "01" =>
          accept_in1(1) <= accept_out(1);
          accept_in1(0) <= '0';
          accept_in0    <= "00";
          accept_in2    <= "00";
          accept_in3    <= "00";
        when "10" =>
          accept_in2(1) <= accept_out(1);
          accept_in2(0) <= '0';
          accept_in0    <= "00";
          accept_in1    <= "00";
          accept_in3    <= "00";
        when "11" =>
          accept_in3(1) <= accept_out(1);
          accept_in3(0) <= '0';
          accept_in0    <= "00";
          accept_in1    <= "00";
          accept_in2    <= "00";
        when others =>
          accept_in0 <= "00";
          accept_in1 <= "00";
          accept_in2 <= "00";
          accept_in3 <= "00";
      end case;
    else
      accept_in0 <= "00";
      accept_in1 <= "00";
      accept_in2 <= "00";
      accept_in3 <= "00";
    end if;
  end process;
  Select_dir_in : process(vc_in, dir_in)
  begin
    case vc_in is
      when "01" =>
        dir_in0 <= dir_in;
        dir_in1 <= "00";
      when "10" =>
        dir_in1 <= dir_in;
        dir_in0 <= "00";
      when others =>
        dir_in0 <= "00";
        dir_in1 <= "00";
    end case;
  end process;
end rtl;
