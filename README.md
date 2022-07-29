
# Intention Estimation for Automated Drving

These codes build a framework for estimation of other traffic participants' behaviors based on belief function theory.
The crossroad scenario is simulated with this framework.

## Important functions are listed below

From 1 to 11 is also the normal processing sequence of this approach.

## 1. multiple_sensors.m:
It simulates the crossroad scenario with opinions given by multiple sources. It can be directly called to simulate the scenario. All the other functions will be called in this funtion if needed.

## 2. multiple_references_crossroad.m:
In this function, reference tracking is conducted. States of all possible trajectories and measured states are output for further usage. In the crossroas scenario, three possible trajectories, namely "turning left", "straight" and "turning right".

## 3. belief_mass_measurement_generation.m:
This function generates belief at each instant based on measured state and states of all possible trajectories.

## 4. belief_mass_assignment_1D.m:
This function assigns belief mass with 1D normal PDF to each possible trajectory based on distance to the measured state (one single state, like y position).

## 5. belief_mass_assignment_4D.m:
This function assigns belief mass with 4D normal PDF to each possible trajectory based on distance to the measured state (full states, [x, vx, y, vy]).

## 6. multiplicator_change_freq_ampl.m:
It set uncertainty of each opinion based on belief distribution's perturbation within a given window size.

## 7. belief_fusion_framework.m:
The belief processing framework with "multi-source information fusion (with CBF)", "conflict detection and handling" and "belief distribution update (with WBF)".

## 8. degree_of_conflict.m:
It calculates the degree of conflict for a given set of opinions (opinions given by different sources at the same instant).

## 9. sensor_fusion.m:
It combines all opinions at the same instant with CBF.

## 10. adaptation_after_fusion.m:
This function transfers part of all belief masses to the uncertainty in the fused opinion of CBF based on degree of conflict.

## 11. weighted_belief_fusion.m:
This function updates the belief from previous instant with the fused opinion at the current instant with WBF.

## Usages of other functions are explained with comments, which can be found in the codes.