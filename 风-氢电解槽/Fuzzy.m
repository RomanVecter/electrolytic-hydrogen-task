clc;
clear;

%%fuzzy control
tipFIS=mamfis(...
    'Name','Fuzzy Tipping',...
    'NumInputs',1,'NumInputMFs',5,...
    'NumOutputs',1,'NumOutputMFs',5,...
    'AddRule','none'...
    );

%%Update Input
tipFIS.Inputs(1).Name='功率误差e';
tipFIS.Inputs(1).Range=[-100 100];%%输入范围
tipFIS.Inputs(1).MembershipFunctions(1).Name='NB';
tipFIS.Inputs(1).MembershipFunctions(1).Type='trimf';
tipFIS.Inputs(1).MembershipFunctions(1).Parameters=[-200 -100 0 ];
tipFIS.Inputs(1).MembershipFunctions(2).Name='NS';
tipFIS.Inputs(1).MembershipFunctions(2).Type='trimf';
tipFIS.Inputs(1).MembershipFunctions(2).Parameters=[-150 -50 50 ];
tipFIS.Inputs(1).MembershipFunctions(3).Name='Z';
tipFIS.Inputs(1).MembershipFunctions(3).Type='trimf';
tipFIS.Inputs(1).MembershipFunctions(3).Parameters=[-100 0 100];
tipFIS.Inputs(1).MembershipFunctions(4).Name='PS';
tipFIS.Inputs(1).MembershipFunctions(4).Type='trimf';
tipFIS.Inputs(1).MembershipFunctions(4).Parameters=[-50 50 150];
tipFIS.Inputs(1).MembershipFunctions(5).Name='PB';
tipFIS.Inputs(1).MembershipFunctions(5).Type='trimf';
tipFIS.Inputs(1).MembershipFunctions(5).Parameters=[0 100 200];

%%Update Output
tipFIS.Outputs(1).Name='输出功率';
tipFIS.Outputs(1).Range=[0 100];%%输入范围
tipFIS.Outputs(1).MembershipFunctions(1).Name='NB';
tipFIS.Outputs(1).MembershipFunctions(1).Type='trimf';
tipFIS.Outputs(1).MembershipFunctions(1).Parameters=[-50 0 50 ];
tipFIS.Outputs(1).MembershipFunctions(2).Name='NS';
tipFIS.Outputs(1).MembershipFunctions(2).Type='trimf';
tipFIS.Outputs(1).MembershipFunctions(2).Parameters=[-25 25 75 ];
tipFIS.Outputs(1).MembershipFunctions(3).Name='Z';
tipFIS.Outputs(1).MembershipFunctions(3).Type='trimf';
tipFIS.Outputs(1).MembershipFunctions(3).Parameters=[0 50 100];
tipFIS.Outputs(1).MembershipFunctions(4).Name='PS';
tipFIS.Outputs(1).MembershipFunctions(4).Type='trimf';
tipFIS.Outputs(1).MembershipFunctions(4).Parameters=[25 75 125];
tipFIS.Outputs(1).MembershipFunctions(5).Name='PB';
tipFIS.Outputs(1).MembershipFunctions(5).Type='trimf';
tipFIS.Outputs(1).MembershipFunctions(5).Parameters=[50 100 150];
subplot(2,1,1)
plotmf(tipFIS,'input',1,1000);
subplot(2,1,2)
plotmf(tipFIS,'output',1,1000);
ruleList = [1 1 1 1; 2 2 1 1; 3 3 1 1;4 4 1 1;5 5 1 1]; % 模糊规则矩阵
figure
tipFIS = addrule(tipFIS, ruleList);
gensurf(tipFIS)
temperature = 75;
fanSpeed = evalfis(temperature, tipFIS)
