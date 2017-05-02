execute_unload 'results_%1',
YearSplit
DiscountRate
*
* ####### Demands #############
*
SpecifiedAnnualDemand
SpecifiedDemandProfile
AccumulatedAnnualDemand
*
* ######## Technology #############
*
* ######## Performance #############
*
CapacityToActivityUnit
TechWithCapacityNeededToMeetPeakTS
CapacityFactor
AvailabilityFactor
OperationalLife
ResidualCapacity
InputActivityRatio
OutputActivityRatio

*
* ######## Technology Costs #############
*
CapitalCost
VariableCost
FixedCost

*
* ######## Storage Parameters #############
*
StorageInflectionTimes
TechnologyToStorage
TechnologyFromStorage
StorageUpperLimit
StorageLowerLimit

*
* ######## Capacity Constraints #############
*
TotalAnnualMaxCapacity
TotalAnnualMinCapacity

*
* ######## Investment Constraints #############
*
TotalAnnualMaxCapacityInvestment
TotalAnnualMinCapacityInvestment

*
* ######## Activity Constraints #############
*
TotalTechnologyAnnualActivityUpperLimit
TotalTechnologyAnnualActivityLowerLimit
TotalTechnologyModelPeriodActivityUpperLimit
TotalTechnologyModelPeriodActivityLowerLimit

*
* ######## Reserve Margin ############
*
ReserveMarginTagTechnology
ReserveMarginTagFuel
ReserveMargin

*
* ######## RE Generation Target ############
*
RETagTechnology
RETagFuel
REMinProductionTarget

*
* ######### Emissions & Penalties #############
*
EmissionActivityRatio
EmissionsPenalty
AnnualExogenousEmission
AnnualEmissionLimit
ModelPeriodExogenousEmission
ModelPeriodEmissionLimit

*
YearVal


*------------------------------------------------------------------------	
* Model variables
*------------------------------------------------------------------------

* ############### Demand ############*
*
RateOfDemand
Demand

* ############### Capacity Variables ############*
*
NewCapacity
AccumulatedNewCapacity
TotalCapacityAnnual

*
*############### Activity Variables #############
*
RateOfActivity
RateOfTotalActivity
TotalTechnologyAnnualActivity
TotalAnnualTechnologyActivityByMode
RateOfProductionByTechnologyByMode
RateOfProductionByTechnology
ProductionByTechnology
ProductionByTechnologyAnnual
RateOfProduction
Production
RateOfUseByTechnologyByMode
RateOfUseByTechnology
UseByTechnologyAnnual
RateOfUse
UseByTechnology
Use
*
ProductionAnnual
UseAnnual
*

* ############### Costing Variables #############
*
CapitalInvestment
DiscountedCapitalInvestment
*
SalvageValue
DiscountedSalvageValue
OperatingCost
DiscountedOperatingCost
*
AnnualVariableOperatingCost
AnnualFixedOperatingCost
VariableOperatingCost
*
TotalDiscountedCost
*
ModelPeriodCostByRegion 

*
* ############### Storage Variables #############
*
NetStorageCharge
StorageLevel
StorageCharge
StorageDischarge

*
* ######## Reserve Margin #############
*
TotalCapacityInReserveMargin
DemandNeedingReserveMargin

*
* ######## RE Gen Target #############
*
TotalGenerationByRETechnologies
TotalREProductionAnnual
RETotalDemandOfTargetFuelAnnual
*
TotalTechnologyModelPeriodActivity

*
* ######## Emissions #############
*
AnnualTechnologyEmissionByMode
AnnualTechnologyEmission
AnnualTechnologyEmissionPenaltyByEmission
AnnualTechnologyEmissionsPenalty
DiscountedTechnologyEmissionsPenalty
AnnualEmissions
EmissionsProduction
ModelPeriodEmissions
  
z
;