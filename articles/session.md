# manMetaVAR: Session

``` r

library(manMetaVAR)
```

## Session

``` r

sessionInfo()
#> R version 4.5.3 (2026-03-11)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.4 LTS
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
#> [1] manMetaVAR_0.9.8      metaDyn_1.0.1         fitVARMxID_1.0.2.9000
#> [4] OpenMx_2.22.11        microbenchmark_1.5.0 
#> 
#> loaded via a namespace (and not attached):
#>  [1] Matrix_1.7-4          gtable_0.3.6          dplyr_1.2.0          
#>  [4] compiler_4.5.3        tidyselect_1.2.1      Rcpp_1.1.1           
#>  [7] parallel_4.5.3        systemfonts_1.3.2     scales_1.4.0         
#> [10] textshaping_1.0.5     lattice_0.22-9        ggplot2_4.0.2        
#> [13] R6_2.6.1              labeling_0.4.3        generics_0.1.4       
#> [16] knitr_1.51            MASS_7.3-65           tibble_3.3.1         
#> [19] rprojroot_2.1.1       pillar_1.11.1         RColorBrewer_1.1-3   
#> [22] rlang_1.1.7           xfun_0.57             S7_0.2.1             
#> [25] RcppParallel_5.1.11-2 otel_0.2.0            cli_3.6.5.9000       
#> [28] withr_3.0.2           magrittr_2.0.4        digest_0.6.39        
#> [31] grid_4.5.3            rProject_0.0.25       lifecycle_1.0.5      
#> [34] vctrs_0.7.2           simStateSpace_1.2.16  evaluate_1.0.5       
#> [37] glue_1.8.0            farver_2.1.2          ragg_1.5.1           
#> [40] tools_4.5.3           pkgconfig_2.0.3
```

## CPU

``` r

cat(system("lscpu", intern = TRUE), sep = "\n")
#> Architecture:                            x86_64
#> CPU op-mode(s):                          32-bit, 64-bit
#> Address sizes:                           48 bits physical, 48 bits virtual
#> Byte Order:                              Little Endian
#> CPU(s):                                  32
#> On-line CPU(s) list:                     0-31
#> Vendor ID:                               AuthenticAMD
#> Model name:                              AMD Ryzen 9 9955HX 16-Core Processor
#> CPU family:                              26
#> Model:                                   68
#> Thread(s) per core:                      2
#> Core(s) per socket:                      16
#> Socket(s):                               1
#> Stepping:                                0
#> Frequency boost:                         enabled
#> CPU(s) scaling MHz:                      53%
#> CPU max MHz:                             5060.9761
#> CPU min MHz:                             1219.5129
#> BogoMIPS:                                4990.65
#> Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good amd_lbr_v2 nopl xtopology nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate ssbd mba perfmon_v2 ibrs ibpb stibp ibrs_enhanced vmmcall fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local user_shstk avx_vnni avx512_bf16 clzero irperf xsaveerptr rdpru wbnoinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold v_vmsave_vmload vgif x2avic v_spec_ctrl vnmi avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid bus_lock_detect movdiri movdir64b overflow_recov succor smca fsrm avx512_vp2intersect flush_l1d amd_lbr_pmc_freeze
#> Virtualization:                          AMD-V
#> L1d cache:                               768 KiB (16 instances)
#> L1i cache:                               512 KiB (16 instances)
#> L2 cache:                                16 MiB (16 instances)
#> L3 cache:                                64 MiB (2 instances)
#> NUMA node(s):                            1
#> NUMA node0 CPU(s):                       0-31
#> Vulnerability Gather data sampling:      Not affected
#> Vulnerability Indirect target selection: Not affected
#> Vulnerability Itlb multihit:             Not affected
#> Vulnerability L1tf:                      Not affected
#> Vulnerability Mds:                       Not affected
#> Vulnerability Meltdown:                  Not affected
#> Vulnerability Mmio stale data:           Not affected
#> Vulnerability Reg file data sampling:    Not affected
#> Vulnerability Retbleed:                  Not affected
#> Vulnerability Spec rstack overflow:      Mitigation; IBPB on VMEXIT only
#> Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
#> Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
#> Vulnerability Spectre v2:                Mitigation; Enhanced / Automatic IBRS; IBPB conditional; STIBP always-on; PBRSB-eIBRS Not affected; BHI Not affected
#> Vulnerability Srbds:                     Not affected
#> Vulnerability Tsa:                       Not affected
#> Vulnerability Tsx async abort:           Not affected
#> Vulnerability Vmscape:                   Mitigation; IBPB on VMEXIT
```

## Memory

``` r

cat(system("free -g -h -t", intern = TRUE), sep = "\n")
#>                total        used        free      shared  buff/cache   available
#> Mem:            44Gi       6.7Gi        34Gi        41Mi       4.0Gi        37Gi
#> Swap:           22Gi          0B        22Gi
#> Total:          66Gi       6.7Gi        56Gi
```
