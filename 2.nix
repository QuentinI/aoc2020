let
  maxInt = 9223372036854775807;
  countChar = string: char:
    if builtins.stringLength string == 0 then
      0
    else if builtins.substring 0 1 string == char then
      1 + (countChar (builtins.substring 1 maxInt string) char)
    else
      countChar (builtins.substring 1 maxInt string) char;
  parseRecord = record:
    let
      fields = builtins.match "([[:digit:]]+)-([[:xdigit:]]+) ([[:alpha:]]): ([[:alpha:]]+)" record;
    in
      if fields == null then
       null
      else {
        start = builtins.fromJSON (builtins.elemAt fields 0);
        end   = builtins.fromJSON (builtins.elemAt fields 1);
        char  = builtins.elemAt fields 2;
        pass  = builtins.elemAt fields 3;
      };
  isValid = record: 
    let
      numChars = countChar record.pass record.char;
    in
      numChars >= record.start && numChars <= record.end;
  hasCharAt = string: char: position:
    if builtins.stringLength string < position then
      false
    else 
      builtins.substring (position - 1) 1 string == char;
  isValid2 = record:
    let
      first = hasCharAt record.pass record.char record.start;
      second = hasCharAt record.pass record.char record.end;
    in
      (!first && second) || (first && !second);
  toLines = string:
    builtins.filter builtins.isString (builtins.split "\n" string);
  countValid = list: validator:
    builtins.length (builtins.filter (x: x) (builtins.map validator list));
  input = builtins.readFile ./2.in;
  records = builtins.filter (x: !builtins.isNull x) (builtins.map parseRecord (toLines input));
in {
  "1" = countValid records isValid;
  "2" = countValid records isValid2;
}
