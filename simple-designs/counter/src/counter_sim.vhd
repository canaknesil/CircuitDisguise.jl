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

entity counter_sim is
end counter_sim;

architecture Behavioral of counter_sim is

component counter is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           q : out STD_LOGIC);
end component;

signal reset, clk: std_logic := '0';
signal q: std_logic;

begin

DUT: counter port map(
    reset => reset,
    clk => clk,
    q => q
);

process
begin
    wait for 5ns;
    clk <= not clk;
end process;

process
begin
    reset <= '1';
    wait for 7ns;
    reset <= '0';
    wait;
end process;

end Behavioral;
