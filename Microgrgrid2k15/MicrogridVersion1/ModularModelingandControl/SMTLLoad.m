clear classes

syms phi dphidt real

% Generators
G23 = SM7StateControl({'_G23'},phi,dphidt);

% Transmission Lines
% Bus 2
TL_2_23 = TransmissionLine({'_TL_2_23'},phi,dphidt);

% Loads
L2 = PQLoad({'_L2'},phi,dphidt);
%IM2 = InductionMachine({'_IM2'},phi,dphidt);

% Modules
Modules = {G23,...
    L2,...
    TL_2_23};%...
    %IM2};
    
% Buses
Bus23 = {{G23}, {TL_2_23, 'R'}};
Bus2 = {{TL_2_23, 'L'}, {L2}};
Buses = {Bus2, Bus23};

G = ProduceGMatrix(Modules,Buses);
 
PS = PowerSystem(G,Modules);
PS.PrintMFileWithStateSpace(PS,'Equations/SMTLLoad.txt')
