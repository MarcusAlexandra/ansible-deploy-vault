$TTL 1D
@       IN SOA  utrutstetcd01v.dynataplc.com.com. root.dynataplc.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H      ; minimum
)
@                               IN      NS      utrutstetcd01v.dynataplc.com.
@                               IN      PTR     dynataplc.com.
utrutstetcd01v                  IN      A       10.13.3.15
utrutstetcd02v                  IN      A       10.13.3.16
utrutstetcd03v                  IN      A       10.13.3.17
utrutstvault01v                 IN      A       10.13.3.10
utrutstvault02v                 IN      A       10.13.3.11
15                              IN      PTR     utrutstetcd01v.dynataplc.com.
16                              IN      PTR     utrutstetcd02v.dynataplc.com.
17                              IN      PTR     utrutstetcd03v.dynataplc.com.
10                              IN      PTR     utrutstvault01v.dynataplc.com.
11                              IN      PTR     utrutststvlt02v.dynataplc.com.
