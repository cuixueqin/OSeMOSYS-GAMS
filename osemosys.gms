$title OSEMOSYS 2011.07.07

* OSEMOSYS 2011.07.07
* - 2017/04 Restyling by Giacomo Marangoni
* - 2012/08 Conversion to GAMS by Ken Noble, Noble-Soft Systems

$setglobal scen base

* declarations for sets, parameters, variables
$include osemosys_dec.gms

* load optimal levels from last results file if present
$if exist results_base.gdx execute_loadpoint 'results_base.gdx';

* load parameters and define model
$include utopia_data.gms
$batinclude utopia_custom.gms "%scen%"
*execute_unload 'data_utopia.gdx';
*$stop
$include osemosys_equ.gms
model osemosys /all/;

* solve the model
option limrow=0;
option limcol=0;
option solprint=on;
option lp=cbc;
solve osemosys minimizing z using lp;

* create results file
$batinclude osemosys_gdx "%scen%"
*$include osemosys_res.gms
