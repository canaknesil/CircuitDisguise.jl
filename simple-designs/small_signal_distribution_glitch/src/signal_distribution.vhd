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
use IEEE.STD_LOGIC_MISC.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;


entity signal_distribution is
    port(x: in std_logic;
         q: out std_logic);
end signal_distribution;

architecture Behavioral of signal_distribution is

constant M: integer := 3;
constant N: integer := 3;

signal a1, a2: std_logic_vector(0 to M-1);
signal b1, b2: std_logic_vector(0 to (M*N)-1);

attribute dont_touch: string;
attribute dont_touch of a2, b2: signal is "true";

begin

a1 <= (others => x);

GEN_1: for i in 0 to M-1 generate
    LUT1_inst : LUT1 generic map (
        INIT => "01"
    ) port map (
        O => a2(i),   -- LUT general output
        I0 => a1(i)   -- LUT input
    );
    b1(N*i to N*(i+1)-1) <= (others => a2(i));
    GEN_2: for j in 0 to N-1 generate
        LUT1_inst : LUT1 generic map (
            INIT => "01"
        ) port map (
            O => b2(N*i + j),   -- LUT general output
            I0 => b1(N*i + j)   -- LUT input
        );
    end generate;
end generate;

q <= xor_reduce(b2);

end Behavioral;
