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
    port(a: in std_logic_vector(4 downto 0);
         q1: out std_logic;
         q2: out std_logic);
end lut6x2;

architecture Behavioral of lut6x2 is

begin

-- two 5-input logic functions with shared inputs
--q1 <= a(0) xor a(1) xor a(2) xor a(3) xor a(4)
--q2 <= not (a(0) xor a(1) xor a(2) xor a(3) xor a(4))

LUT6_2_inst : LUT6_2
generic map (
   INIT => x"6996_9669_9669_6996")
port map (
   O6 => q2,
   O5 => q1,
   I0 => a(0),
   I1 => a(1),
   I2 => a(2),
   I3 => a(3),
   I4 => a(4),
   I5 => '1'
);

end Behavioral;
