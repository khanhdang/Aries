library ieee;
use ieee.std_logic_1164.all;

entity sislab_in_arb is
  
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

end sislab_in_arb;

architecture rtl of sislab_in_arb is

  signal wire_push      : std_logic_vector(1 downto 0);
  signal wire_pop       : std_logic_vector(1 downto 0);
  signal buffer_state   : std_logic_vector(1 downto 0);
  signal wire_accept_in : std_logic_vector(1 downto 0);
  signal wire_send_out  : std_logic_vector(1 downto 0);
  
begin  -- rtl
  wire_accept_in    <= not buffer_state;
  wire_send_out     <= buffer_state;
  accept_in         <= wire_accept_in;
  send_out          <= wire_send_out;
  wire_pop          <= accept_out and wire_send_out;
  wire_push         <= send_in and wire_accept_in;
  en_store_data_net <= wire_push;

  -- purpose: Update buffer state
  -- type   : sequential
  -- inputs : clk, rst_n, push, pop
  -- outputs: buffer_state
  sislab_buffer_state : process (clk, rst_n)
  begin  -- PROCESS sislab_buffer_state
    if rst_n = '0' then                 -- asynchronous reset (active low)
      buffer_state <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if en = '1' then
        for i in 1 downto 0 loop
          if wire_push(i) = '1' then
            buffer_state(i) <= '1';
          elsif wire_pop(i) = '1' then
            buffer_state(i) <= '0';
          end if;
        end loop;  -- i
      end if;
    end if;
  end process sislab_buffer_state;

  -- purpose: Update dir bits
  -- type   : sequential
  -- inputs : clk, rst_n, prc_dir
  -- outputs: dir_out0, dir_out1
  dir : process (clk, rst_n)
  begin  -- PROCESS dir
    if rst_n = '0' then                 -- asynchronous reset (active low)
      dir_out0 <= (others => '0');
      dir_out1 <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if bop_net = '1' and en = '1' then
        if wire_push = "01" then        -- one-hot "01"
          dir_out0 <= dir_net;
        elsif wire_pop = "10" then      -- one-hot "10"
          dir_out1 <= dir_net;
        end if;
      end if;
    end if;
  end process dir;

  -- purpose: lock signal
  -- type   : sequential
  -- inputs : clk, rst_n
  -- outputs: 
  lock_signal : process (clk, rst_n)
  begin  -- PROCESS lock
    if rst_n = '0' then                 -- asynchronous reset (active low)
      lock <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if(bop_net = '1' and eop_net = '0') then
        if wire_push = "01" then
          lock(0) <= '1';
        elsif wire_push = "10" then
          lock(1) <= '1';
        end if;
      end if;
      if eop_reg(0) = '1' and wire_pop(0) = '1' then
        lock(0) <= '0';
      elsif eop_reg(1) = '1' and wire_pop(1) = '1' then
        lock(1) <= '0';
      end if;
    end if;
  end process lock_signal;

end rtl;

