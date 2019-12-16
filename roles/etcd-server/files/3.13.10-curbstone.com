$TTL 1D
@       IN SOA  utrutstetcd01v.curbstone.com.com. root.curbstone.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H      ; minimum
)
@                               IN      NS      utrutstetcd01v.curbstone.com.
@                               IN      PTR     curbstone.com.
utrutstetcd01v                  IN      A       10.13.3.15
utrutstetcd02v                  IN      A       10.13.3.16
utrutstetcd03v                  IN      A       10.13.3.17
utrutstvault01v                 IN      A       10.13.3.10
utrutstvault02v                 IN      A       10.13.3.11
15                              IN      PTR     utrutstetcd01v.curbstone.com.
16                              IN      PTR     utrutstetcd02v.curbstone.com.
17                              IN      PTR     utrutstetcd03v.curbstone.com.
10                              IN      PTR     utrutstvault01v.curbstone.com.
11                              IN      PTR     utrutststvlt02v.curbstone.com.
