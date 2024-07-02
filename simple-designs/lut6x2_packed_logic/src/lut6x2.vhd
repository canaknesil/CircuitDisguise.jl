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
library UNISIM;
use UNISIM.VComponents.all;

entity lut6x2 is
    port(a1: in std_logic;
         a2: in std_logic;
         a3: in std_logic;
         b1: in std_logic;
         b2: in std_logic;
         q1: out std_logic;
         q2: out std_logic);
end lut6x2;

architecture Behavioral of lut6x2 is

begin

--q1 <= a1 xor a2 xor a3;
--q2 <= b1 xor b2;

LUT6_2_inst : LUT6_2
generic map (
   INIT => b"0110_1001_0110_1001_0110_1001_0110_1001_0000_0000_1111_1111_1111_1111_0000_0000")
port map (
   O6 => q2,
   O5 => q1,
   I0 => a1,
   I1 => a2,
   I2 => a3,
   I3 => b1,
   I4 => b2,
   I5 => '1'
);

end Behavioral;
