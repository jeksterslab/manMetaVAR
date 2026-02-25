# manMetaVAR: Session

``` r

library(manMetaVAR)
```

## Session

``` r

sessionInfo()
#> R version 4.5.2 (2025-10-31)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: Etc/UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] manMetaVAR_0.9.7   metaDyn_0.0.0.9006 fitVARMxID_1.0.2   OpenMx_2.22.10    
#> 
#> loaded via a namespace (and not attached):
#>  [1] digest_0.6.39         simStateSpace_1.2.15  xfun_0.56            
#>  [4] Matrix_1.7-4          lattice_0.22-7        knitr_1.51           
#>  [7] parallel_4.5.2        RcppParallel_5.1.11-1 lifecycle_1.0.5      
#> [10] cli_3.6.5.9000        rProject_0.0.25       grid_4.5.2           
#> [13] compiler_4.5.2        tools_4.5.2           evaluate_1.0.5       
#> [16] Rcpp_1.1.1            otel_0.2.0            rlang_1.1.7          
#> [19] MASS_7.3-65
```

## CPU

``` r

cat(system("lscpu", intern = TRUE), sep = "\n")
#> Architecture:                            x86_64
#> CPU op-mode(s):                          32-bit, 64-bit
#> Address sizes:                           46 bits physical, 48 bits virtual
#> Byte Order:                              Little Endian
#> CPU(s):                                  8
#> On-line CPU(s) list:                     0-7
#> Vendor ID:                               GenuineIntel
#> Model name:                              Intel(R) Xeon(R) CPU E5-1620 v2 @ 3.70GHz
#> CPU family:                              6
#> Model:                                   62
#> Thread(s) per core:                      2
#> Core(s) per socket:                      4
#> Socket(s):                               1
#> Stepping:                                4
#> CPU(s) scaling MHz:                      94%
#> CPU max MHz:                             3900.0000
#> CPU min MHz:                             1200.0000
#> BogoMIPS:                                7382.68
#> Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm cpuid_fault epb pti ssbd ibrs ibpb stibp tpr_shadow flexpriority ept vpid fsgsbase smep erms xsaveopt dtherm ida arat pln pts vnmi md_clear flush_l1d
#> Virtualization:                          VT-x
#> L1d cache:                               128 KiB (4 instances)
#> L1i cache:                               128 KiB (4 instances)
#> L2 cache:                                1 MiB (4 instances)
#> L3 cache:                                10 MiB (1 instance)
#> NUMA node(s):                            1
#> NUMA node0 CPU(s):                       0-7
#> Vulnerability Gather data sampling:      Not affected
#> Vulnerability Indirect target selection: Not affected
#> Vulnerability Itlb multihit:             KVM: Mitigation: Split huge pages
#> Vulnerability L1tf:                      Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
#> Vulnerability Mds:                       Mitigation; Clear CPU buffers; SMT vulnerable
#> Vulnerability Meltdown:                  Mitigation; PTI
#> Vulnerability Mmio stale data:           Unknown: No mitigations
#> Vulnerability Reg file data sampling:    Not affected
#> Vulnerability Retbleed:                  Not affected
#> Vulnerability Spec rstack overflow:      Not affected
#> Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
#> Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
#> Vulnerability Spectre v2:                Mitigation; Retpolines; IBPB conditional; IBRS_FW; STIBP conditional; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
#> Vulnerability Srbds:                     Not affected
#> Vulnerability Tsa:                       Not affected
#> Vulnerability Tsx async abort:           Not affected
#> Vulnerability Vmscape:                   Mitigation; IBPB before exit to userspace
```

## Memory

``` r

cat(system("free -g -h -t", intern = TRUE), sep = "\n")
#>                total        used        free      shared  buff/cache   available
#> Mem:            23Gi       6.6Gi       6.4Gi       324Mi        10Gi        16Gi
#> Swap:           11Gi        10Mi        11Gi
#> Total:          34Gi       6.6Gi        18Gi
```
