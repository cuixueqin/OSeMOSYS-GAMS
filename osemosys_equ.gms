* OSEMOSYS_EQU.GMS - model equations
*
* OSEMOSYS 2011.07.07
* - 2017/04 Restyling by Giacomo Marangoni
* - 2012/08 Conversion to GAMS by Ken Noble, Noble-Soft Systems
*
* OSEMOSYS 2011.07.07
* Open Source energy Modeling SYStem
*
* =======================================================================


*------------------------------------------------------------------------	
* Objective function       
*------------------------------------------------------------------------

free variable z;
equation cost;
cost..
    z =e= sum((y,t,r), TotalDiscountedCost(y,t,r));



*------------------------------------------------------------------------	
* Total Discounted Costs       
*------------------------------------------------------------------------

equation TDC1_TotalDiscountedCostByTechnology(YEAR,TECHNOLOGY,REGION);
TDC1_TotalDiscountedCostByTechnology(y,t,r)..
    TotalDiscountedCost(y,t,r) =e= DiscountedOperatingCost(y,t,r)
                                   + DiscountedCapitalInvestment(y,t,r)
                                   + DiscountedTechnologyEmissionsPenalty(y,t,r)
                                   - DiscountedSalvageValue(y,t,r);


*------------------------------------------------------------------------	
* Operating Costs       
*------------------------------------------------------------------------

equation OC4_DiscountedOperatingCostsTotalAnnual(YEAR,TECHNOLOGY,REGION);
OC4_DiscountedOperatingCostsTotalAnnual(y,t,r)..
    DiscountedOperatingCost(y,t,r) =e= OperatingCost(y,t,r)/((1 + DiscountRate(r,t))**(YearVal(y) - smin(yy, YearVal(yy)) + 0.5));

equation OC3_OperatingCostsTotalAnnual(YEAR,TECHNOLOGY,REGION);
OC3_OperatingCostsTotalAnnual(y,t,r)..
    OperatingCost(y,t,r) =e= AnnualFixedOperatingCost(y,t,r) + AnnualVariableOperatingCost(y,t,r);

equation OC2_OperatingCostsFixedAnnual(YEAR,TECHNOLOGY,REGION);
OC2_OperatingCostsFixedAnnual(y,t,r)..
    AnnualFixedOperatingCost(y,t,r) =e= TotalCapacityAnnual(y,t,r)*FixedCost(r,t,y);

equation OC1_OperatingCostsVariable(YEAR,TECHNOLOGY,REGION);
OC1_OperatingCostsVariable(y,t,r)..
    AnnualVariableOperatingCost(y,t,r) =e= sum(m, (TotalAnnualTechnologyActivityByMode(y,t,m,r)*VariableCost(r,t,m,y)));

equation Acc3_AverageAnnualRateOfActivity(YEAR,TECHNOLOGY,MODE_OF_OPERATION,REGION);
Acc3_AverageAnnualRateOfActivity(y,t,m,r)..
    TotalAnnualTechnologyActivityByMode(y,t,m,r) =e= sum(l, RateOfActivity(y,l,t,m,r)*YearSplit(l,y));


*------------------------------------------------------------------------	
* Capital Investments       
*------------------------------------------------------------------------

equation CC2_DiscountingCapitalInvestmenta(YEAR,TECHNOLOGY,REGION);
CC2_DiscountingCapitalInvestmenta(y,t,r)..
    DiscountedCapitalInvestment(y,t,r) =e= CapitalInvestment(y,t,r)/((1 + DiscountRate(r,t))**(YearVal(y) - StartYear));

equation CC1_UndiscountedCapitalInvestment(YEAR,TECHNOLOGY,REGION);
CC1_UndiscountedCapitalInvestment(y,t,r)..
    CapitalInvestment(y,t,r) =e= CapitalCost(r,t,y) * NewCapacity(y,t,r);



*------------------------------------------------------------------------	
* Emissions Penalties       
*------------------------------------------------------------------------

equation E5_DiscountedEmissionsPenaltyByTechnology(YEAR,TECHNOLOGY,REGION);
E5_DiscountedEmissionsPenaltyByTechnology(y,t,r)..
    DiscountedTechnologyEmissionsPenalty(y,t,r) =e= AnnualTechnologyEmissionsPenalty(y,t,r)/
    ((1 + DiscountRate(r,t))**(YearVal(y) - smin(yy, YearVal(yy)) + 0.5));

equation E4_EmissionsPenaltyByTechnology(YEAR,TECHNOLOGY,REGION);
E4_EmissionsPenaltyByTechnology(y,t,r)..
    AnnualTechnologyEmissionsPenalty(y,t,r) =e= sum(e, AnnualTechnologyEmissionPenaltyByEmission(y,t,e,r));

equation E3_EmissionsPenaltyByTechAndEmission(YEAR,TECHNOLOGY,EMISSION,REGION);
E3_EmissionsPenaltyByTechAndEmission(y,t,e,r)..
    AnnualTechnologyEmissionPenaltyByEmission(y,t,e,r) =e= AnnualTechnologyEmission(y,t,e,r)*EmissionsPenalty(r,e,y);

equation E2_AnnualEmissionProduction(YEAR,TECHNOLOGY,EMISSION,REGION);
E2_AnnualEmissionProduction(y,t,e,r)..
    AnnualTechnologyEmission(y,t,e,r) =e= sum(m, AnnualTechnologyEmissionByMode(y,t,e,m,r));

equation E1_AnnualEmissionProductionByMode(YEAR,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,REGION);
E1_AnnualEmissionProductionByMode(y,t,e,m,r)..
    AnnualTechnologyEmissionByMode(y,t,e,m,r) =e= EmissionActivityRatio(r,t,e,m,y)*TotalAnnualTechnologyActivityByMode(y,t,m,r);



*------------------------------------------------------------------------	
* Salvage Value       
*------------------------------------------------------------------------

equation SV4_SalvageValueDiscToStartYr(YEAR,TECHNOLOGY,REGION);
SV4_SalvageValueDiscToStartYr(y,t,r)..
    DiscountedSalvageValue(y,t,r) =e= SalvageValue(y,t,r)/((1 + DiscountRate(r,t))**(1 + smax(yy, YearVal(yy))  -  smin(yy, YearVal(yy))));

equation SV1_SalvageValueAtEndOfPeriod1(YEAR,TECHNOLOGY,REGION);
SV1_SalvageValueAtEndOfPeriod1(y,t,r)$((YearVal(y)  +  OperationalLife(r,t) - 1 > smax(yy, YearVal(yy))) and (DiscountRate(r,t) > 0))..
SalvageValue(y,t,r) =e= CapitalCost(r,t,y)*NewCapacity(y,t,r)*(1 - (((1 + DiscountRate(r,t))**(smax(yy, YearVal(yy))  -  YearVal(y) + 1)  - 1)
/((1 + DiscountRate(r,t))**OperationalLife(r,t) - 1)));

equation SV2_SalvageValueAtEndOfPeriod2(YEAR,TECHNOLOGY,REGION);
SV2_SalvageValueAtEndOfPeriod2(y,t,r)$((YearVal(y)  +  OperationalLife(r,t) - 1 > smax(yy, YearVal(yy))) and (DiscountRate(r,t) = 0))..
SalvageValue(y,t,r) =e= CapitalCost(r,t,y)*NewCapacity(y,t,r)*(1 - smax(yy, YearVal(yy)) -  YearVal(y) + 1)/OperationalLife(r,t);

equation SV3_SalvageValueAtEndOfPeriod3(YEAR,TECHNOLOGY,REGION);
SV3_SalvageValueAtEndOfPeriod3(y,t,r)$(YearVal(y)  +  OperationalLife(r,t) - 1 <= smax(yy, YearVal(yy)))..
SalvageValue(y,t,r) =e= 0;



*------------------------------------------------------------------------	
* Capacity Adequacy       
*------------------------------------------------------------------------

equation CBa2_TotalAnnualCapacity(YEAR,TECHNOLOGY,REGION);
CBa2_TotalAnnualCapacity(y,t,r)..
    TotalCapacityAnnual(y,t,r) =e= AccumulatedNewCapacity(y,t,r) +  ResidualCapacity(r,t,y);

equation CBa1_TotalNewCapacity(YEAR,TECHNOLOGY,REGION);
CBa1_TotalNewCapacity(y,t,r)..
    AccumulatedNewCapacity(y,t,r) =e=
        sum(yy$((YearVal(y) - YearVal(yy) < OperationalLife(r,t)) and (YearVal(y) - YearVal(yy) >= 0)), NewCapacity(yy,t,r));

equation CBa4_Constraint_Capacity(YEAR,TIMESLICE,TECHNOLOGY,REGION);
CBa4_Constraint_Capacity(y,l,t,r)$(TechWithCapacityNeededToMeetPeakTS(r,t) <> 0)..
    RateOfTotalActivity(y,l,t,r) =l=
        TotalCapacityAnnual(y,t,r) * CapacityFactor(r,t,y)*CapacityToActivityUnit(r,t);

equation CBa3_TotalActivityOfEachTechnology(YEAR,TECHNOLOGY,TIMESLICE,REGION);
CBa3_TotalActivityOfEachTechnology(y,t,l,r)..
    RateOfTotalActivity(y,l,t,r) =e= sum(m, RateOfActivity(y,l,t,m,r));

* All other technologies have a capacity great enough to at least meet the annual average.
equation CBb1_PlannedMaintenance(YEAR,TECHNOLOGY,REGION);
CBb1_PlannedMaintenance(y,t,r)..
    sum(l, RateOfTotalActivity(y,l,t,r)*YearSplit(l,y)) =l=
        TotalCapacityAnnual(y,t,r)*CapacityFactor(r,t,y)* AvailabilityFactor(r,t,y)*CapacityToActivityUnit(r,t);



*------------------------------------------------------------------------	
* Energy Balance       
*------------------------------------------------------------------------

* For each time slice

** Balance

equation EBa10_EnergyBalanceEachTS4(YEAR,TIMESLICE,FUEL,REGION);
EBa10_EnergyBalanceEachTS4(y,l,f,r)..
    Production(y,l,f,r) =g= Demand(y,l,f,r) + Use(y,l,f,r);

** Demand

equation EBa9_EnergyBalanceEachTS3(YEAR,TIMESLICE,FUEL,REGION);
EBa9_EnergyBalanceEachTS3(y,l,f,r)..
    Demand(y,l,f,r) =e= RateOfDemand(y,l,f,r)*YearSplit(l,y);

equation EQ_SpecifiedDemand1(YEAR,TIMESLICE,FUEL,REGION);
EQ_SpecifiedDemand1(y,l,f,r)..
    RateOfDemand(y,l,f,r) =e= SpecifiedAnnualDemand(r,f,y)*SpecifiedDemandProfile(r,f,l,y) / YearSplit(l,y);

** Use

equation EBa8_EnergyBalanceEachTS2(YEAR,TIMESLICE,FUEL,REGION);
EBa8_EnergyBalanceEachTS2(y,l,f,r)..
    Use(y,l,f,r) =e= RateOfUse(y,l,f,r)*YearSplit(l,y);

equation EBa6_RateOfFuelUse3(YEAR,TIMESLICE,FUEL,REGION);
EBa6_RateOfFuelUse3(y,l,f,r)..
    RateOfUse(y,l,f,r) =e= sum(t, RateOfUseByTechnology(y,l,t,f,r));

equation EBa5_RateOfFuelUse2(YEAR,TIMESLICE,FUEL,TECHNOLOGY,REGION);
EBa5_RateOfFuelUse2(y,l,f,t,r)..
    RateOfUseByTechnology(y,l,t,f,r) =e= sum(m, RateOfUseByTechnologyByMode(y,l,t,m,f,r));

equation EBa4_RateOfFuelUse1(YEAR,TIMESLICE,FUEL,TECHNOLOGY,MODE_OF_OPERATION,REGION);
EBa4_RateOfFuelUse1(y,l,f,t,m,r)..
    RateOfUseByTechnologyByMode(y,l,t,m,f,r) =e= RateOfActivity(y,l,t,m,r)*InputActivityRatio(r,t,f,m,y);

** Production

equation EBa7_EnergyBalanceEachTS1(YEAR,TIMESLICE,FUEL,REGION);
EBa7_EnergyBalanceEachTS1(y,l,f,r)..
    Production(y,l,f,r) =e= RateOfProduction(y,l,f,r)*YearSplit(l,y);

equation EBa3_RateOfFuelProduction3(YEAR,TIMESLICE,FUEL,REGION);
EBa3_RateOfFuelProduction3(y,l,f,r)..
    RateOfProduction(y,l,f,r) =e= sum(t, RateOfProductionByTechnology(y,l,t,f,r));

equation EBa2_RateOfFuelProduction2(YEAR,TIMESLICE,FUEL,TECHNOLOGY,REGION);
EBa2_RateOfFuelProduction2(y,l,f,t,r)..
    RateOfProductionByTechnology(y,l,t,f,r)=e= sum(m, RateOfProductionByTechnologyByMode(y,l,t,m,f,r));

equation EBa1_RateOfFuelProduction1(YEAR,TIMESLICE,FUEL,TECHNOLOGY,MODE_OF_OPERATION,REGION);
EBa1_RateOfFuelProduction1(y,l,f,t,m,r)..
    RateOfProductionByTechnologyByMode(y,l,t,m,f,r) =e= RateOfActivity(y,l,t,m,r)*OutputActivityRatio(r,t,f,m,y);

* For each year

** Balance

equation EBb3_EnergyBalanceEachYear3(YEAR,FUEL,REGION);
EBb3_EnergyBalanceEachYear3(y,f,r)..
    ProductionAnnual(y,f,r) =g= AccumulatedAnnualDemand(r,f,y) + UseAnnual(y,f,r);

** Production
equation EBb1_EnergyBalanceEachYear1(YEAR,FUEL,REGION);
EBb1_EnergyBalanceEachYear1(y,f,r)..
    ProductionAnnual(y,f,r) =e= sum(l, Production(y,l,f,r));

** Use
equation EBb2_EnergyBalanceEachYear2(YEAR,FUEL,REGION);
EBb2_EnergyBalanceEachYear2(y,f,r)..
    UseAnnual(y,f,r) =e= sum(l, Use(y,l,f,r));


*------------------------------------------------------------------------	
* Capacity Constraints       
*------------------------------------------------------------------------

equation NCC1_TotalAnnualMaxNewCapacityConstraint(YEAR,TECHNOLOGY,REGION);
NCC1_TotalAnnualMaxNewCapacityConstraint(y,t,r)$(TotalAnnualMaxCapacityInvestment(r,t,y) < 9999)..
    NewCapacity(y,t,r) =l= TotalAnnualMaxCapacityInvestment(r,t,y);

equation NCC2_TotalAnnualMinNewCapacityConstraint(YEAR,TECHNOLOGY,REGION);
NCC2_TotalAnnualMinNewCapacityConstraint(y,t,r)$(TotalAnnualMinCapacityInvestment(r,t,y) > 0)..
    NewCapacity(y,t,r) =g= TotalAnnualMinCapacityInvestment(r,t,y);

equation TCC1_TotalAnnualMaxCapacityConstraint(YEAR,TECHNOLOGY,REGION);
TCC1_TotalAnnualMaxCapacityConstraint(y,t,r)$(TotalAnnualMaxCapacity(r,t,y) < 99999)..
    TotalCapacityAnnual(y,t,r) =l= TotalAnnualMaxCapacity(r,t,y);

equation TCC2_TotalAnnualMinCapacityConstraint(YEAR,TECHNOLOGY,REGION);
TCC2_TotalAnnualMinCapacityConstraint(y,t,r)$(TotalAnnualMinCapacity(r,t,y)>0)..
    TotalCapacityAnnual(y,t,r) =g= TotalAnnualMinCapacity(r,t,y);


*------------------------------------------------------------------------	
* Activity Constraints       
*------------------------------------------------------------------------

* For each year

equation AAC1_TotalAnnualTechnologyActivity(YEAR,TECHNOLOGY,REGION);
AAC1_TotalAnnualTechnologyActivity(y,t,r)..
    TotalTechnologyAnnualActivity(y,t,r) =e= sum(l, (RateOfTotalActivity(y,l,t,r)*YearSplit(l,y)));

equation AAC2_TotalAnnualTechnologyActivityUpperLimit(YEAR,TECHNOLOGY,REGION);
AAC2_TotalAnnualTechnologyActivityUpperLimit(y,t,r)$(TotalTechnologyAnnualActivityUpperLimit(r,t,y) <9999)..
    TotalTechnologyAnnualActivity(y,t,r) =l= TotalTechnologyAnnualActivityUpperLimit(r,t,y);

equation AAC3_TotalAnnualTechnologyActivityLowerLimit(YEAR,TECHNOLOGY,REGION);
AAC3_TotalAnnualTechnologyActivityLowerLimit(y,t,r)$(TotalTechnologyAnnualActivityLowerLimit(r,t,y) > 0)..
    TotalTechnologyAnnualActivity(y,t,r) =g= TotalTechnologyAnnualActivityLowerLimit(r,t,y);

* For the whole time horizon

equation TAC1_TotalModelHorizenTechnologyActivity(TECHNOLOGY,REGION);
TAC1_TotalModelHorizenTechnologyActivity(t,r)..
    TotalTechnologyModelPeriodActivity(t,r) =e= sum(y, TotalTechnologyAnnualActivity(y,t,r));

equation TAC2_TotalModelHorizenTechnologyActivityUpperLimit(YEAR,TECHNOLOGY,REGION);
TAC2_TotalModelHorizenTechnologyActivityUpperLimit(y,t,r)$(TotalTechnologyModelPeriodActivityUpperLimit(r,t) < 9999)..
    TotalTechnologyModelPeriodActivity(t,r) =l= TotalTechnologyModelPeriodActivityUpperLimit(r,t);

equation TAC3_TotalModelHorizenTechnologyActivityLowerLimit(YEAR,TECHNOLOGY,REGION);
TAC3_TotalModelHorizenTechnologyActivityLowerLimit(y,t,r)$(TotalTechnologyModelPeriodActivityLowerLimit(r,t) > 0)..
    TotalTechnologyModelPeriodActivity(t,r) =g= TotalTechnologyModelPeriodActivityLowerLimit(r,t);



*------------------------------------------------------------------------	
* Reserve Margins       
*------------------------------------------------------------------------

equation RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(YEAR,TIMESLICE,REGION);
RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(y,l,r)..
    TotalCapacityInReserveMargin(r,y) =e= sum (t, (TotalCapacityAnnual(y,t,r) *ReserveMarginTagTechnology(r,t,y) * CapacityToActivityUnit(r,t)));

equation RM2_ReserveMargin_FuelsIncluded(YEAR,TIMESLICE,REGION);
RM2_ReserveMargin_FuelsIncluded(y,l,r)..
    DemandNeedingReserveMargin(y,l,r) =e= sum (f, (RateOfProduction(y,l,f,r) * ReserveMarginTagFuel(r,f,y)));

equation RM3_ReserveMargin_Constraint(YEAR,TIMESLICE,REGION);
RM3_ReserveMargin_Constraint(y,l,r)..
    TotalCapacityInReserveMargin(r,y) =g= DemandNeedingReserveMargin(y,l,r) * ReserveMargin(r,y);


*------------------------------------------------------------------------	
* RE production targets       
*------------------------------------------------------------------------

equation RE4_EnergyConstraint(YEAR,REGION);
RE4_EnergyConstraint(y,r)..
    REMinProductionTarget(r,y)*RETotalDemandOfTargetFuelAnnual(y,r) =l= TotalREProductionAnnual(y,r);

equation RE2_TechIncluded(YEAR,REGION);
RE2_TechIncluded(y,r)..
    TotalREProductionAnnual(y,r) =e= sum((t,f), (ProductionByTechnologyAnnual(y,t,f,r)*RETagTechnology(r,t,y)));

equation RE1_FuelProductionByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,REGION);
RE1_FuelProductionByTechnologyAnnual(y,t,f,r)..
    ProductionByTechnologyAnnual(y,t,f,r) =e= sum(l, ProductionByTechnology(y,l,t,f,r));

equation Acc1_FuelProductionByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,REGION);
Acc1_FuelProductionByTechnology(y,l,t,f,r)..
    ProductionByTechnology(y,l,t,f,r) =e= RateOfProductionByTechnology(y,l,t,f,r) * YearSplit(l,y);

equation RE3_FuelIncluded(YEAR,REGION);
RE3_FuelIncluded(y,r)..
    RETotalDemandOfTargetFuelAnnual(y,r) =e= sum((l,f), (RateOfDemand(y,l,f,r)*YearSplit(l,y)*RETagFuel(r,f,y)));


*------------------------------------------------------------------------	
* Emissions constraints     
*------------------------------------------------------------------------

* For each year

equation E8_AnnualEmissionsLimit(YEAR,EMISSION,REGION);
E8_AnnualEmissionsLimit(y,e,r)..
    AnnualEmissions(y,e,r) + AnnualExogenousEmission(r,e,y) =l= AnnualEmissionLimit(r,e,y);

equation E6_EmissionsAccounting1(YEAR,EMISSION,REGION);
E6_EmissionsAccounting1(y,e,r)..
    AnnualEmissions(y,e,r) =e= sum(t, AnnualTechnologyEmission(y,t,e,r));


* For the whole time horizon

equation E9_ModelPeriodEmissionsLimit(EMISSION,REGION);
E9_ModelPeriodEmissionsLimit(e,r)..
    ModelPeriodEmissions(e,r) =l= ModelPeriodEmissionLimit(r,e);

equation E7_EmissionsAccounting2(EMISSION,REGION);
E7_EmissionsAccounting2(e,r)..
    ModelPeriodEmissions(e,r) =e= sum(y, AnnualEmissions(y,e,r)) + ModelPeriodExogenousEmission(r,e);



*------------------------------------------------------------------------	
* Storage
*------------------------------------------------------------------------

equation S1_StorageCharge(STORAGE,YEAR,TIMESLICE,REGION);
S1_StorageCharge(s,y,l,r)..
    StorageCharge(s,y,l,r) =e= sum((t,m), (RateOfActivity(y,l,t,m,r) * TechnologyToStorage(r,t,s,m))) * YearSplit(l,y);

equation S2_StorageDischarge(STORAGE,YEAR,TIMESLICE,REGION);
S2_StorageDischarge(s,y,l,r)..
    StorageDischarge(s,y,l,r) =e= sum((t,m), (RateOfActivity(y,l,t,m,r) * TechnologyFromStorage(r,t,s,m))) * YearSplit(l,y);

equation S3_NetStorageCharge(STORAGE,YEAR,TIMESLICE,REGION);
S3_NetStorageCharge(s,y,l,r)..
    NetStorageCharge(s,y,l,r) =e= StorageCharge(s,y,l,r)  -  StorageDischarge(s,y,l,r);

equation S4_StorageLevelAtInflection(BOUNDARY_INSTANCES,STORAGE,REGION);
S4_StorageLevelAtInflection(b,s,r)..
    StorageLevel(s,b,r)=e= sum((l,y), (NetStorageCharge(s,y,l,r)/YearSplit(l,y)*StorageInflectionTimes(y,l,b)));

equation S5_StorageLowerLimit(BOUNDARY_INSTANCES,STORAGE,REGION);
S5_StorageLowerLimit(b,s,r)..
    StorageLevel(s,b,r) =g= StorageLowerLimit(r,s);

equation S6_StorageUpperLimit(BOUNDARY_INSTANCES,STORAGE,REGION);
S6_StorageUpperLimit(b,s,r)..
    StorageLevel(s,b,r) =l= StorageUpperLimit(r,s);


*------------------------------------------------------------------------	
* Other accounting equations    
*------------------------------------------------------------------------

equation RE5_FuelUseByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,REGION);
RE5_FuelUseByTechnologyAnnual(y,t,f,r)..
    UseByTechnologyAnnual(y,t,f,r) =e= sum(l, (RateOfUseByTechnology(y,l,t,f,r)*YearSplit(l,y)));

equation Acc2_FuelUseByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,REGION);
Acc2_FuelUseByTechnology(y,l,t,f,r).. RateOfUseByTechnology(y,l,t,f,r) * YearSplit(l,y) =e= UseByTechnology(y,l,t,f,r);

equation Acc3_ModelPeriodCostByRegion(REGION);
Acc3_ModelPeriodCostByRegion(r).. ModelPeriodCostByRegion(r) =e= sum((y,t), TotalDiscountedCost(y,t,r));
