classdef InductionMachine < Module
    methods
        function this = InductionMachine(IndexName,RefFrameAngle,RefFrameSpeed)
            ParameterNames={'LR','LRR','LS','LSS','M','RR','RS','J','tauL','B'};
            ControllableInputNames = {};
            StateVariableNames = {'iSd','iSq','iRd','iRq','omega','theta'};
            PortInputNames = {'vSd','vSq'};
            PortStateNames = {'iSd','iSq'};

            this.RefFrameAngle = RefFrameAngle;
            this.RefFrameSpeed = RefFrameSpeed;
            this.Parameters = sym(sym(strcat(ParameterNames,IndexName)),'real');
            this.StateVariables = sym(sym(strcat(StateVariableNames,IndexName)),'real');
            this.ControllableInputs = sym(sym(strcat(ControllableInputNames,IndexName)),'real');
            this.PortInputs = sym(sym(strcat(PortInputNames,IndexName)),'real');
            this.PortStates = sym(sym(strcat(PortStateNames,IndexName)),'real');
            this.PortVoltages = this.PortInputs;
            this.PortCurrents = this.PortStates;
            this.StateVariableDerivatives = sym(sym(strcat('d',StateVariableNames,IndexName,'dt')),'real');
            this.PortStateDerivatives = sym(sym(strcat('d',PortStateNames,IndexName,'dt')),'real');
            this.PortStates_Time = sym(sym(strcat(PortStateNames,IndexName,'_t(t)')));
            this.PortStateTypes = {'Current','Current'};
            this.StateSpace = InductionMachine.InductionMachineDynamics(this.Parameters,this.StateVariables,this.ControllableInputs,...
                                                                             this.PortInputs,this.RefFrameAngle,this.RefFrameSpeed);
        end
    end
    methods(Static)
        function [StateSpace] = InductionMachineDynamics(Parameters,StateVariables,ControllableInputs,PortInputs,phi,dphidt)
            
            %Inputs____________________________________________
            %State Variables: iSd,iSq,iRd,iRq,omega,theta
            %Input Variables: vSd,vSq
            %Parameters: LR,LRR,LS,LSS,M,RR,RS,J,tauL,B
            %phi: angle of rotating reference frame
            %dphidt: speed of rotating reference frame
            %__________________________________________________
            
            %Outputs_________________________________________
            %StateSpace: [diSddt ; diSqdt ; diRddt ; diRqdt ; domegadt ; dthetadt]
            %_________________________________________________
            
            iSd = StateVariables(1);
            iSq = StateVariables(2);
            iRd  = StateVariables(3);
            iRq = StateVariables(4);
            omega = StateVariables(5);
            theta = StateVariables(6);
            
            vSd = PortInputs(1);
            vSq = PortInputs(2);
            
            LR = Parameters(1);
            LRR = Parameters(2);
            LS = Parameters(3);
            LSS = Parameters(4);
            M = Parameters(5);
            RR = Parameters(6);
            RS = Parameters(7);
            J = Parameters(8);
            tauL = Parameters(9);
            B = Parameters(10);
            
            diSddt = -377*((9*M^3*RR*iRd - 16*LR^2*LS*vSd + 32*LRR^2*LS*vSd + 32*LR^2*LSS*vSd - 64*LRR^2*LSS*vSd + 72*LR*M^2*vSd + 72*LRR*M^2*vSd - 162*M^4*dphidt*iSq + 3*M^3*RR*iRq*sin(2*theta) - 6*M^3*RR*iRd*sin(theta)^2 + 16*LR^2*LS*RS*iSd - 32*LRR^2*LS*RS*iSd - 32*LR^2*LSS*RS*iSd + 64*LRR^2*LSS*RS*iSd - 72*LR*M^2*RS*iSd - 72*LRR*M^2*RS*iSd - 48*LR*M^2*vSd*sin(theta)^2 - 48*LRR*M^2*vSd*sin(theta)^2 + 3*M^3*RR*iRq*sin(2*theta - (2*pi)/3) + 3*M^3*RR*iRq*sin((2*pi)/3 + 2*theta) - 6*M^3*RR*iRd*sin(theta - pi/3)^2 - 6*M^3*RR*iRd*sin(pi/3 + theta)^2 + 108*M^4*dphidt*iSq*sin(theta)^2 - 32*LR*M^2*vSd*sin(theta - pi/3)^2 - 32*LR*M^2*vSd*sin(pi/3 + theta)^2 - 16*LR*M^2*vSd*sin(theta - (2*pi)/3)^2 - 16*LR*M^2*vSd*sin((2*pi)/3 + theta)^2 - 32*LRR*M^2*vSd*sin(theta - pi/3)^2 - 32*LRR*M^2*vSd*sin(pi/3 + theta)^2 - 16*LRR*M^2*vSd*sin(theta - (2*pi)/3)^2 - 16*LRR*M^2*vSd*sin((2*pi)/3 + theta)^2 - 3*3^(1/2)*M^3*RR*iRq + 72*M^4*dphidt*iSq*sin(theta - pi/3)^2 + 72*M^4*dphidt*iSq*sin(pi/3 + theta)^2 + 36*M^4*dphidt*iSq*sin(theta - (2*pi)/3)^2 + 36*M^4*dphidt*iSq*sin((2*pi)/3 + theta)^2 + 3*M^4*iSd*omega*sin((2*pi)/3 + 2*theta) + 3*M^4*iSd*omega*sin(4*theta - (2*pi)/3) + 3*M^4*iSd*omega*sin((2*pi)/3 + 4*theta) - 3*M^4*iSd*omega*sin(2*theta - (4*pi)/3) - 3*M^4*iSd*omega*sin(4*theta - (4*pi)/3) - 3*M^4*iSd*omega*sin((4*pi)/3 + 4*theta) - 16*LR^2*LS^2*dphidt*iSq + 32*LRR^2*LS^2*dphidt*iSq + 32*LR^2*LSS^2*dphidt*iSq - 64*LRR^2*LSS^2*dphidt*iSq - 8*M^4*dphidt*iSq*sin(2*theta - pi/3)^2 - 8*M^4*dphidt*iSq*sin(pi/3 + 2*theta)^2 + 4*M^4*dphidt*iSq*sin(2*theta - (2*pi)/3)^2 + 4*M^4*dphidt*iSq*sin((2*pi)/3 + 2*theta)^2 + 4*M^4*dphidt*iSq*sin(2*theta - (4*pi)/3)^2 + 4*M^4*dphidt*iSq*sin((4*pi)/3 + 2*theta)^2 + 16*LR*LRR*LS*vSd - 32*LR*LRR*LSS*vSd - 16*LR*LRR*LS*RS*iSd + 32*LR*LRR*LSS*RS*iSd - 24*LR*LS*M*RR*iRd + 48*LRR*LS*M*RR*iRd + 48*LR*LSS*M*RR*iRd - 96*LRR*LSS*M*RR*iRd + 48*LR*M^2*RS*iSd*sin(theta)^2 + 48*LRR*M^2*RS*iSd*sin(theta)^2 + 32*LR*M^2*RS*iSd*sin(theta - pi/3)^2 + 32*LR*M^2*RS*iSd*sin(pi/3 + theta)^2 + 16*LR*M^2*RS*iSd*sin(theta - (2*pi)/3)^2 + 16*LR*M^2*RS*iSd*sin((2*pi)/3 + theta)^2 + 32*LRR*M^2*RS*iSd*sin(theta - pi/3)^2 + 32*LRR*M^2*RS*iSd*sin(pi/3 + theta)^2 + 16*LRR*M^2*RS*iSd*sin(theta - (2*pi)/3)^2 + 16*LRR*M^2*RS*iSd*sin((2*pi)/3 + theta)^2 + 3^(1/2)*M^3*RR*iRd*sin(2*theta) + 2*3^(1/2)*M^3*RR*iRq*sin(theta)^2 + 16*LR*LRR*LS^2*dphidt*iSq - 32*LR*LRR*LSS^2*dphidt*iSq + 16*LR^2*LS*LSS*dphidt*iSq - 32*LRR^2*LS*LSS*dphidt*iSq + 108*LR*LS*M^2*dphidt*iSq + 216*LRR*LSS*M^2*dphidt*iSq - 24*LR^2*LS*M*iRq*omega + 48*LRR^2*LS*M*iRq*omega + 48*LR^2*LSS*M*iRq*omega - 96*LRR^2*LSS*M*iRq*omega - 36*LR*LS*M^2*iSq*omega + 72*LRR*LS*M^2*iSq*omega + 72*LR*LSS*M^2*iSq*omega - 144*LRR*LSS*M^2*iSq*omega - 3^(1/2)*M^3*RR*iRd*sin(2*theta - (2*pi)/3) + 3*3^(1/2)*M^3*RR*iRd*sin((2*pi)/3 + 2*theta) + 2*3^(1/2)*M^3*RR*iRd*sin(4*theta - (2*pi)/3) - 2*3^(1/2)*M^3*RR*iRd*sin((2*pi)/3 + 4*theta) - 2*3^(1/2)*M^3*RR*iRd*sin(2*theta - (4*pi)/3) + 2*3^(1/2)*M^3*RR*iRd*sin((4*pi)/3 + 2*theta) + 2*3^(1/2)*M^3*RR*iRd*sin(4*theta - (4*pi)/3) - 2*3^(1/2)*M^3*RR*iRd*sin((4*pi)/3 + 4*theta) + 6*3^(1/2)*M^3*RR*iRq*sin(theta - pi/3)^2 - 2*3^(1/2)*M^3*RR*iRq*sin(pi/3 + theta)^2 + 4*3^(1/2)*M^3*RR*iRq*sin(theta - (2*pi)/3)^2 - 4*3^(1/2)*M^3*RR*iRq*sin((2*pi)/3 + theta)^2 - 2*3^(1/2)*M^4*iSq*omega*sin(2*theta - (2*pi)/3) + 3*3^(1/2)*M^4*iSq*omega*sin((2*pi)/3 + 2*theta) + 3^(1/2)*M^4*iSq*omega*sin(4*theta - (2*pi)/3) - 3^(1/2)*M^4*iSq*omega*sin((2*pi)/3 + 4*theta) - 3*3^(1/2)*M^4*iSq*omega*sin(2*theta - (4*pi)/3) + 2*3^(1/2)*M^4*iSq*omega*sin((4*pi)/3 + 2*theta) + 3^(1/2)*M^4*iSq*omega*sin(4*theta - (4*pi)/3) - 3^(1/2)*M^4*iSq*omega*sin((4*pi)/3 + 4*theta) + 4*3^(1/2)*M^3*RR*iRq*sin(2*theta - pi/3)^2 - 4*3^(1/2)*M^3*RR*iRq*sin(pi/3 + 2*theta)^2 + 4*3^(1/2)*M^3*RR*iRq*sin(2*theta - (2*pi)/3)^2 - 4*3^(1/2)*M^3*RR*iRq*sin((2*pi)/3 + 2*theta)^2 + 4*3^(1/2)*LR*M^3*iRd*omega*sin(2*theta - pi/3)^2 - 4*3^(1/2)*LR*M^3*iRd*omega*sin(pi/3 + 2*theta)^2 + 4*3^(1/2)*LR*M^3*iRd*omega*sin(2*theta - (2*pi)/3)^2 - 4*3^(1/2)*LR*M^3*iRd*omega*sin((2*pi)/3 + 2*theta)^2 + 4*3^(1/2)*LRR*M^3*iRd*omega*sin(2*theta - pi/3)^2 - 4*3^(1/2)*LRR*M^3*iRd*omega*sin(pi/3 + 2*theta)^2 + 4*3^(1/2)*LRR*M^3*iRd*omega*sin(2*theta - (2*pi)/3)^2 - 4*3^(1/2)*LRR*M^3*iRd*omega*sin((2*pi)/3 + 2*theta)^2 - 8*LR*LS*M*RR*iRq*sin(2*theta) + 16*LRR*LS*M*RR*iRq*sin(2*theta) + 16*LR*LSS*M*RR*iRq*sin(2*theta) - 32*LRR*LSS*M*RR*iRq*sin(2*theta) + 16*LR*LS*M*RR*iRd*sin(theta)^2 - 32*LRR*LS*M*RR*iRd*sin(theta)^2 - 32*LR*LSS*M*RR*iRd*sin(theta)^2 + 64*LRR*LSS*M*RR*iRd*sin(theta)^2 + 4*LR*LS*M*RR*iRq*sin(2*theta - (2*pi)/3) + 4*LR*LS*M*RR*iRq*sin((2*pi)/3 + 2*theta) - 8*LRR*LS*M*RR*iRq*sin(2*theta - (2*pi)/3) - 8*LRR*LS*M*RR*iRq*sin((2*pi)/3 + 2*theta) - 8*LR*LSS*M*RR*iRq*sin(2*theta - (2*pi)/3) - 8*LR*LSS*M*RR*iRq*sin((2*pi)/3 + 2*theta) + 16*LRR*LSS*M*RR*iRq*sin(2*theta - (2*pi)/3) + 16*LRR*LSS*M*RR*iRq*sin((2*pi)/3 + 2*theta) - 8*LR*LS*M*RR*iRd*sin(theta - pi/3)^2 - 8*LR*LS*M*RR*iRd*sin(pi/3 + theta)^2 + 16*LRR*LS*M*RR*iRd*sin(theta - pi/3)^2 + 16*LRR*LS*M*RR*iRd*sin(pi/3 + theta)^2 + 16*LR*LSS*M*RR*iRd*sin(theta - pi/3)^2 + 16*LR*LSS*M*RR*iRd*sin(pi/3 + theta)^2 - 32*LRR*LSS*M*RR*iRd*sin(theta - pi/3)^2 - 32*LRR*LSS*M*RR*iRd*sin(pi/3 + theta)^2 - 16*LR*LRR*LS*LSS*dphidt*iSq + 24*LR*LRR*LS*M*iRq*omega - 48*LR*LRR*LSS*M*iRq*omega - 48*LR*LS*M^2*dphidt*iSq*sin(theta)^2 - 48*LRR*LS*M^2*dphidt*iSq*sin(theta)^2 - 48*LR*LSS*M^2*dphidt*iSq*sin(theta)^2 - 48*LRR*LSS*M^2*dphidt*iSq*sin(theta)^2 - 8*LR^2*LS*M*iRd*omega*sin(2*theta) + 16*LRR^2*LS*M*iRd*omega*sin(2*theta) + 16*LR^2*LSS*M*iRd*omega*sin(2*theta) - 32*LRR^2*LSS*M*iRd*omega*sin(2*theta) - 16*LR^2*LS*M*iRq*omega*sin(theta)^2 + 32*LRR^2*LS*M*iRq*omega*sin(theta)^2 + 32*LR^2*LSS*M*iRq*omega*sin(theta)^2 - 64*LRR^2*LSS*M*iRq*omega*sin(theta)^2 - 16*LR*LS*M^2*dphidt*iSq*sin(theta - pi/3)^2 - 16*LR*LS*M^2*dphidt*iSq*sin(pi/3 + theta)^2 - 32*LR*LS*M^2*dphidt*iSq*sin(theta - (2*pi)/3)^2 - 32*LR*LS*M^2*dphidt*iSq*sin((2*pi)/3 + theta)^2 - 64*LRR*LS*M^2*dphidt*iSq*sin(theta - pi/3)^2 - 64*LRR*LS*M^2*dphidt*iSq*sin(pi/3 + theta)^2 + 16*LRR*LS*M^2*dphidt*iSq*sin(theta - (2*pi)/3)^2 + 16*LRR*LS*M^2*dphidt*iSq*sin((2*pi)/3 + theta)^2 - 64*LR*LSS*M^2*dphidt*iSq*sin(theta - pi/3)^2 - 64*LR*LSS*M^2*dphidt*iSq*sin(pi/3 + theta)^2 + 16*LR*LSS*M^2*dphidt*iSq*sin(theta - (2*pi)/3)^2 + 16*LR*LSS*M^2*dphidt*iSq*sin((2*pi)/3 + theta)^2 + 32*LRR*LSS*M^2*dphidt*iSq*sin(theta - pi/3)^2 + 32*LRR*LSS*M^2*dphidt*iSq*sin(pi/3 + theta)^2 - 80*LRR*LSS*M^2*dphidt*iSq*sin(theta - (2*pi)/3)^2 - 80*LRR*LSS*M^2*dphidt*iSq*sin((2*pi)/3 + theta)^2 + 4*LR^2*LS*M*iRd*omega*sin(2*theta - (2*pi)/3) + 4*LR^2*LS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*LRR^2*LS*M*iRd*omega*sin(2*theta - (2*pi)/3) - 8*LRR^2*LS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*LR^2*LSS*M*iRd*omega*sin(2*theta - (2*pi)/3) - 8*LR^2*LSS*M*iRd*omega*sin((2*pi)/3 + 2*theta) + 16*LRR^2*LSS*M*iRd*omega*sin(2*theta - (2*pi)/3) + 16*LRR^2*LSS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*LR*LS*M^2*iSd*omega*sin(2*theta - (2*pi)/3) - 8*LR*LS*M^2*iSd*omega*sin((2*pi)/3 + 2*theta) + 8*LR*LS*M^2*iSd*omega*sin(2*theta - (4*pi)/3) + 8*LR*LS*M^2*iSd*omega*sin((4*pi)/3 + 2*theta) + 16*LRR*LS*M^2*iSd*omega*sin(2*theta - (2*pi)/3) + 16*LRR*LS*M^2*iSd*omega*sin((2*pi)/3 + 2*theta) - 16*LRR*LS*M^2*iSd*omega*sin(2*theta - (4*pi)/3) - 16*LRR*LS*M^2*iSd*omega*sin((4*pi)/3 + 2*theta) + 16*LR*LSS*M^2*iSd*omega*sin(2*theta - (2*pi)/3) + 16*LR*LSS*M^2*iSd*omega*sin((2*pi)/3 + 2*theta) - 16*LR*LSS*M^2*iSd*omega*sin(2*theta - (4*pi)/3) - 16*LR*LSS*M^2*iSd*omega*sin((4*pi)/3 + 2*theta) - 32*LRR*LSS*M^2*iSd*omega*sin(2*theta - (2*pi)/3) - 32*LRR*LSS*M^2*iSd*omega*sin((2*pi)/3 + 2*theta) + 32*LRR*LSS*M^2*iSd*omega*sin(2*theta - (4*pi)/3) + 32*LRR*LSS*M^2*iSd*omega*sin((4*pi)/3 + 2*theta) + 8*LR^2*LS*M*iRq*omega*sin(theta - pi/3)^2 + 8*LR^2*LS*M*iRq*omega*sin(pi/3 + theta)^2 - 16*LRR^2*LS*M*iRq*omega*sin(theta - pi/3)^2 - 16*LRR^2*LS*M*iRq*omega*sin(pi/3 + theta)^2 - 16*LR^2*LSS*M*iRq*omega*sin(theta - pi/3)^2 - 16*LR^2*LSS*M*iRq*omega*sin(pi/3 + theta)^2 + 32*LRR^2*LSS*M*iRq*omega*sin(theta - pi/3)^2 + 32*LRR^2*LSS*M*iRq*omega*sin(pi/3 + theta)^2 - 4*3^(1/2)*LR*M^3*iRq*omega*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LR*M^3*iRq*omega*sin((2*pi)/3 + 2*theta) - 2*3^(1/2)*LR*M^3*iRq*omega*sin(4*theta - (2*pi)/3) + 2*3^(1/2)*LR*M^3*iRq*omega*sin((2*pi)/3 + 4*theta) - 4*3^(1/2)*LR*M^3*iRq*omega*sin(2*theta - (4*pi)/3) + 4*3^(1/2)*LR*M^3*iRq*omega*sin((4*pi)/3 + 2*theta) - 2*3^(1/2)*LR*M^3*iRq*omega*sin(4*theta - (4*pi)/3) + 2*3^(1/2)*LR*M^3*iRq*omega*sin((4*pi)/3 + 4*theta) - 4*3^(1/2)*LRR*M^3*iRq*omega*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LRR*M^3*iRq*omega*sin((2*pi)/3 + 2*theta) - 2*3^(1/2)*LRR*M^3*iRq*omega*sin(4*theta - (2*pi)/3) + 2*3^(1/2)*LRR*M^3*iRq*omega*sin((2*pi)/3 + 4*theta) - 4*3^(1/2)*LRR*M^3*iRq*omega*sin(2*theta - (4*pi)/3) + 4*3^(1/2)*LRR*M^3*iRq*omega*sin((4*pi)/3 + 2*theta) - 2*3^(1/2)*LRR*M^3*iRq*omega*sin(4*theta - (4*pi)/3) + 2*3^(1/2)*LRR*M^3*iRq*omega*sin((4*pi)/3 + 4*theta) + 4*3^(1/2)*LR^2*LS*M*iRq*omega*sin(2*theta - (2*pi)/3) - 4*3^(1/2)*LR^2*LS*M*iRq*omega*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LRR^2*LS*M*iRq*omega*sin(2*theta - (2*pi)/3) + 8*3^(1/2)*LRR^2*LS*M*iRq*omega*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR^2*LSS*M*iRq*omega*sin(2*theta - (2*pi)/3) + 8*3^(1/2)*LR^2*LSS*M*iRq*omega*sin((2*pi)/3 + 2*theta) + 16*3^(1/2)*LRR^2*LSS*M*iRq*omega*sin(2*theta - (2*pi)/3) - 16*3^(1/2)*LRR^2*LSS*M*iRq*omega*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR^2*LS*M*iRd*omega*sin(theta - pi/3)^2 + 8*3^(1/2)*LR^2*LS*M*iRd*omega*sin(pi/3 + theta)^2 + 16*3^(1/2)*LRR^2*LS*M*iRd*omega*sin(theta - pi/3)^2 - 16*3^(1/2)*LRR^2*LS*M*iRd*omega*sin(pi/3 + theta)^2 + 16*3^(1/2)*LR^2*LSS*M*iRd*omega*sin(theta - pi/3)^2 - 16*3^(1/2)*LR^2*LSS*M*iRd*omega*sin(pi/3 + theta)^2 - 32*3^(1/2)*LRR^2*LSS*M*iRd*omega*sin(theta - pi/3)^2 + 32*3^(1/2)*LRR^2*LSS*M*iRd*omega*sin(pi/3 + theta)^2 + 8*LR*LRR*LS*M*iRd*omega*sin(2*theta) - 16*LR*LRR*LSS*M*iRd*omega*sin(2*theta) + 16*LR*LRR*LS*M*iRq*omega*sin(theta)^2 - 32*LR*LRR*LSS*M*iRq*omega*sin(theta)^2 - 4*3^(1/2)*LR*LS*M*RR*iRd*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LR*LS*M*RR*iRd*sin((2*pi)/3 + 2*theta) + 8*3^(1/2)*LRR*LS*M*RR*iRd*sin(2*theta - (2*pi)/3) - 8*3^(1/2)*LRR*LS*M*RR*iRd*sin((2*pi)/3 + 2*theta) + 8*3^(1/2)*LR*LSS*M*RR*iRd*sin(2*theta - (2*pi)/3) - 8*3^(1/2)*LR*LSS*M*RR*iRd*sin((2*pi)/3 + 2*theta) - 16*3^(1/2)*LRR*LSS*M*RR*iRd*sin(2*theta - (2*pi)/3) + 16*3^(1/2)*LRR*LSS*M*RR*iRd*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR*LS*M*RR*iRq*sin(theta - pi/3)^2 + 8*3^(1/2)*LR*LS*M*RR*iRq*sin(pi/3 + theta)^2 + 16*3^(1/2)*LRR*LS*M*RR*iRq*sin(theta - pi/3)^2 - 16*3^(1/2)*LRR*LS*M*RR*iRq*sin(pi/3 + theta)^2 + 16*3^(1/2)*LR*LSS*M*RR*iRq*sin(theta - pi/3)^2 - 16*3^(1/2)*LR*LSS*M*RR*iRq*sin(pi/3 + theta)^2 - 32*3^(1/2)*LRR*LSS*M*RR*iRq*sin(theta - pi/3)^2 + 32*3^(1/2)*LRR*LSS*M*RR*iRq*sin(pi/3 + theta)^2 - 4*LR*LRR*LS*M*iRd*omega*sin(2*theta - (2*pi)/3) - 4*LR*LRR*LS*M*iRd*omega*sin((2*pi)/3 + 2*theta) + 8*LR*LRR*LSS*M*iRd*omega*sin(2*theta - (2*pi)/3) + 8*LR*LRR*LSS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*LR*LRR*LS*M*iRq*omega*sin(theta - pi/3)^2 - 8*LR*LRR*LS*M*iRq*omega*sin(pi/3 + theta)^2 + 16*LR*LRR*LSS*M*iRq*omega*sin(theta - pi/3)^2 + 16*LR*LRR*LSS*M*iRq*omega*sin(pi/3 + theta)^2 - 4*3^(1/2)*LR*LRR*LS*M*iRq*omega*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LR*LRR*LS*M*iRq*omega*sin((2*pi)/3 + 2*theta) + 8*3^(1/2)*LR*LRR*LSS*M*iRq*omega*sin(2*theta - (2*pi)/3) - 8*3^(1/2)*LR*LRR*LSS*M*iRq*omega*sin((2*pi)/3 + 2*theta) + 8*3^(1/2)*LR*LRR*LS*M*iRd*omega*sin(theta - pi/3)^2 - 8*3^(1/2)*LR*LRR*LS*M*iRd*omega*sin(pi/3 + theta)^2 - 16*3^(1/2)*LR*LRR*LSS*M*iRd*omega*sin(theta - pi/3)^2 + 16*3^(1/2)*LR*LRR*LSS*M*iRd*omega*sin(pi/3 + theta)^2)/(162*M^4 - 72*M^4*sin(theta - pi/3)^2 - 72*M^4*sin(pi/3 + theta)^2 - 36*M^4*sin(theta - (2*pi)/3)^2 - 36*M^4*sin((2*pi)/3 + theta)^2 - 108*M^4*sin(theta)^2 + 16*LR^2*LS^2 - 32*LRR^2*LS^2 - 32*LR^2*LSS^2 + 64*LRR^2*LSS^2 + 8*M^4*sin(2*theta - pi/3)^2 + 8*M^4*sin(pi/3 + 2*theta)^2 - 4*M^4*sin(2*theta - (2*pi)/3)^2 - 4*M^4*sin((2*pi)/3 + 2*theta)^2 - 4*M^4*sin(2*theta - (4*pi)/3)^2 - 4*M^4*sin((4*pi)/3 + 2*theta)^2 - 16*LR*LRR*LS^2 + 32*LR*LRR*LSS^2 - 16*LR^2*LS*LSS + 32*LRR^2*LS*LSS - 108*LR*LS*M^2 - 216*LRR*LSS*M^2 + 16*LR*LRR*LS*LSS + 48*LR*LS*M^2*sin(theta)^2 + 48*LRR*LS*M^2*sin(theta)^2 + 48*LR*LSS*M^2*sin(theta)^2 + 48*LRR*LSS*M^2*sin(theta)^2 + 16*LR*LS*M^2*sin(theta - pi/3)^2 + 16*LR*LS*M^2*sin(pi/3 + theta)^2 + 32*LR*LS*M^2*sin(theta - (2*pi)/3)^2 + 32*LR*LS*M^2*sin((2*pi)/3 + theta)^2 + 64*LRR*LS*M^2*sin(theta - pi/3)^2 + 64*LRR*LS*M^2*sin(pi/3 + theta)^2 - 16*LRR*LS*M^2*sin(theta - (2*pi)/3)^2 - 16*LRR*LS*M^2*sin((2*pi)/3 + theta)^2 + 64*LR*LSS*M^2*sin(theta - pi/3)^2 + 64*LR*LSS*M^2*sin(pi/3 + theta)^2 - 16*LR*LSS*M^2*sin(theta - (2*pi)/3)^2 - 16*LR*LSS*M^2*sin((2*pi)/3 + theta)^2 - 32*LRR*LSS*M^2*sin(theta - pi/3)^2 - 32*LRR*LSS*M^2*sin(pi/3 + theta)^2 + 80*LRR*LSS*M^2*sin(theta - (2*pi)/3)^2 + 80*LRR*LSS*M^2*sin((2*pi)/3 + theta)^2));
            diSqdt = 377*((16*LR^2*LS*vSq - 9*M^3*RR*iRq - 32*LRR^2*LS*vSq - 32*LR^2*LSS*vSq + 64*LRR^2*LSS*vSq - 72*LR*M^2*vSq - 72*LRR*M^2*vSq - 162*M^4*dphidt*iSd + 3*M^3*RR*iRd*sin(2*theta) + 6*M^3*RR*iRq*sin(theta)^2 - 16*LR^2*LS*RS*iSq + 32*LRR^2*LS*RS*iSq + 32*LR^2*LSS*RS*iSq - 64*LRR^2*LSS*RS*iSq + 72*LR*M^2*RS*iSq + 72*LRR*M^2*RS*iSq + 48*LR*M^2*vSq*sin(theta)^2 + 48*LRR*M^2*vSq*sin(theta)^2 + 3*M^3*RR*iRd*sin(2*theta - (2*pi)/3) + 3*M^3*RR*iRd*sin((2*pi)/3 + 2*theta) + 6*M^3*RR*iRq*sin(theta - pi/3)^2 + 6*M^3*RR*iRq*sin(pi/3 + theta)^2 + 108*M^4*dphidt*iSd*sin(theta)^2 + 32*LR*M^2*vSq*sin(theta - pi/3)^2 + 32*LR*M^2*vSq*sin(pi/3 + theta)^2 + 16*LR*M^2*vSq*sin(theta - (2*pi)/3)^2 + 16*LR*M^2*vSq*sin((2*pi)/3 + theta)^2 + 32*LRR*M^2*vSq*sin(theta - pi/3)^2 + 32*LRR*M^2*vSq*sin(pi/3 + theta)^2 + 16*LRR*M^2*vSq*sin(theta - (2*pi)/3)^2 + 16*LRR*M^2*vSq*sin((2*pi)/3 + theta)^2 - 3*3^(1/2)*M^3*RR*iRd + 72*M^4*dphidt*iSd*sin(theta - pi/3)^2 + 72*M^4*dphidt*iSd*sin(pi/3 + theta)^2 + 36*M^4*dphidt*iSd*sin(theta - (2*pi)/3)^2 + 36*M^4*dphidt*iSd*sin((2*pi)/3 + theta)^2 - 3*M^4*iSq*omega*sin((2*pi)/3 + 2*theta) - 3*M^4*iSq*omega*sin(4*theta - (2*pi)/3) - 3*M^4*iSq*omega*sin((2*pi)/3 + 4*theta) + 3*M^4*iSq*omega*sin(2*theta - (4*pi)/3) + 3*M^4*iSq*omega*sin(4*theta - (4*pi)/3) + 3*M^4*iSq*omega*sin((4*pi)/3 + 4*theta) - 16*LR^2*LS^2*dphidt*iSd + 32*LRR^2*LS^2*dphidt*iSd + 32*LR^2*LSS^2*dphidt*iSd - 64*LRR^2*LSS^2*dphidt*iSd - 8*M^4*dphidt*iSd*sin(2*theta - pi/3)^2 - 8*M^4*dphidt*iSd*sin(pi/3 + 2*theta)^2 + 4*M^4*dphidt*iSd*sin(2*theta - (2*pi)/3)^2 + 4*M^4*dphidt*iSd*sin((2*pi)/3 + 2*theta)^2 + 4*M^4*dphidt*iSd*sin(2*theta - (4*pi)/3)^2 + 4*M^4*dphidt*iSd*sin((4*pi)/3 + 2*theta)^2 - 16*LR*LRR*LS*vSq + 32*LR*LRR*LSS*vSq + 16*LR*LRR*LS*RS*iSq - 32*LR*LRR*LSS*RS*iSq + 24*LR*LS*M*RR*iRq - 48*LRR*LS*M*RR*iRq - 48*LR*LSS*M*RR*iRq + 96*LRR*LSS*M*RR*iRq - 48*LR*M^2*RS*iSq*sin(theta)^2 - 48*LRR*M^2*RS*iSq*sin(theta)^2 - 32*LR*M^2*RS*iSq*sin(theta - pi/3)^2 - 32*LR*M^2*RS*iSq*sin(pi/3 + theta)^2 - 16*LR*M^2*RS*iSq*sin(theta - (2*pi)/3)^2 - 16*LR*M^2*RS*iSq*sin((2*pi)/3 + theta)^2 - 32*LRR*M^2*RS*iSq*sin(theta - pi/3)^2 - 32*LRR*M^2*RS*iSq*sin(pi/3 + theta)^2 - 16*LRR*M^2*RS*iSq*sin(theta - (2*pi)/3)^2 - 16*LRR*M^2*RS*iSq*sin((2*pi)/3 + theta)^2 - 3^(1/2)*M^3*RR*iRq*sin(2*theta) + 2*3^(1/2)*M^3*RR*iRd*sin(theta)^2 + 16*LR*LRR*LS^2*dphidt*iSd - 32*LR*LRR*LSS^2*dphidt*iSd + 16*LR^2*LS*LSS*dphidt*iSd - 32*LRR^2*LS*LSS*dphidt*iSd + 108*LR*LS*M^2*dphidt*iSd + 216*LRR*LSS*M^2*dphidt*iSd - 24*LR^2*LS*M*iRd*omega + 48*LRR^2*LS*M*iRd*omega + 48*LR^2*LSS*M*iRd*omega - 96*LRR^2*LSS*M*iRd*omega - 36*LR*LS*M^2*iSd*omega + 72*LRR*LS*M^2*iSd*omega + 72*LR*LSS*M^2*iSd*omega - 144*LRR*LSS*M^2*iSd*omega + 3^(1/2)*M^3*RR*iRq*sin(2*theta - (2*pi)/3) - 3*3^(1/2)*M^3*RR*iRq*sin((2*pi)/3 + 2*theta) - 2*3^(1/2)*M^3*RR*iRq*sin(4*theta - (2*pi)/3) + 2*3^(1/2)*M^3*RR*iRq*sin((2*pi)/3 + 4*theta) + 2*3^(1/2)*M^3*RR*iRq*sin(2*theta - (4*pi)/3) - 2*3^(1/2)*M^3*RR*iRq*sin((4*pi)/3 + 2*theta) - 2*3^(1/2)*M^3*RR*iRq*sin(4*theta - (4*pi)/3) + 2*3^(1/2)*M^3*RR*iRq*sin((4*pi)/3 + 4*theta) + 6*3^(1/2)*M^3*RR*iRd*sin(theta - pi/3)^2 - 2*3^(1/2)*M^3*RR*iRd*sin(pi/3 + theta)^2 + 4*3^(1/2)*M^3*RR*iRd*sin(theta - (2*pi)/3)^2 - 4*3^(1/2)*M^3*RR*iRd*sin((2*pi)/3 + theta)^2 - 2*3^(1/2)*M^4*iSd*omega*sin(2*theta - (2*pi)/3) + 3*3^(1/2)*M^4*iSd*omega*sin((2*pi)/3 + 2*theta) + 3^(1/2)*M^4*iSd*omega*sin(4*theta - (2*pi)/3) - 3^(1/2)*M^4*iSd*omega*sin((2*pi)/3 + 4*theta) - 3*3^(1/2)*M^4*iSd*omega*sin(2*theta - (4*pi)/3) + 2*3^(1/2)*M^4*iSd*omega*sin((4*pi)/3 + 2*theta) + 3^(1/2)*M^4*iSd*omega*sin(4*theta - (4*pi)/3) - 3^(1/2)*M^4*iSd*omega*sin((4*pi)/3 + 4*theta) + 4*3^(1/2)*M^3*RR*iRd*sin(2*theta - pi/3)^2 - 4*3^(1/2)*M^3*RR*iRd*sin(pi/3 + 2*theta)^2 + 4*3^(1/2)*M^3*RR*iRd*sin(2*theta - (2*pi)/3)^2 - 4*3^(1/2)*M^3*RR*iRd*sin((2*pi)/3 + 2*theta)^2 - 4*3^(1/2)*LR*M^3*iRq*omega*sin(2*theta - pi/3)^2 + 4*3^(1/2)*LR*M^3*iRq*omega*sin(pi/3 + 2*theta)^2 - 4*3^(1/2)*LR*M^3*iRq*omega*sin(2*theta - (2*pi)/3)^2 + 4*3^(1/2)*LR*M^3*iRq*omega*sin((2*pi)/3 + 2*theta)^2 - 4*3^(1/2)*LRR*M^3*iRq*omega*sin(2*theta - pi/3)^2 + 4*3^(1/2)*LRR*M^3*iRq*omega*sin(pi/3 + 2*theta)^2 - 4*3^(1/2)*LRR*M^3*iRq*omega*sin(2*theta - (2*pi)/3)^2 + 4*3^(1/2)*LRR*M^3*iRq*omega*sin((2*pi)/3 + 2*theta)^2 - 8*LR*LS*M*RR*iRd*sin(2*theta) + 16*LRR*LS*M*RR*iRd*sin(2*theta) + 16*LR*LSS*M*RR*iRd*sin(2*theta) - 32*LRR*LSS*M*RR*iRd*sin(2*theta) - 16*LR*LS*M*RR*iRq*sin(theta)^2 + 32*LRR*LS*M*RR*iRq*sin(theta)^2 + 32*LR*LSS*M*RR*iRq*sin(theta)^2 - 64*LRR*LSS*M*RR*iRq*sin(theta)^2 + 4*LR*LS*M*RR*iRd*sin(2*theta - (2*pi)/3) + 4*LR*LS*M*RR*iRd*sin((2*pi)/3 + 2*theta) - 8*LRR*LS*M*RR*iRd*sin(2*theta - (2*pi)/3) - 8*LRR*LS*M*RR*iRd*sin((2*pi)/3 + 2*theta) - 8*LR*LSS*M*RR*iRd*sin(2*theta - (2*pi)/3) - 8*LR*LSS*M*RR*iRd*sin((2*pi)/3 + 2*theta) + 16*LRR*LSS*M*RR*iRd*sin(2*theta - (2*pi)/3) + 16*LRR*LSS*M*RR*iRd*sin((2*pi)/3 + 2*theta) + 8*LR*LS*M*RR*iRq*sin(theta - pi/3)^2 + 8*LR*LS*M*RR*iRq*sin(pi/3 + theta)^2 - 16*LRR*LS*M*RR*iRq*sin(theta - pi/3)^2 - 16*LRR*LS*M*RR*iRq*sin(pi/3 + theta)^2 - 16*LR*LSS*M*RR*iRq*sin(theta - pi/3)^2 - 16*LR*LSS*M*RR*iRq*sin(pi/3 + theta)^2 + 32*LRR*LSS*M*RR*iRq*sin(theta - pi/3)^2 + 32*LRR*LSS*M*RR*iRq*sin(pi/3 + theta)^2 - 16*LR*LRR*LS*LSS*dphidt*iSd + 24*LR*LRR*LS*M*iRd*omega - 48*LR*LRR*LSS*M*iRd*omega - 48*LR*LS*M^2*dphidt*iSd*sin(theta)^2 - 48*LRR*LS*M^2*dphidt*iSd*sin(theta)^2 - 48*LR*LSS*M^2*dphidt*iSd*sin(theta)^2 - 48*LRR*LSS*M^2*dphidt*iSd*sin(theta)^2 + 8*LR^2*LS*M*iRq*omega*sin(2*theta) - 16*LRR^2*LS*M*iRq*omega*sin(2*theta) - 16*LR^2*LSS*M*iRq*omega*sin(2*theta) + 32*LRR^2*LSS*M*iRq*omega*sin(2*theta) - 16*LR^2*LS*M*iRd*omega*sin(theta)^2 + 32*LRR^2*LS*M*iRd*omega*sin(theta)^2 + 32*LR^2*LSS*M*iRd*omega*sin(theta)^2 - 64*LRR^2*LSS*M*iRd*omega*sin(theta)^2 - 16*LR*LS*M^2*dphidt*iSd*sin(theta - pi/3)^2 - 16*LR*LS*M^2*dphidt*iSd*sin(pi/3 + theta)^2 - 32*LR*LS*M^2*dphidt*iSd*sin(theta - (2*pi)/3)^2 - 32*LR*LS*M^2*dphidt*iSd*sin((2*pi)/3 + theta)^2 - 64*LRR*LS*M^2*dphidt*iSd*sin(theta - pi/3)^2 - 64*LRR*LS*M^2*dphidt*iSd*sin(pi/3 + theta)^2 + 16*LRR*LS*M^2*dphidt*iSd*sin(theta - (2*pi)/3)^2 + 16*LRR*LS*M^2*dphidt*iSd*sin((2*pi)/3 + theta)^2 - 64*LR*LSS*M^2*dphidt*iSd*sin(theta - pi/3)^2 - 64*LR*LSS*M^2*dphidt*iSd*sin(pi/3 + theta)^2 + 16*LR*LSS*M^2*dphidt*iSd*sin(theta - (2*pi)/3)^2 + 16*LR*LSS*M^2*dphidt*iSd*sin((2*pi)/3 + theta)^2 + 32*LRR*LSS*M^2*dphidt*iSd*sin(theta - pi/3)^2 + 32*LRR*LSS*M^2*dphidt*iSd*sin(pi/3 + theta)^2 - 80*LRR*LSS*M^2*dphidt*iSd*sin(theta - (2*pi)/3)^2 - 80*LRR*LSS*M^2*dphidt*iSd*sin((2*pi)/3 + theta)^2 - 4*LR^2*LS*M*iRq*omega*sin(2*theta - (2*pi)/3) - 4*LR^2*LS*M*iRq*omega*sin((2*pi)/3 + 2*theta) + 8*LRR^2*LS*M*iRq*omega*sin(2*theta - (2*pi)/3) + 8*LRR^2*LS*M*iRq*omega*sin((2*pi)/3 + 2*theta) + 8*LR^2*LSS*M*iRq*omega*sin(2*theta - (2*pi)/3) + 8*LR^2*LSS*M*iRq*omega*sin((2*pi)/3 + 2*theta) - 16*LRR^2*LSS*M*iRq*omega*sin(2*theta - (2*pi)/3) - 16*LRR^2*LSS*M*iRq*omega*sin((2*pi)/3 + 2*theta) + 8*LR*LS*M^2*iSq*omega*sin(2*theta - (2*pi)/3) + 8*LR*LS*M^2*iSq*omega*sin((2*pi)/3 + 2*theta) - 8*LR*LS*M^2*iSq*omega*sin(2*theta - (4*pi)/3) - 8*LR*LS*M^2*iSq*omega*sin((4*pi)/3 + 2*theta) - 16*LRR*LS*M^2*iSq*omega*sin(2*theta - (2*pi)/3) - 16*LRR*LS*M^2*iSq*omega*sin((2*pi)/3 + 2*theta) + 16*LRR*LS*M^2*iSq*omega*sin(2*theta - (4*pi)/3) + 16*LRR*LS*M^2*iSq*omega*sin((4*pi)/3 + 2*theta) - 16*LR*LSS*M^2*iSq*omega*sin(2*theta - (2*pi)/3) - 16*LR*LSS*M^2*iSq*omega*sin((2*pi)/3 + 2*theta) + 16*LR*LSS*M^2*iSq*omega*sin(2*theta - (4*pi)/3) + 16*LR*LSS*M^2*iSq*omega*sin((4*pi)/3 + 2*theta) + 32*LRR*LSS*M^2*iSq*omega*sin(2*theta - (2*pi)/3) + 32*LRR*LSS*M^2*iSq*omega*sin((2*pi)/3 + 2*theta) - 32*LRR*LSS*M^2*iSq*omega*sin(2*theta - (4*pi)/3) - 32*LRR*LSS*M^2*iSq*omega*sin((4*pi)/3 + 2*theta) + 8*LR^2*LS*M*iRd*omega*sin(theta - pi/3)^2 + 8*LR^2*LS*M*iRd*omega*sin(pi/3 + theta)^2 - 16*LRR^2*LS*M*iRd*omega*sin(theta - pi/3)^2 - 16*LRR^2*LS*M*iRd*omega*sin(pi/3 + theta)^2 - 16*LR^2*LSS*M*iRd*omega*sin(theta - pi/3)^2 - 16*LR^2*LSS*M*iRd*omega*sin(pi/3 + theta)^2 + 32*LRR^2*LSS*M*iRd*omega*sin(theta - pi/3)^2 + 32*LRR^2*LSS*M*iRd*omega*sin(pi/3 + theta)^2 - 4*3^(1/2)*LR*M^3*iRd*omega*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LR*M^3*iRd*omega*sin((2*pi)/3 + 2*theta) - 2*3^(1/2)*LR*M^3*iRd*omega*sin(4*theta - (2*pi)/3) + 2*3^(1/2)*LR*M^3*iRd*omega*sin((2*pi)/3 + 4*theta) - 4*3^(1/2)*LR*M^3*iRd*omega*sin(2*theta - (4*pi)/3) + 4*3^(1/2)*LR*M^3*iRd*omega*sin((4*pi)/3 + 2*theta) - 2*3^(1/2)*LR*M^3*iRd*omega*sin(4*theta - (4*pi)/3) + 2*3^(1/2)*LR*M^3*iRd*omega*sin((4*pi)/3 + 4*theta) - 4*3^(1/2)*LRR*M^3*iRd*omega*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LRR*M^3*iRd*omega*sin((2*pi)/3 + 2*theta) - 2*3^(1/2)*LRR*M^3*iRd*omega*sin(4*theta - (2*pi)/3) + 2*3^(1/2)*LRR*M^3*iRd*omega*sin((2*pi)/3 + 4*theta) - 4*3^(1/2)*LRR*M^3*iRd*omega*sin(2*theta - (4*pi)/3) + 4*3^(1/2)*LRR*M^3*iRd*omega*sin((4*pi)/3 + 2*theta) - 2*3^(1/2)*LRR*M^3*iRd*omega*sin(4*theta - (4*pi)/3) + 2*3^(1/2)*LRR*M^3*iRd*omega*sin((4*pi)/3 + 4*theta) + 4*3^(1/2)*LR^2*LS*M*iRd*omega*sin(2*theta - (2*pi)/3) - 4*3^(1/2)*LR^2*LS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LRR^2*LS*M*iRd*omega*sin(2*theta - (2*pi)/3) + 8*3^(1/2)*LRR^2*LS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR^2*LSS*M*iRd*omega*sin(2*theta - (2*pi)/3) + 8*3^(1/2)*LR^2*LSS*M*iRd*omega*sin((2*pi)/3 + 2*theta) + 16*3^(1/2)*LRR^2*LSS*M*iRd*omega*sin(2*theta - (2*pi)/3) - 16*3^(1/2)*LRR^2*LSS*M*iRd*omega*sin((2*pi)/3 + 2*theta) + 8*3^(1/2)*LR^2*LS*M*iRq*omega*sin(theta - pi/3)^2 - 8*3^(1/2)*LR^2*LS*M*iRq*omega*sin(pi/3 + theta)^2 - 16*3^(1/2)*LRR^2*LS*M*iRq*omega*sin(theta - pi/3)^2 + 16*3^(1/2)*LRR^2*LS*M*iRq*omega*sin(pi/3 + theta)^2 - 16*3^(1/2)*LR^2*LSS*M*iRq*omega*sin(theta - pi/3)^2 + 16*3^(1/2)*LR^2*LSS*M*iRq*omega*sin(pi/3 + theta)^2 + 32*3^(1/2)*LRR^2*LSS*M*iRq*omega*sin(theta - pi/3)^2 - 32*3^(1/2)*LRR^2*LSS*M*iRq*omega*sin(pi/3 + theta)^2 - 8*LR*LRR*LS*M*iRq*omega*sin(2*theta) + 16*LR*LRR*LSS*M*iRq*omega*sin(2*theta) + 16*LR*LRR*LS*M*iRd*omega*sin(theta)^2 - 32*LR*LRR*LSS*M*iRd*omega*sin(theta)^2 + 4*3^(1/2)*LR*LS*M*RR*iRq*sin(2*theta - (2*pi)/3) - 4*3^(1/2)*LR*LS*M*RR*iRq*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LRR*LS*M*RR*iRq*sin(2*theta - (2*pi)/3) + 8*3^(1/2)*LRR*LS*M*RR*iRq*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR*LSS*M*RR*iRq*sin(2*theta - (2*pi)/3) + 8*3^(1/2)*LR*LSS*M*RR*iRq*sin((2*pi)/3 + 2*theta) + 16*3^(1/2)*LRR*LSS*M*RR*iRq*sin(2*theta - (2*pi)/3) - 16*3^(1/2)*LRR*LSS*M*RR*iRq*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR*LS*M*RR*iRd*sin(theta - pi/3)^2 + 8*3^(1/2)*LR*LS*M*RR*iRd*sin(pi/3 + theta)^2 + 16*3^(1/2)*LRR*LS*M*RR*iRd*sin(theta - pi/3)^2 - 16*3^(1/2)*LRR*LS*M*RR*iRd*sin(pi/3 + theta)^2 + 16*3^(1/2)*LR*LSS*M*RR*iRd*sin(theta - pi/3)^2 - 16*3^(1/2)*LR*LSS*M*RR*iRd*sin(pi/3 + theta)^2 - 32*3^(1/2)*LRR*LSS*M*RR*iRd*sin(theta - pi/3)^2 + 32*3^(1/2)*LRR*LSS*M*RR*iRd*sin(pi/3 + theta)^2 + 4*LR*LRR*LS*M*iRq*omega*sin(2*theta - (2*pi)/3) + 4*LR*LRR*LS*M*iRq*omega*sin((2*pi)/3 + 2*theta) - 8*LR*LRR*LSS*M*iRq*omega*sin(2*theta - (2*pi)/3) - 8*LR*LRR*LSS*M*iRq*omega*sin((2*pi)/3 + 2*theta) - 8*LR*LRR*LS*M*iRd*omega*sin(theta - pi/3)^2 - 8*LR*LRR*LS*M*iRd*omega*sin(pi/3 + theta)^2 + 16*LR*LRR*LSS*M*iRd*omega*sin(theta - pi/3)^2 + 16*LR*LRR*LSS*M*iRd*omega*sin(pi/3 + theta)^2 - 4*3^(1/2)*LR*LRR*LS*M*iRd*omega*sin(2*theta - (2*pi)/3) + 4*3^(1/2)*LR*LRR*LS*M*iRd*omega*sin((2*pi)/3 + 2*theta) + 8*3^(1/2)*LR*LRR*LSS*M*iRd*omega*sin(2*theta - (2*pi)/3) - 8*3^(1/2)*LR*LRR*LSS*M*iRd*omega*sin((2*pi)/3 + 2*theta) - 8*3^(1/2)*LR*LRR*LS*M*iRq*omega*sin(theta - pi/3)^2 + 8*3^(1/2)*LR*LRR*LS*M*iRq*omega*sin(pi/3 + theta)^2 + 16*3^(1/2)*LR*LRR*LSS*M*iRq*omega*sin(theta - pi/3)^2 - 16*3^(1/2)*LR*LRR*LSS*M*iRq*omega*sin(pi/3 + theta)^2)/(162*M^4 - 72*M^4*sin(theta - pi/3)^2 - 72*M^4*sin(pi/3 + theta)^2 - 36*M^4*sin(theta - (2*pi)/3)^2 - 36*M^4*sin((2*pi)/3 + theta)^2 - 108*M^4*sin(theta)^2 + 16*LR^2*LS^2 - 32*LRR^2*LS^2 - 32*LR^2*LSS^2 + 64*LRR^2*LSS^2 + 8*M^4*sin(2*theta - pi/3)^2 + 8*M^4*sin(pi/3 + 2*theta)^2 - 4*M^4*sin(2*theta - (2*pi)/3)^2 - 4*M^4*sin((2*pi)/3 + 2*theta)^2 - 4*M^4*sin(2*theta - (4*pi)/3)^2 - 4*M^4*sin((4*pi)/3 + 2*theta)^2 - 16*LR*LRR*LS^2 + 32*LR*LRR*LSS^2 - 16*LR^2*LS*LSS + 32*LRR^2*LS*LSS - 108*LR*LS*M^2 - 216*LRR*LSS*M^2 + 16*LR*LRR*LS*LSS + 48*LR*LS*M^2*sin(theta)^2 + 48*LRR*LS*M^2*sin(theta)^2 + 48*LR*LSS*M^2*sin(theta)^2 + 48*LRR*LSS*M^2*sin(theta)^2 + 16*LR*LS*M^2*sin(theta - pi/3)^2 + 16*LR*LS*M^2*sin(pi/3 + theta)^2 + 32*LR*LS*M^2*sin(theta - (2*pi)/3)^2 + 32*LR*LS*M^2*sin((2*pi)/3 + theta)^2 + 64*LRR*LS*M^2*sin(theta - pi/3)^2 + 64*LRR*LS*M^2*sin(pi/3 + theta)^2 - 16*LRR*LS*M^2*sin(theta - (2*pi)/3)^2 - 16*LRR*LS*M^2*sin((2*pi)/3 + theta)^2 + 64*LR*LSS*M^2*sin(theta - pi/3)^2 + 64*LR*LSS*M^2*sin(pi/3 + theta)^2 - 16*LR*LSS*M^2*sin(theta - (2*pi)/3)^2 - 16*LR*LSS*M^2*sin((2*pi)/3 + theta)^2 - 32*LRR*LSS*M^2*sin(theta - pi/3)^2 - 32*LRR*LSS*M^2*sin(pi/3 + theta)^2 + 80*LRR*LSS*M^2*sin(theta - (2*pi)/3)^2 + 80*LRR*LSS*M^2*sin((2*pi)/3 + theta)^2));
            diRddt = 377*(dphidt*iRq - (M*(6*vSd - 6*RS*iSd + 6*LS*iSq*omega + 6*LSS*iSq*omega) + 4*LS*RR*iRd + 4*LSS*RR*iRd + 4*LR*LS*iRq*omega + 4*LRR*LS*iRq*omega + 4*LR*LSS*iRq*omega + 4*LRR*LSS*iRq*omega)/(4*LR*LS - 9*M^2 + 4*LRR*LS + 4*LR*LSS + 4*LRR*LSS));
            diRqdt = 377*((M*(6*RS*iSq - 6*vSq + 6*LS*iSd*omega + 6*LSS*iSd*omega) - 4*LS*RR*iRq - 4*LSS*RR*iRq + 4*LR*LS*iRd*omega + 4*LRR*LS*iRd*omega + 4*LR*LSS*iRd*omega + 4*LRR*LSS*iRd*omega)/(4*LR*LS - 9*M^2 + 4*LRR*LS + 4*LR*LSS + 4*LRR*LSS) - dphidt*iRd);
            domegadt = 377*(-(tauL + B*omega - (3*M*iRd*iSq)/2 + (3*M*iRq*iSd)/2)/J);
            dthetadt = 377*omega;
            
            StateSpace = [diSddt ; diSqdt ; diRddt ; diRqdt ; domegadt ; dthetadt];
        end
    end
end