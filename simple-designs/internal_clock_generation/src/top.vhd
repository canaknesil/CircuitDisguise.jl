-- MIT License

-- Copyright (c) 2024 Can Aknesil

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port(clk: in std_logic;
         reset: in std_logic;
         q: out std_logic);
end top;

architecture Behavioral of top is

component clock_divider is
    generic(FACTOR: integer); -- only multiples of 2 are allowed
    Port ( reset : in STD_LOGIC;
           clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

signal clk2, a, b: std_logic;

begin

CD: clock_divider generic map(
    FACTOR => 4
) port map(
    reset => reset,
    clk_in => clk,
    clk_out => clk2
);

process(clk, a)
begin
    if (reset = '1') then
        a <= '0';
    elsif (rising_edge(clk)) then
        a <= not a;
    end if;
end process;

process(clk2, b)
begin
    if (reset = '1') then
        b <= '0';
    elsif (rising_edge(clk2)) then
        b <= not b;
    end if;
end process;

q <= a and b;        

end Behavioral;
