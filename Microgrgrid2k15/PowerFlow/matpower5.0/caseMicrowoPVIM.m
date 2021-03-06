function mpc = caseMicrowoPVIM
%CASE9    Power flow data for Lincoln Lab microgrid
%   Please see CASEFORMAT for details on the case file format.
%
%   Based on data from Joe H. Chow's book, p. 70.

%   MATPOWER
%   $Id: case9.m 2408 2014-10-22 20:41:33Z ray $

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 4;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
1	1	0	0	0	0	1	1	0	13.8	1	2.5	0.8
2	1	1	0.6	0	0	1	1	0	0.46	1	2.5	0.8
3	1	0	0	0	0	1	1	0	13.8	1	2.5	0.8
4	1	0	0	0	0	1	1	0	13.8	1	2.5	0.8
5	1	0	0	0	0	1	1	0	4.16	1	2.5	0.8
6	1	0	0	0	0	1	1	0	13.8	1	2.5	0.8
7	1	0	0	0	0	1	1	0	13.8	1	2.5	0.8
8	1	0	0	0	0	1	1	0	4.16	1	2.5	0.8
9	1	0	0	0	0	1	1	0	4.16	1	2.5	0.8
10	1	0	0	0	0	1	1	0	4.16	1	2.5	0.8
11	1	0.22	0.01	0	0	1	1	0	0.46	1	2.5	0.8
12	1	0.14	0.09	0	0	1	1	0	0.46	1	2.5	0.8
13	1	0.16	0.09	0	0	1	1	0	0.46	1	2.5	0.8
14	1	0.7     0.6	0	0	1	1	0	0.46	1	2.5	0.8
15	1	2.5	1.2	0	0	1	1	0	0.46	1	2.5	0.8
16	1	0.09	0.042	0	0	1	1	0	0.46	1	2.5	0.8
17	1	0.14	0.01	0	0	1	1	0	0.208	1	2.5	0.8
18	1	0.28	0.1	0	0	1	1	0	0.208	1	2.5	0.8
19	1	0.78	0.42	0	0	1	1	0	0.208	1	2.5	0.8
20	1	0	0	0	0	1	1	0	2.4	1	2.5	0.8
22	3	0	0	0	0	1	1	0	13.8	1	2.5	0.8
23	2	0	0	0	0	1	1	0	0.46	1	2.5	0.8
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
%1	2	0	4	-4	1	4	1	4	0	0	0	0	0	0	0	0	0	0	0	0
22	4	0	4	-4	1	4	1	4	0	-4	0	0	0	0	0	0	0	0	0
23	1	0	4	-4	1	4	1	4	0	-4	0	0	0	0	0	0	0	0	0
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
1	2	0.012356522	0.261709075	0	7	7	7	0	0	1	-360	360
1	3	0.021782783	0.108784284	0	7	7	7	0	0	1	-360	360
1	4	0.008237681	0.041139383	0	7	7	7	0	0	1	-360	360
3	5	0.02436215	0.228332438	0	7	7	7	0	0	1	-360	360
3	11	0.029773333	0.348689486	0	7	7	7	0	0	1	-360	360
4	6	0.016475362	0.082278767	0	7	7	7	0	0	1	-360	360
4	7	0.000235362	0.001175411	0	7	7	7	0	0	1	-360	360
5	8	0.001171154	0.0058488	0	7	7	7	0	0	1	-360	360
5	9	0.000780769	0.0038992	0	7	7	7	0	0	1	-360	360
9	10	0.001990962	0.00994296	0	7	7	7	0	0	1	-360	360
8	16	0.010817048	0.45402087	0	7	7	7	0	0	1	-360	360
8	17	0.021510192	0.507422955	0	7	7	7	0	0	1	-360	360
9	18	0.021510192	0.307422955	0	7	7	7	0	0	1	-360	360
10	19	0.019519231	0.297479995	0	7	7	7	0	0	1	-360	360
10	20	0.005413333	0.127034452	0	7	7	7	0	0	1	-360	360
6	13	0.018828986	0.62736621	0	7	7	7	0	0	1	-360	360
6	14	0.056016232	0.479747807	0	7	7	7	0	0	1	-360	360
7	15	0.002953797	0.121418074	0	7	7	7	0	0	1	-360	360
4	12	0.001406516	0.007024211	0	7	7	7	0	0	1	-360	360
7	22	0.001176812	0.005877055	0	7	7	7	0	0	1	-360	360
2	23	0.017652174	0.088155822	0	7	7	7	0	0	1	-360	360
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
 %   2	1500	0	3	0.11	5	150;
% 	2	1500	0	3	0	0	15;
	2	1500	0	3	0.11	5	150;
    2	1500	0	3	0.11	5	150;
];

end 