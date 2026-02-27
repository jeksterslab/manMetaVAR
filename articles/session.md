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
#> [1] manMetaVAR_0.9.7 metaDyn_1.0.0    fitVARMxID_1.0.2 OpenMx_2.22.10  
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
#> Address sizes:                           48 bits physical, 48 bits virtual
#> Byte Order:                              Little Endian
#> CPU(s):                                  4
#> On-line CPU(s) list:                     0-3
#> Vendor ID:                               AuthenticAMD
#> Model name:                              AMD EPYC 7763 64-Core Processor
#> CPU family:                              25
#> Model:                                   1
#> Thread(s) per core:                      2
#> Core(s) per socket:                      2
#> Socket(s):                               1
#> Stepping:                                1
#> BogoMIPS:                                4890.85
#> Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl tsc_reliable nonstop_tsc cpuid extd_apicid aperfmperf tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy svm cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw topoext vmmcall fsgsbase bmi1 avx2 smep bmi2 erms invpcid rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves user_shstk clzero xsaveerptr rdpru arat npt nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold v_vmsave_vmload umip vaes vpclmulqdq rdpid fsrm
#> Virtualization:                          AMD-V
#> Hypervisor vendor:                       Microsoft
#> Virtualization type:                     full
#> L1d cache:                               64 KiB (2 instances)
#> L1i cache:                               64 KiB (2 instances)
#> L2 cache:                                1 MiB (2 instances)
#> L3 cache:                                32 MiB (1 instance)
#> NUMA node(s):                            1
#> NUMA node0 CPU(s):                       0-3
#> Vulnerability Gather data sampling:      Not affected
#> Vulnerability Ghostwrite:                Not affected
#> Vulnerability Indirect target selection: Not affected
#> Vulnerability Itlb multihit:             Not affected
#> Vulnerability L1tf:                      Not affected
#> Vulnerability Mds:                       Not affected
#> Vulnerability Meltdown:                  Not affected
#> Vulnerability Mmio stale data:           Not affected
#> Vulnerability Reg file data sampling:    Not affected
#> Vulnerability Retbleed:                  Not affected
#> Vulnerability Spec rstack overflow:      Vulnerable: Safe RET, no microcode
#> Vulnerability Spec store bypass:         Vulnerable
#> Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
#> Vulnerability Spectre v2:                Mitigation; Retpolines; STIBP disabled; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
#> Vulnerability Srbds:                     Not affected
#> Vulnerability Tsa:                       Vulnerable: Clear CPU buffers attempted, no microcode
#> Vulnerability Tsx async abort:           Not affected
#> Vulnerability Vmscape:                   Not affected
```

## Memory

``` r

cat(system("free -g -h -t", intern = TRUE), sep = "\n")
#>                total        used        free      shared  buff/cache   available
#> Mem:            15Gi       1.6Gi       1.4Gi        48Mi        13Gi        14Gi
#> Swap:          3.0Gi       256Ki       3.0Gi
#> Total:          18Gi       1.6Gi       4.4Gi
```
