% Plot Belief Mass of Each Reference and Uncertainty
% Xuhui Zhang, 24.05.2022

index_real_tracking = 1;
plot(belief_mass(index_real_tracking,:));
hold on
plot(belief_mass(index_real_tracking + 1,:));
hold on
plot(belief_mass(index_real_tracking - 1,:));
hold on
plot(belief_mass(end,:));
hold on

title('Belief Mass and Uncertainty with Real Tracking Reference y = for and for');
xlabel('time');
ylabel('belief mass or uncertainty');
legend('y = ','y = ','y = ','uncertainty');