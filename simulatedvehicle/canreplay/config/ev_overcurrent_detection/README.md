# Simulation for overcurrent scenario
The files in this folder have the purpoe to simulate a simplified overcurrent scenario for an EV. The values are artificial and are only for demonstration purposes.

## Scenario description

t 1 to 60 healthy
t 61 to 120 increase
t 121 BatteryPack01ShuntPlusCurrent and BatteryPack01Cell001Temperature are above threshold
t 181 to 300 healthy

## Signal names
1. ActualVehicleSpeed_kph
2. BatteryPack01ShuntPlusCurrent_a
3. BatteryPack01ShuntPlusCurrentQualifier_enum
4. BatteryPack01ShuntMinusCurrent_a
5. BatteryPack01ShuntMinusCurrentQualifier_enum
6. BatteryPack01RelayStatus_enum
7. BatteryPack01RelayStatusQualifier_enum
8. BatteryPack01BatteryPack01VoltagePlus_v
9. BatteryPack01BatteryPack01VoltageMinus_v
10. BateryPack01Cell001Temperature_c



## ActualVehicleSpeed_kph
Unit: kph
Range: 0 to 200

## BatteryPack01ShuntPlusCurrent_a 

Unit: ampere
Range: 300 in normal state, up to 450 in case of overcurrent, 5% random deviation

## BatteryPack01ShuntPlusCurrentQualifier_enum

0 = Valid value
1 = Invalid value


## BatteryPack01ShuntMinusCurrent_a

Unit: ampere
Range: 300 in normal state, up to 450 in case of overcurrent, 5% random deviation


## BatteryPack01ShuntMinusCurrentQualifier_enum

0 = Valid value
1 = Invalid value

## BatteryPack01RelayStatus_enum

0 = Relay active
1 = Relay separated 

The simulation will switch from 0 to 1 once ShuntPlusCurrent is above 450, and will switch back to 0 once current is at 300

## BatteryPack01RelayStatus_qualifier_enum

0 = Valid value
1 = Invalid value

## BatteryPack01BatteryPack01VoltagePlus_v

Range: 192, 5% random deviation

## BatteryPack01BatteryPack01VoltageMinus_v

Range: 192, 5% random deviation

## BatteryPack01Cell001Temperature_c

Range: between 10 and 20 Celsius in a healthy state, up to 150 Celsius in an unhealthy state
