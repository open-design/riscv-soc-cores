set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

set_location_assignment PIN_25 -to CLK100MHZ

set_location_assignment PIN_30 -to SDRAM_DQ[15]
set_location_assignment PIN_31 -to SDRAM_DQ[14]
set_location_assignment PIN_32 -to SDRAM_DQ[13]
set_location_assignment PIN_33 -to SDRAM_DQ[12]
set_location_assignment PIN_34 -to SDRAM_DQ[11]
set_location_assignment PIN_38 -to SDRAM_DQ[10]
set_location_assignment PIN_39 -to SDRAM_DQ[9]
set_location_assignment PIN_42 -to SDRAM_DQ[8]

set_location_assignment PIN_71 -to SDRAM_DQ[7]
set_location_assignment PIN_72 -to SDRAM_DQ[6]
set_location_assignment PIN_73 -to SDRAM_DQ[5]
set_location_assignment PIN_74 -to SDRAM_DQ[4]
set_location_assignment PIN_75 -to SDRAM_DQ[3]
set_location_assignment PIN_76 -to SDRAM_DQ[2]
set_location_assignment PIN_77 -to SDRAM_DQ[1]
set_location_assignment PIN_80 -to SDRAM_DQ[0]

set_location_assignment PIN_60 -to SDRAM_A[0]
set_location_assignment PIN_64 -to SDRAM_A[1]
set_location_assignment PIN_65 -to SDRAM_A[2]
set_location_assignment PIN_66 -to SDRAM_A[3]
set_location_assignment PIN_46 -to SDRAM_A[4]
set_location_assignment PIN_49 -to SDRAM_A[5]
set_location_assignment PIN_50 -to SDRAM_A[6]
set_location_assignment PIN_51 -to SDRAM_A[7]
set_location_assignment PIN_52 -to SDRAM_A[8]
set_location_assignment PIN_53 -to SDRAM_A[9]
set_location_assignment PIN_59 -to SDRAM_A[10]
set_location_assignment PIN_54 -to SDRAM_A[11]

set_location_assignment PIN_70 -to SDRAM_DQM[0]
set_location_assignment PIN_43 -to SDRAM_DQM[1]

set_location_assignment PIN_55 -to SDRAM_BA[0]
set_location_assignment PIN_58 -to SDRAM_BA[1]

set_location_assignment PIN_67 -to SDRAM_RAS
set_location_assignment PIN_68 -to SDRAM_CAS
set_location_assignment PIN_69 -to SDRAM_WE
set_location_assignment PIN_44 -to SDRAM_CLK

set_location_assignment PIN_79 -to LED[3]
set_location_assignment PIN_83 -to LED[2]
set_location_assignment PIN_84 -to LED[1]
set_location_assignment PIN_85 -to LED[0]

set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_location_assignment PIN_101 -to IO[0]
set_location_assignment PIN_103 -to IO[1]
set_location_assignment PIN_104 -to IO[2]
set_location_assignment PIN_105 -to IO[3]
set_location_assignment PIN_106 -to IO[4]
set_location_assignment PIN_110 -to IO[5]
set_location_assignment PIN_111 -to IO[6]
set_location_assignment PIN_112 -to IO[7]

set_location_assignment PIN_23 -to KEY0
set_location_assignment PIN_22 -to KEY1

set_location_assignment PIN_24 -to FTDI_BD0
set_location_assignment PIN_28 -to FTDI_BD1
set_location_assignment PIN_11 -to FTDI_BD2
set_location_assignment PIN_10 -to FTDI_BD3
