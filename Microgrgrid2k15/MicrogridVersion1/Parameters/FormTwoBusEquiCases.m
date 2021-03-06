%Voltages
% filename = 'Case1_islndnoadjshunt14v95105_yesangles.txt';
% filename = 'Case1_islandedshunt14_adjustedloads_withangles.csv';

%Extracting voltages
% file1 = load(filename,'variable');
% V = file1(:,3);
Vol = [1	1.014	0.995	1.008
0.978	1.004	0.975	0.998
1	1.014	0.995	1.008
1	1.011	0.996	1.006
0.995	1.009	0.991	1.005
0.997	1.008	0.993	1.003
1	1.011	0.996	1.006
0.997	1.011	0.992	1.007
0.995	1.009	0.991	1.005
0.994	1.008	0.99	1.004
0.991	1.005	0.985	0.999
0.994	1.005	0.99	1
0.994	1.005	0.99	1
0.986	0.998	0.983	0.993
0.978	0.989	0.974	0.984
0.995	1.009	0.99	1.006
0.993	1.008	0.988	1.004
0.984	0.999	0.98	0.995
0.959	0.974	0.955	0.97
0.994	1.008	0.99	1.004
1.006	1.02	1	1.02
1	1.011	0.996	1.006
1.001	1.02	1	1.02
];
caseNum = 2;
switch caseNum
    case 1 
        V = Vol(:,1);
    case 2
        V = Vol(:,2);
    case 3 
        V = Vol(:,3);
    case 4
        V = Vol(:,4);
end
       
mpc = caseMicroUpdated;

%%

%Extracting powers and initialization
ybus = GeneralYbus(mpc);
% mpc.bus(17,3) = mpc.bus(17,3) + 0.3;
% mpc.bus(17,4) = mpc.bus(17,4) + 0.1;
% mpc.bus(21,3) = -1.5;
P = mpc.bus(:,3)/mpc.baseMVA; Q = mpc.bus(:,4)/mpc.baseMVA;
S = (P + 1i* Q);

switch caseNum
    case 1
        S(21) = -(3.5 + 1i*0.01)/mpc.baseMVA;
        S(22) = -(4 - 1i*0.41)/mpc.baseMVA;
        S(23) = -(1 - 1i*1)/mpc.baseMVA;
    case 2
        S(1) = -(1.13 + 1i*1.47)/mpc.baseMVA;
        S(21) = -(3.5 + 1i*0.01)/mpc.baseMVA;
        S(22) = -(1.26 + 1i*2.11)/mpc.baseMVA;
        S(23) = -(0.43 + 1i*0.02)/mpc.baseMVA;
    case 3
        S(21) = -(1.34 + 1i*0.32)/mpc.baseMVA;
        S(22) = -(4 + 1i*4)/mpc.baseMVA;
        S(23) = -(1 - 1i*0.87)/mpc.baseMVA;
    case 4
        S(21) = -(4 + 1i*0.17)/mpc.baseMVA;
        S(22) = -(1.77 + 1i*3.49)/mpc.baseMVA;
        S(23) = -(0.57 + 1i*0.03)/mpc.baseMVA;
end
       
len = size(mpc.bus,1);

%%
Smag = abs(S);
for i = 1:length(S)
    if(i==21)
        continue;
    else
        Yload(i) = conj(S(i))/V(i)^2;
    end
end


%%
%Adding load impedances
for i =1:len
    ybus(i,i) = ybus(i,i) + Yload(i);
end

%Kron's reduction
Nodes_stay = [21 22]; 
Nodes =  setdiff(1:23,Nodes_stay);

Yred=Kron(ybus,Nodes);

Yshunt = sum(Yred,1);
%%
Imp = zeros(length(Yred),length(Yred));
R = zeros(length(Yred),length(Yred));
L = zeros(length(Yred),length(Yred));
for i = 1:length(Yred)
    for j = 1:length(Yred)
        if(Yred(i,j)==0)
            continue;
        else
            Imp(i,j) = -1./Yred(i,j);
            R(i,j) = real(Imp(i,j));
            L(i,j) = imag(Imp(i,j));
        end        
    end
end
% Imp
% Zsh = zeros(length(Yshunt));
% for i = 1:length(Yshunt)
%     if(Yshunt(i)== 0)
%         continue;
%     else
%         Zsh = 1./Yshunt;
%     end
% end
%In order to have TL capacitances intact
% Yshunt = Yshunt - [0.03 0.01 0.01 0.01];
Zsh = 1./Yshunt;
Rsh = real(Zsh); Lsh = imag(Zsh);
%%
% %Loads
% SL1 = V(1)^2/conj(Zsh(1));
% SL21 = V(21)^2/conj(Zsh(2));
% SL22 = V(22)^2/conj(Zsh(3));
% SL23 = V(23)^2/conj(Zsh(4));

%Line MAx transfer
% S1_21 = V(1)*V(21)/abs(Imp(1,2))
% S1_22 = V(1)*V(22)/abs(Imp(1,3))
% S1_23 = V(1)*V(23)/abs(Imp(1,4))
%%s
%For the case of voltage with shunts
% RL_PV21 = P(21)*V(21)^2/(P(21)^2+Q(21)^2);
% LL_PV21 =(Q(21))*V(21)^2/(P(21)^2+Q(21)^2);
% save('PV21.mat', 'RL_PV21', 'LL_PV21');
% 
% RTL_TL_1_21 = R(1,2);
% LTL_TL_1_21 = L(1,2);
% CTL_TL_1_21 = 0.01;
% 
% RTL_TL_1_22 = R(1,3);
% LTL_TL_1_22 = L(1,3);
% CTL_TL_1_22 = 0.01;
% 
% RTL_TL_1_23 = R(1,4);
% LTL_TL_1_23 = L(1,4);
% CTL_TL_1_23 = 0.01;
% 
% save('TL_1_21.mat', 'LTL_TL_1_21', 'RTL_TL_1_21','CTL_TL_1_21');
% save('TL_1_22.mat', 'LTL_TL_1_22', 'RTL_TL_1_22','CTL_TL_1_22');
% save('TL_1_23.mat', 'LTL_TL_1_23', 'RTL_TL_1_23','CTL_TL_1_23');
% 
% RL_L21 = real(Zsh(2));
% LL_L21 = imag(Zsh(2));
% save('L21.mat', 'RL_L21', 'LL_L21');
% 
% RL_L22 = real(Zsh(3));
% LL_L22 = imag(Zsh(3));
% save('L22.mat', 'RL_L22', 'LL_L22');
% 
% RL_L23 = real(Zsh(4));
% LL_L23 = imag(Zsh(4));
% save('L23.mat', 'RL_L23', 'LL_L23');
% 
% RL_L1 = real(Zsh(1));
% LL_L1 = imag(Zsh(1));
% save('L1.mat', 'RL_L1', 'LL_L1');
