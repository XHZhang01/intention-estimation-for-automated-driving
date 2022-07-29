% Example Generation for Testing Fusion Framework
% Xuhui Zhang, 17.06.2022

%% Increasing Sources with Consistent or Conflicting Opinions

n = 1000;
belief = cell(1,n);
for i = 1:n
    a1 = 0.2+0.1*rand; b1 = 0.05*rand; c1 = 0.05*rand; d1 = 1-a1-b1-c1;
    v1 = [a1;b1;c1;d1];
    a2 = 0.2+0.1*rand; b2 = 0.05*rand; c2 = 0.05*rand; d2 = 1-a2-b2-c2;
    v2 = [a2;b2;c2;d2];
    a3 = 0.2+0.1*rand; b3 = 0.05*rand; c3 = 0.05*rand; d3 = 1-a3-b3-c3;
    v3 = [a3;b3;c3;d3];
    a4 = 0.2+0.1*rand; b4 = 0.05*rand; c4 = 0.05*rand; d4 = 1-a4-b4-c4;
    v4 = [a4;b4;c4;d4];
    a5 = 0.2+0.1*rand; b5 = 0.05*rand; c5 = 0.05*rand; d5 = 1-a5-b5-c5;
    v5 = [a5;b5;c5;d5];
    a6 = 0.2+0.1*rand; b6 = 0.05*rand; c6 = 0.05*rand; d6 = 1-a6-b6-c6;
    v6 = [a6;b6;c6;d6];
    a7 = 0.2+0.1*rand; b7 = 0.05*rand; c7 = 0.05*rand; d7 = 1-a7-b7-c7;
    v7 = [a7;b7;c7;d7];
    a8 = 0.2+0.1*rand; b8 = 0.05*rand; c8 = 0.05*rand; d8 = 1-a8-b8-c8;
    v8 = [a8;b8;c8;d8];
    a9 = 0.2+0.1*rand; b9 = 0.05*rand; c9 = 0.05*rand; d9 = 1-a9-b9-c9;
    v9 = [a9;b9;c9;d9];
    a10 = 0.2+0.1*rand; b10 = 0.05*rand; c10 = 0.05*rand; d10 = 1-a10-b10-c10;
    v10 = [a10;b10;c10;d10];
    % v2 = [b2;a2;c2];
    belief{i} = [v1 v2 v3 v4 v5 v6 v7 v8 v9 v10];
end

%% Two Sources with Conflicting Opinions at the Beginning and Consistent Opinions at the End

n1 = 500; n2 = 1000; n3 = 1500; n4 = 2000;
belief = cell(1, n2);

% sudden change
for i = 1:n1
    a1 = 0.7 + 0.1 * rand; b1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    b2 = 0.7 + 0.1 * rand; a2 = 0.1 * rand; c2 = 1 - a2 - b2;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end
for i = (n1 + 1):n2
    a1 = 0.7 + 0.1 * rand; b1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    a2 = 0.7 + 0.1 * rand; b2 = 0.1 * rand; c2 = 1 - a2 - b2;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end

% continuous change
k = 0.7/1000;
for i = 1:n1
    a1 = 0.7 + 0.1 * rand; b1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    b2 = 0.7 + 0.1 * rand; a2 = 0.1 * rand; c2 = 1 - a2 - b2;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end
for i = (n1 + 1):n3
    a1 = 0.7 + 0.1 * rand; b1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    b2 = 0.7 - k * (i - n1) + 0.1 * rand; a2 = k * (i - n1) + 0.1 * rand; c2 = 1 - a1 - b1;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end
for i = (n3 + 1):n4
    a1 = 0.7 + 0.1 * rand; b1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    a2 = 0.7 + 0.1 * rand; b2 = 0.1 * rand; c2 = 1 - a2 - b2;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end

%% Two Sources with Conflicting Opinions at the Beginning and Conflicting Opinions at the End (Continuous Switching)

n1 = 500; n2 = 1000; n3 = 1500; n4 = 2000;
belief = cell(1, n2);

k = 0.7/1000;
for i = 1:n1
    a1 = 0.7 + 0.1 * rand; b1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    b2 = 0.7 + 0.1 * rand; a2 = 0.1 * rand; c2 = 1 - a2 - b2;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end
for i = (n1 + 1):n3
    a1 = 0.7 - k * (i - n1) + 0.1 * rand; b1 = k * (i - n1) + 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    b2 = 0.7 - k * (i - n1) + 0.1 * rand; a2 = k * (i - n1) + 0.1 * rand; c2 = 1 - a1 - b1;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end
for i = (n3 + 1):n4
    b1 = 0.7 + 0.1 * rand; a1 = 0.1 * rand; c1 = 1 - a1 - b1;
    v1 = [a1;b1;c1];
    a2 = 0.7 + 0.1 * rand; b2 = 0.1 * rand; c2 = 1 - a2 - b2;
    v2 = [a2;b2;c2];
    belief{i} = [v1 v2];
end