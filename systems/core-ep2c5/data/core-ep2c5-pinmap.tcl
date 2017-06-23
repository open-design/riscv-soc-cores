# based on https://www.waveshare.com/w/upload/0/02/EP2C5-pin-conf.txt
#          https://www.waveshare.com/w/upload/f/fb/CoreEP2C5-Schematic.pdf

set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS_INPUT_TRI_STATED"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"

set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "USE AS REGULAR IO"

set_location_assignment PIN_17 -to CLK50MHZ
set_location_assignment PIN_88 -to RST_KEY

set_location_assignment PIN_8 -to LED[0]
set_location_assignment PIN_9 -to LED[1]
set_location_assignment PIN_24 -to LED[2]
set_location_assignment PIN_25 -to LED[3]

# EPCS
set_location_assignment PIN_15 -to EPCS_CLK
set_location_assignment PIN_14 -to EPCS_DATA0
set_location_assignment PIN_2 -to EPCS_SCE
set_location_assignment PIN_1 -to EPCS_SDO

# Right Header
# H_RIGHT_1 to GND
# H_RIGHT_2 to 3.3V
set_location_assignment PIN_58 -to H_RIGHT_3
set_location_assignment PIN_57 -to H_RIGHT_4
set_location_assignment PIN_55 -to H_RIGHT_5
set_location_assignment PIN_53 -to H_RIGHT_6
set_location_assignment PIN_52 -to H_RIGHT_7
set_location_assignment PIN_51 -to H_RIGHT_8
set_location_assignment PIN_48 -to H_RIGHT_9
set_location_assignment PIN_47 -to H_RIGHT_10
set_location_assignment PIN_45 -to H_RIGHT_11
set_location_assignment PIN_44 -to H_RIGHT_12
set_location_assignment PIN_43 -to H_RIGHT_13
set_location_assignment PIN_42 -to H_RIGHT_14
set_location_assignment PIN_41 -to H_RIGHT_15
set_location_assignment PIN_40 -to H_RIGHT_16
set_location_assignment PIN_32 -to H_RIGHT_17
set_location_assignment PIN_31 -to H_RIGHT_18
set_location_assignment PIN_30 -to H_RIGHT_19
set_location_assignment PIN_28 -to H_RIGHT_20
set_location_assignment PIN_27 -to H_RIGHT_21
set_location_assignment PIN_26 -to H_RIGHT_22
# H_RIGHT_23 to GND
# H_RIGHT_24 to 5V
set_location_assignment PIN_25  -to H_RIGHT_25
set_location_assignment PIN_24  -to H_RIGHT_26
set_location_assignment PIN_9   -to H_RIGHT_27
set_location_assignment PIN_8   -to H_RIGHT_28
set_location_assignment PIN_7   -to H_RIGHT_29
set_location_assignment PIN_4   -to H_RIGHT_30
set_location_assignment PIN_3   -to H_RIGHT_31
set_location_assignment PIN_144 -to H_RIGHT_32
set_location_assignment PIN_143 -to H_RIGHT_33
set_location_assignment PIN_142 -to H_RIGHT_34
set_location_assignment PIN_141 -to H_RIGHT_35
set_location_assignment PIN_139 -to H_RIGHT_36
set_location_assignment PIN_137 -to H_RIGHT_37
# H_LEFT_21 & H_RIGHT_38 both are assigned to PIN_87
set_location_assignment PIN_87  -to H_RIGHT_38
set_location_assignment PIN_136 -to H_RIGHT_39
set_location_assignment PIN_135 -to H_RIGHT_40
set_location_assignment PIN_134 -to H_RIGHT_41
set_location_assignment PIN_133 -to H_RIGHT_42
set_location_assignment PIN_132 -to H_RIGHT_43
set_location_assignment PIN_129 -to H_RIGHT_44

# Left Header
# H_LEFT_1 to GND
# H_LEFT_2 to 3.3V
set_location_assignment PIN_59 -to H_LEFT_3
set_location_assignment PIN_60 -to H_LEFT_4
set_location_assignment PIN_63 -to H_LEFT_5
set_location_assignment PIN_64 -to H_LEFT_6
set_location_assignment PIN_65 -to H_LEFT_7
set_location_assignment PIN_67 -to H_LEFT_8
set_location_assignment PIN_69 -to H_LEFT_9
set_location_assignment PIN_70 -to H_LEFT_10
set_location_assignment PIN_71 -to H_LEFT_11
set_location_assignment PIN_72 -to H_LEFT_12
set_location_assignment PIN_73 -to H_LEFT_13
set_location_assignment PIN_74 -to H_LEFT_14
set_location_assignment PIN_75 -to H_LEFT_15
set_location_assignment PIN_76 -to H_LEFT_16
set_location_assignment PIN_79 -to H_LEFT_17
set_location_assignment PIN_80 -to H_LEFT_18
set_location_assignment PIN_81 -to H_LEFT_19
set_location_assignment PIN_86 -to H_LEFT_20
# H_LEFT_21 & H_RIGHT_38 both are assigned to PIN_87
set_location_assignment PIN_87 -to H_LEFT_21
set_location_assignment PIN_92 -to H_LEFT_22
# H_LEFT_23 to GND
# H_LEFT_24 to 5V
set_location_assignment PIN_93  -to H_LEFT_25
set_location_assignment PIN_94  -to H_LEFT_26
set_location_assignment PIN_96  -to H_LEFT_27
set_location_assignment PIN_97  -to H_LEFT_28
set_location_assignment PIN_99  -to H_LEFT_29
set_location_assignment PIN_100 -to H_LEFT_30
set_location_assignment PIN_101 -to H_LEFT_31
set_location_assignment PIN_103 -to H_LEFT_32
set_location_assignment PIN_104 -to H_LEFT_33
set_location_assignment PIN_112 -to H_LEFT_34
set_location_assignment PIN_113 -to H_LEFT_35
set_location_assignment PIN_114 -to H_LEFT_36
set_location_assignment PIN_115 -to H_LEFT_37
set_location_assignment PIN_118 -to H_LEFT_38
set_location_assignment PIN_119 -to H_LEFT_39
set_location_assignment PIN_120 -to H_LEFT_40
set_location_assignment PIN_121 -to H_LEFT_41
set_location_assignment PIN_122 -to H_LEFT_42
set_location_assignment PIN_125 -to H_LEFT_43
set_location_assignment PIN_126 -to H_LEFT_44
