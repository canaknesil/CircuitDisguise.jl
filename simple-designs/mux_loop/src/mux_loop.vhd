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
Library UNISIM;
use UNISIM.vcomponents.all;

entity mux_loop is
    port(en: in std_logic;
         q: out std_logic);
end mux_loop;

architecture Behavioral of mux_loop is

signal a: std_logic;

begin

MUXF8_inst : MUXF8
port map (
   O => a,    -- Output of MUX to general routing
   I0 => en,  -- Input (tie to MUXF7 L/LO out)
   I1 => '0', -- Input (tie to MUXF7 L/LO out)
   S => a     -- Input select to MUX
);

q <= a;

end Behavioral;
