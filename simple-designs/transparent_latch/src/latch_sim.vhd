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

entity latch_sim is
end latch_sim;

architecture Behavioral of latch_sim is

component latch is
    port(en: in std_logic;
         D: in std_logic;
         Q: out std_logic);
end component;

signal en, D, Q: std_logic;

begin

DUT: latch port map(
    en => en,
    D => D,
    Q => Q
);

process
begin
    D <= '0';
    en <= '1';
    wait for 5ns;
    en <= '0';
    wait for 5ns;
    D <= '1';
    wait for 5ns;
    D <= '0';
    wait for 5ns;
    en <= '1';
    wait for 5ns;
    D <= '1';
    wait for 5ns;
    D <= '0';
    wait;
end process;

end Behavioral;
