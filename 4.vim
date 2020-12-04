function Day4()
    let l:valid_1 = '\v(%(.+\n{0,1}.*)*byr:)@=(%(.+\n{0,1}.*)*iyr:)@=(%(.+\n{0,1}.*)*eyr:)@=(%(.+\n{0,1}.*)*hgt:)@=(%(.+\n{0,1}.*)*hcl:)@=(%(.+\n{0,1}.*)*ecl:)@=(%(.+\n{0,1}.*)*pid:)@=(%(.*)|%(.+\n.+)+)'
    let l:valid = '\v(%(.+\n{0,1}.*)*byr:%(200[0-2]|19[2-9][0-9]))@=(%(.+\n{0,1}.*)*iyr:%(2020|201[0-9]))@=(%(.+\n{0,1}.*)*eyr:%(2030|202[0-9]))@=(%(.+\n{0,1}.*)*hgt:%(%(59|6[0-9]|7[0-6])in|1%([5-8][0-9]|9[0-3])cm))@=(%(.+\n{0,1}.*)*hcl:#[a-f0-9]{6})@=(%(.+\n{0,1}.*)*ecl:%(amb|blu|brn|gry|grn|hzl|oth|grn|hzl|oth))@=(%(.+\n{0,1}.*)*pid:[0-9]{9,9}%($|[ \n\Z]))@=(%(.*)|%(.+\n.+)+)'

    syntax match record '\v(.+\n)+%(\n\n|\Z)'
    highlight link record Error

    exec "syntax match validRecord '" . l:valid . '%(\n\n|Z)' . "'"
    highlight link validRecord Structure

    let l:text = join(getline(1,'$'), "\n")
    let l:records = split(l:text, "\n\n")
    let g:d4_nrec = len(l:records)
    let g:d4_nval_1 = 0
    let g:d4_nval = 0

    for rec in l:records
        if rec =~ l:valid_1
            let g:d4_nval_1 += 1
        endif
        if rec =~ l:valid
            let g:d4_nval += 1
        endif
    endfor

    set statusline=
    set statusline+=%{g:d4_nrec}\ records\ total,
    set statusline+=\ %{g:d4_nval}\ valid,
    set statusline+=\ %{g:d4_nval_1}\ valid\ for\ first\ task
endfunction

au BufNewFile,BufRead 4.in call Day4()
