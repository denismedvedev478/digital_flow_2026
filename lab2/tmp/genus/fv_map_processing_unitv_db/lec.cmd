REAd IMplementation Information fv/processing_unit -golden fv_map -revised processing_unitv -use_rtl_names
SET PARAllel Option -threads 1,4 -norelease_license
SET COmpare Options -threads 1,4
SET MUltiplier Implementation boothrca -both
SET UNDEfined Cell black_box -noascend -both
ADD SEarch Path . /local/tools/cadence/DDI/23.10.000/GENUS231/tools.lnx86/lib/tech -library -both
REAd LIbrary -liberty -both /home/denismedvedev478/digital_flow_2026/lab2/../PDK/IHP_Open_PDK/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib
REAd DEsign -verilog95 -golden -lastmod -noelab fv/processing_unit/fv_map.v.gz
ELAborate DEsign -golden -root processing_unit
REAd DEsign -verilog95 -revised -lastmod -noelab /home/denismedvedev478/digital_flow_2026/lab2/tmp/genus/outputs/syn_opt/processing_unit.v
ELAborate DEsign -revised -root processing_unit
WRIte DEsign -golden fv_map_processing_unitv_db/elab.v -replace
REPort DEsign Data
REPort BLack Box
REPort MOdules
SET FLatten Model -seq_constant
SET FLatten Model -seq_constant_x_to 0
SET FLatten Model -hier_seq_merge
ANAlyze EXtended Mapping fv/processing_unit/fv_map.map.do fv/processing_unit/processing_unitv.map.do -output\
   fv_map_processing_unitv_1.map.do -input_specification rtl-n1 rtl-n2 -output_specification\
   n1-n2 -replace -verbose
SET MApping Method -mapping_file_nopipo
SET MApping Method -search_in_mapping_file
SET ANalyze Option -mapping_file fv_map_processing_unitv_1.map.do
CHEck MApping Setup -mapping_file_quality -summary
CHEck VErification Information
SET ANalyze Option -auto -report_map
SET SYstem Mode lec
REPort UNmapped Points -summary
REPort UNmapped Points -notmapped
ADD COmpared Points -all
COMpare
REPort COmpare Data -class nonequivalent -class abort -class notcompared
REPort VErification -verbose
REPort STatistics
WRIte COmpared Points noneq.compared_points.processing_unit.fv_map.processing_unitv.tcl -class noneq -tclmode\
   -replace
ANAlyze NOnequivalent -source_diagnosis
REPort NOnequivalent Analysis
REPort TEst Vector -noneq
REPort VErification
EXIt -f
