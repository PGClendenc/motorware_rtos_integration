#
_XDCBUILDCOUNT = 
ifneq (,$(findstring path,$(_USEXDCENV_)))
override XDCPATH = D:/development/TI/tirtos_c2000_2_16_01_14/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/tidrivers_c2000_2_16_01_13/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/bios_6_45_02_31/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/ndk_2_25_00_09/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/uia_2_00_05_50/packages;D:/development/TI/ccsv6/ccs_base;D:/development/TI/Custom/trunk/sw/PGProjects/boards/8305/f28x/f2806xM/projects/ccs5/motorware_rtos_integrationFri/.config
override XDCROOT = D:/development/TI/xdctools_3_32_00_06_core
override XDCBUILDCFG = ./config.bld
endif
ifneq (,$(findstring args,$(_USEXDCENV_)))
override XDCARGS = 
override XDCTARGETS = 
endif
#
ifeq (0,1)
PKGPATH = D:/development/TI/tirtos_c2000_2_16_01_14/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/tidrivers_c2000_2_16_01_13/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/bios_6_45_02_31/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/ndk_2_25_00_09/packages;D:/development/TI/tirtos_c2000_2_16_01_14/products/uia_2_00_05_50/packages;D:/development/TI/ccsv6/ccs_base;D:/development/TI/Custom/trunk/sw/PGProjects/boards/8305/f28x/f2806xM/projects/ccs5/motorware_rtos_integrationFri/.config;D:/development/TI/xdctools_3_32_00_06_core/packages;..
HOSTOS = Windows
endif
