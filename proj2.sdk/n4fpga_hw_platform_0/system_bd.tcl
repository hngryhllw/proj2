
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7a100tcsg324-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list CONFIG.C_ECC {0}  ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list CONFIG.C_ECC {0}  ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 lmb_bram ]
  set_property -dict [ list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.use_bram_block {BRAM_Controller}  ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set debug_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 debug_out ]
  set uart_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart_out ]

  # Create ports
  set clk_100MHz_out [ create_bd_port -dir O -type clk clk_100MHz_out ]
  set led_out [ create_bd_port -dir O -from 15 -to 0 led_out ]
  set nexys4_btn_c_in [ create_bd_port -dir I nexys4_btn_c_in ]
  set nexys4_btn_d_in [ create_bd_port -dir I nexys4_btn_d_in ]
  set nexys4_btn_l_in [ create_bd_port -dir I nexys4_btn_l_in ]
  set nexys4_btn_r_in [ create_bd_port -dir I nexys4_btn_r_in ]
  set nexys4_btn_u_in [ create_bd_port -dir I nexys4_btn_u_in ]
  set nexys4_swt_in [ create_bd_port -dir I -from 15 -to 0 nexys4_swt_in ]
  set pmod_clp_data_out [ create_bd_port -dir O -from 7 -to 0 pmod_clp_data_out ]
  set pmod_clp_e_out [ create_bd_port -dir O pmod_clp_e_out ]
  set pmod_clp_rs_out [ create_bd_port -dir O pmod_clp_rs_out ]
  set pmod_clp_rw_out [ create_bd_port -dir O pmod_clp_rw_out ]
  set pmod_enc_a_in [ create_bd_port -dir I pmod_enc_a_in ]
  set pmod_enc_b_in [ create_bd_port -dir I pmod_enc_b_in ]
  set pmod_enc_press_in [ create_bd_port -dir I pmod_enc_press_in ]
  set pmod_enc_swt_in [ create_bd_port -dir I pmod_enc_swt_in ]
  set pwm_det_ref_clk_in [ create_bd_port -dir I pwm_det_ref_clk_in ]
  set pwm_det_reset_in [ create_bd_port -dir I pwm_det_reset_in ]
  set pwm_out [ create_bd_port -dir O pwm_out ]
  set rgb1_b_out [ create_bd_port -dir O rgb1_b_out ]
  set rgb1_g_out [ create_bd_port -dir O rgb1_g_out ]
  set rgb1_r_out [ create_bd_port -dir O rgb1_r_out ]
  set rgb2_b_out [ create_bd_port -dir O rgb2_b_out ]
  set rgb2_g_out [ create_bd_port -dir O rgb2_g_out ]
  set rgb2_r_out [ create_bd_port -dir O rgb2_r_out ]
  set sev_seg_annode_out [ create_bd_port -dir O -from 7 -to 0 sev_seg_annode_out ]
  set sev_seg_digits_out [ create_bd_port -dir O -from 6 -to 0 sev_seg_digits_out ]
  set sev_seg_points_out [ create_bd_port -dir O sev_seg_points_out ]
  set sysclk [ create_bd_port -dir I -type clk sysclk ]
  set sysreset_n [ create_bd_port -dir I -type rst sysreset_n ]
  set_property -dict [ list CONFIG.POLARITY {ACTIVE_LOW}  ] $sysreset_n
  set tsl235r_pulse_in [ create_bd_port -dir I tsl235r_pulse_in ]

  # Create instance: Nexys4IO_0, and set properties
  set Nexys4IO_0 [ create_bd_cell -type ip -vlnv ece.pdx.edu:ECE544_IP:Nexys4IO:1.1 Nexys4IO_0 ]

  # Create instance: PMod544IOR2_0, and set properties
  set PMod544IOR2_0 [ create_bd_cell -type ip -vlnv ece.pdx.edu:ECE544_IP:PMod544IOR2:1.0 PMod544IOR2_0 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {4}  ] $axi_gpio_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list CONFIG.C_BAUDRATE {115200}  ] $axi_uartlite_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_1 ]
  set_property -dict [ list CONFIG.CLKOUT2_JITTER {130.958} CONFIG.CLKOUT2_PHASE_ERROR {98.575} CONFIG.CLKOUT2_USED {true} CONFIG.MMCM_CLKOUT1_DIVIDE {10} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.NUM_OUT_CLKS {2} CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} CONFIG.USE_RESET {false}  ] $clk_wiz_1

  # Create instance: fit_timer_0, and set properties
  set fit_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer_0 ]
  set_property -dict [ list CONFIG.C_NO_CLOCKS {2000}  ] $fit_timer_0

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.5 microblaze_0 ]
  set_property -dict [ list CONFIG.C_DEBUG_ENABLED {1} CONFIG.C_D_AXI {1} CONFIG.C_D_LMB {1} CONFIG.C_I_LMB {1} CONFIG.C_USE_BARREL {0} CONFIG.C_USE_DIV {0} CONFIG.C_USE_HW_MUL {0}  ] $microblaze_0

  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
  set_property -dict [ list CONFIG.C_HAS_FAST {1}  ] $microblaze_0_axi_intc

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {7}  ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]

  # Create instance: tsl235r_0, and set properties
  set tsl235r_0 [ create_bd_cell -type ip -vlnv user.org:proj2_ip:tsl235r:1.0 tsl235r_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports debug_out] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports uart_out] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins Nexys4IO_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins PMod544IOR2_0/S00_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI] [get_bd_intf_pins tsl235r_0/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_intc_axi [get_bd_intf_pins microblaze_0_axi_intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins microblaze_0_axi_intc/interrupt]

  # Create port connections
  connect_bd_net -net Nexys4IO_0_RGB1_Blue [get_bd_ports rgb1_b_out] [get_bd_pins Nexys4IO_0/RGB1_Blue]
  connect_bd_net -net Nexys4IO_0_RGB1_Green [get_bd_ports rgb1_g_out] [get_bd_pins Nexys4IO_0/RGB1_Green]
  connect_bd_net -net Nexys4IO_0_RGB1_Red [get_bd_ports rgb1_r_out] [get_bd_pins Nexys4IO_0/RGB1_Red]
  connect_bd_net -net Nexys4IO_0_RGB2_Blue [get_bd_ports rgb2_b_out] [get_bd_pins Nexys4IO_0/RGB2_Blue]
  connect_bd_net -net Nexys4IO_0_RGB2_Green [get_bd_ports rgb2_g_out] [get_bd_pins Nexys4IO_0/RGB2_Green]
  connect_bd_net -net Nexys4IO_0_RGB2_Red [get_bd_ports rgb2_r_out] [get_bd_pins Nexys4IO_0/RGB2_Red]
  connect_bd_net -net Nexys4IO_0_an [get_bd_ports sev_seg_annode_out] [get_bd_pins Nexys4IO_0/an]
  connect_bd_net -net Nexys4IO_0_dp [get_bd_ports sev_seg_points_out] [get_bd_pins Nexys4IO_0/dp]
  connect_bd_net -net Nexys4IO_0_led [get_bd_ports led_out] [get_bd_pins Nexys4IO_0/led]
  connect_bd_net -net Nexys4IO_0_seg [get_bd_ports sev_seg_digits_out] [get_bd_pins Nexys4IO_0/seg]
  connect_bd_net -net PMod544IOR2_0_PmodCLP_DataBus [get_bd_ports pmod_clp_data_out] [get_bd_pins PMod544IOR2_0/PmodCLP_DataBus]
  connect_bd_net -net PMod544IOR2_0_PmodCLP_E [get_bd_ports pmod_clp_e_out] [get_bd_pins PMod544IOR2_0/PmodCLP_E]
  connect_bd_net -net PMod544IOR2_0_PmodCLP_RS [get_bd_ports pmod_clp_rs_out] [get_bd_pins PMod544IOR2_0/PmodCLP_RS]
  connect_bd_net -net PMod544IOR2_0_PmodCLP_RW [get_bd_ports pmod_clp_rw_out] [get_bd_pins PMod544IOR2_0/PmodCLP_RW]
  connect_bd_net -net PmodENC_A_1 [get_bd_ports pmod_enc_a_in] [get_bd_pins PMod544IOR2_0/PmodENC_A]
  connect_bd_net -net PmodENC_BTN_1 [get_bd_ports pmod_enc_press_in] [get_bd_pins PMod544IOR2_0/PmodENC_BTN]
  connect_bd_net -net PmodENC_B_1 [get_bd_ports pmod_enc_b_in] [get_bd_pins PMod544IOR2_0/PmodENC_B]
  connect_bd_net -net PmodENC_SWT_1 [get_bd_ports pmod_enc_swt_in] [get_bd_pins PMod544IOR2_0/PmodENC_SWT]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In1]
  connect_bd_net -net axi_timer_0_pwm0 [get_bd_ports pwm_out] [get_bd_pins axi_timer_0/pwm0]
  connect_bd_net -net btnC_1 [get_bd_ports nexys4_btn_c_in] [get_bd_pins Nexys4IO_0/btnC]
  connect_bd_net -net btnD_1 [get_bd_ports nexys4_btn_d_in] [get_bd_pins Nexys4IO_0/btnD]
  connect_bd_net -net btnL_1 [get_bd_ports nexys4_btn_l_in] [get_bd_pins Nexys4IO_0/btnL]
  connect_bd_net -net btnR_1 [get_bd_ports nexys4_btn_r_in] [get_bd_pins Nexys4IO_0/btnR]
  connect_bd_net -net btnU_1 [get_bd_ports nexys4_btn_u_in] [get_bd_pins Nexys4IO_0/btnU]
  connect_bd_net -net clk_in1_1 [get_bd_ports sysclk] [get_bd_pins clk_wiz_1/clk_in1]
  connect_bd_net -net clk_wiz_1_clk_out2 [get_bd_ports clk_100MHz_out] [get_bd_pins clk_wiz_1/clk_out2]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
  connect_bd_net -net fit_timer_0_Interrupt [get_bd_pins fit_timer_0/Interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Nexys4IO_0/s00_axi_aclk] [get_bd_pins PMod544IOR2_0/s00_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins fit_timer_0/Clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_intc/processor_clk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins tsl235r_0/s00_axi_aclk]
  connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_axi_intc/intr] [get_bd_pins microblaze_0_xlconcat/dout]
  connect_bd_net -net ref_clk_1 [get_bd_ports pwm_det_ref_clk_in] [get_bd_pins tsl235r_0/ref_clk]
  connect_bd_net -net reset_1 [get_bd_ports pwm_det_reset_in] [get_bd_pins tsl235r_0/reset]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports sysreset_n] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_0_axi_intc/processor_rst] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins Nexys4IO_0/s00_axi_aresetn] [get_bd_pins PMod544IOR2_0/s00_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] [get_bd_pins tsl235r_0/s00_axi_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_reset [get_bd_pins fit_timer_0/Rst] [get_bd_pins rst_clk_wiz_1_100M/peripheral_reset]
  connect_bd_net -net sw_1 [get_bd_ports nexys4_swt_in] [get_bd_pins Nexys4IO_0/sw]
  connect_bd_net -net tsl235r_pulse_in_1 [get_bd_ports tsl235r_pulse_in] [get_bd_pins tsl235r_0/tsl235r_pulse_in]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs Nexys4IO_0/S00_AXI/S00_AXI_reg] SEG_Nexys4IO_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs PMod544IOR2_0/S00_AXI/S00_AXI_reg] SEG_PMod544IOR2_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x40000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41C00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x10000 -offset 0x0 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_axi_intc/s_axi/Reg] SEG_microblaze_0_axi_intc_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x44A20000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs tsl235r_0/S00_AXI/S00_AXI_reg] SEG_tsl235r_0_S00_AXI_reg
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


