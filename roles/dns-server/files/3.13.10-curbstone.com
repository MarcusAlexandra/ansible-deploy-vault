$TTL 1D
@       IN SOA  usctvletcd01v.curbstone.com. root.curbstone.com. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H      ; minimum
)
@                               IN      NS      usctvletcd01v.curbstone.com.
@                               IN      PTR     curbstone.com.
usctvletcd01v                   IN      A       10.13.3.15
usctvletcd02v                   IN      A       10.13.3.16
usctvletcd03v                   IN      A       10.13.3.17
utrutstvault01v                 IN      A       10.13.3.10
utrutstvault02v                 IN      A       10.13.3.11
15                              IN      PTR     usctvletcd01v.curbstone.com.
16                              IN      PTR     usctvletcd02v.curbstone.com.
17                              IN      PTR     usctvletcd03v.curbstone.com.
10                              IN      PTR     utrutstvault01v.curbstone.com.
11                              IN      PTR     usctvltstvlt02v.curbstone.com.
