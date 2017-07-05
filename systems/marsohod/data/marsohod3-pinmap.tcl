set_global_assignment -name FLOW_ENABLE_IO_ASSIGNMENT_ANALYSIS ON

set_location_assignment PIN_26 -to CLK100MHZ

#set_location_assignment PIN_130 -to KEY0
#set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to KEY0
#set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to KEY0

set_location_assignment PIN_25 -to KEY1
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to KEY1
#set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to KEY1

# the nCONFIG, nSTATUS, and CONF_DONE pins are disabled when the device
# operates in user mode and is available as a user I/O pin.
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF

# the CONFIG_SEL pin are disabled
# when the device operates in user mode and is available as a user I/O pin.
#set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
#
set_location_assignment PIN_27 -to SDRAM_DQ[15]
set_location_assignment PIN_28 -to SDRAM_DQ[14]
set_location_assignment PIN_29 -to SDRAM_DQ[13]
set_location_assignment PIN_30 -to SDRAM_DQ[12]
set_location_assignment PIN_32 -to SDRAM_DQ[11]
set_location_assignment PIN_33 -to SDRAM_DQ[10]
set_location_assignment PIN_38 -to SDRAM_DQ[9]
set_location_assignment PIN_39 -to SDRAM_DQ[8]

set_location_assignment PIN_66 -to SDRAM_DQ[7]
set_location_assignment PIN_69 -to SDRAM_DQ[6]
set_location_assignment PIN_70 -to SDRAM_DQ[5]
set_location_assignment PIN_74 -to SDRAM_DQ[4]
set_location_assignment PIN_75 -to SDRAM_DQ[3]
set_location_assignment PIN_76 -to SDRAM_DQ[2]
set_location_assignment PIN_77 -to SDRAM_DQ[1]
set_location_assignment PIN_80 -to SDRAM_DQ[0]

set_location_assignment PIN_57 -to SDRAM_A[0]
set_location_assignment PIN_58 -to SDRAM_A[1]
set_location_assignment PIN_60 -to SDRAM_A[2]
set_location_assignment PIN_61 -to SDRAM_A[3]
set_location_assignment PIN_42 -to SDRAM_A[4]
set_location_assignment PIN_43 -to SDRAM_A[5]
set_location_assignment PIN_44 -to SDRAM_A[6]
set_location_assignment PIN_46 -to SDRAM_A[7]
set_location_assignment PIN_49 -to SDRAM_A[8]
set_location_assignment PIN_50 -to SDRAM_A[9]
set_location_assignment PIN_55 -to SDRAM_A[10]
set_location_assignment PIN_51 -to SDRAM_A[11]

set_location_assignment PIN_65 -to SDRAM_DQM[0]
set_location_assignment PIN_40 -to SDRAM_DQM[1]

set_location_assignment PIN_52 -to SDRAM_BA[0]
set_location_assignment PIN_53 -to SDRAM_BA[1]

set_location_assignment PIN_62 -to SDRAM_RAS
set_location_assignment PIN_63 -to SDRAM_CAS
set_location_assignment PIN_64 -to SDRAM_WE
set_location_assignment PIN_41 -to SDRAM_CLK

set_location_assignment PIN_81 -to LED[7]
set_location_assignment PIN_82 -to LED[6]
set_location_assignment PIN_83 -to LED[5]
set_location_assignment PIN_84 -to LED[4]
set_location_assignment PIN_85 -to LED[3]
set_location_assignment PIN_86 -to LED[2]
set_location_assignment PIN_87 -to LED[1]
set_location_assignment PIN_88 -to LED[0]

set_location_assignment PIN_89 -to IO[0]
set_location_assignment PIN_90 -to IO[1]
set_location_assignment PIN_91 -to IO[2]
set_location_assignment PIN_92 -to IO[3]
set_location_assignment PIN_93 -to IO[4]
set_location_assignment PIN_96 -to IO[5]
set_location_assignment PIN_97 -to IO[6]
set_location_assignment PIN_98 -to IO[7]

set_location_assignment PIN_141 -to FTDI_BD0
set_location_assignment PIN_140 -to FTDI_BD1
set_location_assignment PIN_138 -to FTDI_BD2
set_location_assignment PIN_136 -to FTDI_BD3

#set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"

set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
set_global_assignment -name VCCA_USER_VOLTAGE 3.3V
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DCLK_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name CYCLONEII_OPTIMIZATION_TECHNIQUE BALANCED
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION OFF
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
#set_global_assignment -name ENABLE_OCT_DONE ON
#set_global_assignment -name EXTERNAL_FLASH_FALLBACK_ADDRESS 00000000
#set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE IMAGE WITH ERAM"
