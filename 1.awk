{
  y=2020
  for(i in a) {
      if (a[i] + $0 == y && X~c)
        c = a[i] * $0
      for(j in a)
          if (X~d && a[i] + a[j] + $0 == y && i!=j)
            d = a[i] * a[j] *$0
  }
  a[NR] = $0
}

END {
    print c, d
}
