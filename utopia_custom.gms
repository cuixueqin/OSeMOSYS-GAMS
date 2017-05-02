$ifthen.s '%1'=='urev'
* Take care of discrepancies w/ Howells et al. 2011       

*InputActivityRatio(r,'TXD','DSL','1',y) = 4.33;
*InputActivityRatio(r,'TXE','ELC','1',y) = 1.21;
*InputActivityRatio(r,'TXG','GSL','1',y) = 4.33;
InputActivityRatio(r,'E21','URN','1',y) = 2.50;
InputActivityRatio(r,'RHO','DSL','1',y) = 1.;
ResidualCapacity(r,'TXG',y) = 4.6*ResidualCapacity(r,'TXD',y)/ResidualCapacity(r,'TXD','1990');
CapitalCost(r,'RL1',y) = 100;

*------------------------------------------------------------------------
$elseif.s '%1'=='sto'
* Enforce storage level between limits at the end of model period

StorageInflectionTimes(y,l,'endc1') = 1;


*------------------------------------------------------------------------
$else.s
* Argument not supported

$log --- !!! No changes to default UTOPIA dataset !!!

$endif.s
