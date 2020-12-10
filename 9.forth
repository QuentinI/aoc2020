create line 20 allot 
create numbers 1000 cells allot

: procfile { buff numbers file -- lines }
  0 begin
    buff 20 file read-line throw
  while
    line swap s>number? swap throw drop
    1 pick cells numbers + !
    1 +
  repeat
  drop 1 -
;

: notsum { num len slice -- ans }
  len 1 do
    i 0 do
      i cells slice + @
      j cells slice + @
      + num = if false unloop unloop exit then
    loop
  loop
  true
;

: findsum { len target buff -- x1 ... xn }
  len 0 do
    len i - 0 do
      0
      j 2 + 0 do
        i j + cells buff + @ dup rot +
      loop
      target = if unloop unloop exit then
      depth 0 do drop loop
    loop
  loop
;

: part1 { len preamble buff -- ans }
  1 len + preamble do
    i cells buff + @
    preamble buff i preamble - cells +
    notsum if i cells buff + @ unloop exit then
  loop
;

: part2 { len target buff -- ans }
  len target buff findsum dup
  depth 2 do
    2 pick 2dup < if swap then drop swap
    2 roll 2dup > if swap then drop swap
  loop
  +
;

S" 9.in" r/o open-file throw Value fd-in
line numbers fd-in procfile dup

25 numbers part1 dup . CR
numbers part2 . CR

bye
