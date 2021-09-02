The “data” folder contains all the data files. The scripts folder contains all the scripts that generated the files in folder “data”. The “plots” folder contains figures and scripts that generated those figures.

Below, we list the files in the “scripts” folder folder and add the dependencies of the files. 

FOLDER scripts/Gillespie\_and\_Distribution:

function [xbar,W,rate\_constants] = GenConstants\_EI(Nspecies,xbar\_interval,rate\_const\_interval,IE\_ratio, W\_force)

\- functions used: none

function [X,T] = Gillespie\_EI(xbar,rate\_constants,N\_steps,N\_realisations)

\- functions used: Rates\_EI

function rates = Rates\_EI(x,xbar,rate\_constants,eps\_local)

\- functions used: none

function [H\_sparse,W\_sparse,H\_sparse\_1D,max\_XX] = Sparse\_Distribution\_EI(X,T)

\- functions used: H\_to\_H1D, H1D\_to\_H

function H = H1D\_to\_H(H\_1D,Nspecies)

\- functions used: none

function H\_1D = H\_to\_H1D(H,max\_grid)

\- functions used: none

function H  = Marginal\_Sparse\_to\_grid(H\_sparse,W\_sparse,ind\_1\_2)

\- functions used: none

FOLDER scripts/shared\_functions:

function cm\_data=viridis(n\_colors)

\- functions used: none

function cm\_data=plasma(n\_colors)

\- functions used: none

function colors = distinguishable\_colors(n\_colors,bg,func)

\- functions used: none

function W = W\_list(Nspecies,nA)

\- functions used: none

function L = LogMat(n,allS)

\- functions used: none

function h = error\_ellipse(covariance\_mtx,mean\_vec)

\- functions used: none

function Center = Sparse\_Distribution\_weighted\_mean(H\_sparse,W\_sparse,isShifted)

\- functions used: none

function [nn\_eq,Cov\_LNA,P\_out] = automatic\_LNA(k,x\_bar,W,epsilon,lambda)

\- functions used: none

function [Weighted\_Cov,Weighted\_Mean] = Sparse\_Distribution\_weighted\_cov(H\_sparse,W\_sparse, Weighted\_Mean)

\- functions used: Sparse\_Distribution\_weighted\_mean

function [] = Plot\_stationary\_distrib(H,W,Nspecies)

\- functions used: Marginal\_Sparse\_to\_grid

FOLDER scripts/mode\_search:

function [D\_vec, clp\_ind] = Closest\_larger\_point(local\_max\_sub,local\_max\_val,selected\_ind)

\- functions used: none

function loc\_max\_mode\_id = loc\_max\_mode\_id\_from\_kept(loc\_max\_mode\_id,local\_max\_sub,kept\_lmax\_ind,clp\_pointer)

\- functions used: none

function min\_ridge\_val = RidgeMin(point\_from\_ind, point\_to\_ind, H\_sparse, W\_sparse, neighbours\_ind)

\- functions used: none

function points\_id = Sparse\_Distribution\_pointer\_point\_ID(H\_sparse\_1D,W\_sparse,local\_max\_ind, neighbours\_val,neighbours\_ind,max\_neighbour\_ind\_nb)

\- functions used: none

function [Mode\_weights,Mode\_peaks,Mode\_centers] = Sparse\_Density\_Mode\_Features(H\_sparse, W\_sparse, points\_mode\_id)

\- functions used: Sparse\_Distribution\_weighted\_mean

function [neighbours\_1D, neighbours\_val, neighbours\_ind] = Sparse\_Distribution\_Ext\_neighbours\_1D(H\_sparse\_1D,W\_sparse,grid\_max)

\- functions used: LogMat

function [local\_max\_sub, local\_max\_val,local\_max\_1D, local\_max\_ind, neighbours\_1D, neighbours\_val, neighbours\_ind, max\_neighbour\_local\_ind] = Sparse\_Distribution\_Ext\_local\_max\_1D(H\_sparse, W\_sparse, H\_sparse\_1D)

\- functions used: Sparse\_Distribution\_Ext\_neighbours\_1D

function [W\_sparse\_filt,local\_max\_sub, local\_max\_val,local\_max\_ind, neighbours\_1D, neighbours\_val, neighbours\_ind, max\_neighbour\_local\_ind] = Local\_Averaging(W\_sparse, H\_sparse, H\_sparse\_1D, neighbours\_val)

\- functions used: Sparse\_Distribution\_Ext\_local\_max\_1D

function [local\_max\_sub, local\_max\_val, p\_ind, p\_pointer, clp\_pointer, max\_Nmodes] = DropingCloseLocMax(local\_max\_sub, local\_max\_val, max\_Nmodes, dist\_th, H, W, CoordScale\_for\_dist)

\- functions used: Sparse\_Distribution\_weighted\_cov, Closest\_larger\_point, 

function [peaks\_sub, peaks\_val, peaks\_ind, peaks\_from\_local\_max\_ind] = Peak\_Selection(local\_max\_sub, local\_max\_val, local\_max\_ind, H, W, neighbours\_ind, maxNmodes, CoordScale\_for\_dist)

\- functions used: Sparse\_Distribution\_weighted\_cov, RidgeMin

function [MaxMode,NofModes,points\_mode\_id,Mode\_peaks,Mode\_centers] = LargestMode\_complete\_alg(H, W, H\_1D, Prop\_th, xbar, CoordScale\_for\_dist)

\- functions used: Sparse\_Distribution\_Ext\_local\_max\_1D, Sparse\_Distribution\_weighted\_cov, Closest\_larger\_point, DropingCloseLocMax\_v2, Peak\_Selection\_v4, loc\_max\_mode\_id\_from\_kept, Sparse\_Distribution\_pointer\_point\_ID, Sparse\_Density\_Mode\_Features, Sparse\_Density\_Mode\_Features

function points\_mode\_id = ModeSelection(H, W, H\_1D, xbar)

-function used: Sparse\_Distribution\_Ext\_local\_max\_1D, DropingCloseLocMax, Local\_Averaging, H\_to\_H1D, Peak\_Selection\_v2, Closest\_larger\_point, loc\_max\_mode\_id\_from\_kept, Sparse\_Distribution\_pointer\_point\_ID

FOLDER scripts/data\_generation/data\_2D/Data\_dwell\_time:

DataGen\_dwell\_time.m: generates Data\_dwell\_time\_distr.mat

-function used: GenConstants\_EI, Gillespie\_EI, Sparse\_Distribution\_EI

FOLDER scripts/data\_generation/data\_2D/Dynamic\_Toggle\_Switch

DataGen\_main.m: generates Changing\_k.mat, Changing\_delta\_n.mat, Changing\_n\_0.mat, Changing\_t\_act.mat, Changing\_m\_inp.mat, Changing\_t\_per.mat, Changing\_t\_dur.mat, Changing\_x\_0.mat

-function used: GenData\_Changing\_param

function [] = GenData\_Changing\_param(Save\_filename,var\_name,var\_values,baseline\_val,N\_realisations,N\_steps,save\_n\_change)

-function used: GenConstants\_EI, Gillespie\_dyn\_inp\_v3, Avg\_Stats\_from\_data, ModeSwitch\_ind

Stats\_inp\_activation

function [X,T,Xbar\_change,Xbar\_avg,inp\_activation] = Gillespie\_dyn\_inp(xbar,rate\_constants,N\_steps,N\_realisations,modes\_func,mode\_effect\_xbar,mode\_time\_th,inp\_freq,inp\_duration,inp\_rate\_addition,x\_0)

-function used: Reaction\_funct

FOLDER scripts/data\_generation/data\_2D/Dynamic\_Toggle\_Switch/Helper functions:

function [Lifetime, Survived, Death\_ind, Blown\_up\_ind] = Avg\_Stats\_from\_data(T,X,N\_real)

\- functions used: none

function [avgswitch\_ind, avgduration\_ind] = ModeSwitch\_ind(Xbar\_change,N\_realisations)

\- functions used: none

function [x,t,tau,xbar,Xbar\_change,change\_ind,changed\_reac\_happened] = Reaction\_funct(xbar,t,x,r,rate\_constants,tau,mode\_effect\_xbar,change\_ind,mode\_ind,rch\_addition)

\- functions used: Rates\_EI

function [inp\_avgfreq\_inp, inp\_avgduration\_ind] = Stats\_inp\_activation(inp\_activation,N\_realisations)

\- functions used: none

FOLDER scripts/data\_generation/data\_2D/SII\_SIE\_SEE\_systems:

DataGen\_2D.m generates Data\_II\_sym.mat, Data\_IE\_sym.mat, Data\_EE\_sym.mat, Data\_II\_asym.mat, Data\_IE\_asym.mat, Data\_EE\_asym.mat

\- functions used: GenConstants\_EI, Gillespie\_EI, Sparse\_Distribution\_EI

ModeSearch\_on\_data.m generates Data\_II\_sym\_modes.mat, Data\_IE\_sym\_modes.mat, Data\_EE\_sym\_modes.mat, Data\_II\_asym\_modes.mat, Data\_IE\_asym\_modes.mat, Data\_EE\_asym\_modes.mat

\- functions used: LargestMode\_complete\_alg

LNA\_2D\_sym\_and\_asym.m generates  Data\_II\_sym\_LNA.mat, Data\_IE\_sym\_LNA.mat, Data\_EE\_sym\_LNA.mat, Data\_II\_asym\_LNA.mat, Data\_IE\_asym\_LNA.mat, Data\_EE\_asym\_LNA.

\- functions used: automatic\_LNA

FOLDER scripts/data\_generation/data\_3D/Asymm\_inhibitory/GillespieSimulation:

DataGen\_inh\_asymm\_3D.jl generates A1\_gill\_asymm\_inh.mat, A2\_gill\_asymm\_inh.mat, A3\_gill\_asymm\_inh.mat, A4\_gill\_asymm\_inh.mat, A5\_gill\_asymm\_inh.mat, A6\_gill\_asymm\_inh.mat, A7\_gill\_asymm\_inh.mat

\- functions used: Wlist\_funct.jl, function ssa from <https://github.com/monikajozsa/Gillespie.jl>

FOLDER scripts/data\_generation/data\_3D/Asymm\_inhibitory/GillespieSimulation/LargestModeWeight:

ModeSearch\_3D\_asymm\_inh.m generates LMW\_3D\_inh\_asymm.mat

\- functions used: LargestMode\_complete\_alg, H1D\_to\_H

\- data files used: A1\_gill\_asymm\_inh.mat, A2\_gill\_asymm\_inh.mat, A3\_gill\_asymm\_inh.mat, A4\_gill\_asymm\_inh.mat, A5\_gill\_asymm\_inh.mat, A6\_gill\_asymm\_inh.mat, A7\_gill\_asymm\_inh.mat

FOLDER scripts/data\_generation/data\_3D/Asymm\_inhibitory/LinearNoiseApproximation:

LNA\_lambda\_kIE.jl generates A1\_lna\_v4.mat, A2\_lna\_v4.mat, A3\_lna\_v4.mat, A4\_lna\_v4.mat, A5\_lna\_v4.mat, A6\_lna\_v4.mat, A7\_lna\_v4.mat

\- functions used: Wlist\_funct

addPout.m generates A1\_lna\_v4\_pout.mat, A2\_lna\_v4\_pout.mat, A3\_lna\_v4\_pout.mat, A4\_lna\_v4\_pout.mat, A5\_lna\_v4\_pout.mat, A6\_lna\_v4\_pout.mat, A7\_lna\_v4\_pout.mat

\- functions used: none

\- data files used: A1\_lna\_v4.mat, A2\_lna\_v4.mat, A3\_lna\_v4.mat, A4\_lna\_v4.mat, A5\_lna\_v4.mat, A6\_lna\_v4.mat, A7\_lna\_v4.mat

FOLDER scripts/data\_generation/data\_3D/Symm\_inh\_exc/GillespieSimulation:

DataGen\_3D\_gill\_omega.jl generates A1\_gill\_omega.mat, A2\_gill\_omega.mat, A3\_gill\_omega.mat, A4\_gill\_omega.mat, A5\_gill\_omega.mat, A6\_gill\_omega.mat, A7\_gill\_omega.mat

\- functions used: Wlist\_funct.jl, function ssa from <https://github.com/monikajozsa/Gillespie.jl>

FOLDER scripts/data\_generation/data\_3D/Symm\_inh\_exc/GillespieSimulation/LargestModeWeight:

Omega\_symm\_inh\_3D\_mode\_search.m generates Data\_A1\_mode.mat, Data\_A2\_mode.mat, Data\_A3\_mode.mat, Data\_A4\_mode.mat, Data\_A5\_mode.mat, Data\_A6\_mode.mat, Data\_A7\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: A1\_gill\_omega.mat, A2\_gill\_omega.mat, A3\_gill\_omega.mat, A4\_gill\_omega.mat, A5\_gill\_omega.mat, A6\_gill\_omega.mat, A7\_gill\_omega.mat

FOLDER scripts/data\_generation/data\_3D/Symm\_inh\_exc/LinearNoiseApproximation:

LNA\_3D\_inh\_exc.m generates Data\_A1\_LNA, Data\_A1\_LNA, Data\_A1\_LNA, Data\_A1\_LNA, Data\_A1\_LNA, Data\_A1\_LNA, Data\_A1\_LNA

\- functions used: automatic\_LNA

FOLDER scripts/data\_generation/data\_3D/Symm\_inhibitory/GillespieSimulation:

DataGen\_main.m generates Data\_A1\_k\_001, Data\_A1\_k\_0019, Data\_A1\_k\_0028, Data\_A1\_k\_0037, Data\_A1\_k\_0046, Data\_A1\_k\_0055, Data\_A1\_k\_0064, Data\_A1\_k\_0073, Data\_A1\_k\_0082, Data\_A1\_k\_0091, Data\_A2\_k\_001, Data\_A2\_k\_0019, Data\_A2\_k\_0028, Data\_A2\_k\_0037, Data\_A2\_k\_0046, Data\_A2\_k\_0055, Data\_A2\_k\_0064, Data\_A2\_k\_0073, Data\_A2\_k\_0082, Data\_A2\_k\_0091, Data\_A3\_k\_001, Data\_A3\_k\_0019, Data\_A3\_k\_0028, Data\_A3\_k\_0037, Data\_A3\_k\_0046, Data\_A3\_k\_0055, Data\_A3\_k\_0064, Data\_A3\_k\_0073, Data\_A3\_k\_0082, Data\_A3\_k\_0091, Data\_A4\_k\_001, Data\_A4\_k\_0019, Data\_A4\_k\_0028, Data\_A4\_k\_0037, Data\_A4\_k\_0046, Data\_A4\_k\_0055, Data\_A4\_k\_0064, Data\_A4\_k\_0073, Data\_A4\_k\_0082, Data\_A4\_k\_0091, Data\_A5\_k\_001, Data\_A5\_k\_0019, Data\_A5\_k\_0028, Data\_A5\_k\_0037, Data\_A5\_k\_0046, Data\_A5\_k\_0055, Data\_A5\_k\_0064, Data\_A5\_k\_0073, Data\_A5\_k\_0082, Data\_A5\_k\_0091, Data\_A6\_k\_001, Data\_A6\_k\_0019, Data\_A6\_k\_0028, Data\_A6\_k\_0037, Data\_A6\_k\_0046, Data\_A6\_k\_0055, Data\_A6\_k\_0064, Data\_A6\_k\_0073, Data\_A6\_k\_0082, Data\_A6\_k\_0091, Data\_A7\_k\_001, Data\_A7\_k\_0019, Data\_A7\_k\_0028, Data\_A7\_k\_0037, Data\_A7\_k\_0046, Data\_A7\_k\_0055, Data\_A7\_k\_0064, Data\_A7\_k\_0073, Data\_A7\_k\_0082, Data\_A7\_k\_0091

\- functions used: GenConstants\_EI, Gillespie\_EI, Sparse\_Distribution\_EI

ModeSearch\_from\_A1\_data.m generates Data\_A1\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A1\_k\_001, Data\_A1\_k\_0019, Data\_A1\_k\_0028, Data\_A1\_k\_0037, Data\_A1\_k\_0046, Data\_A1\_k\_0055, Data\_A1\_k\_0064, Data\_A1\_k\_0073, Data\_A1\_k\_0082, Data\_A1\_k\_0091

ModeSearch\_from\_A2\_data.m generates Data\_A2\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A2\_k\_001, Data\_A2\_k\_0019, Data\_A2\_k\_0028, Data\_A2\_k\_0037, Data\_A2\_k\_0046, Data\_A2\_k\_0055, Data\_A2\_k\_0064, Data\_A2\_k\_0073, Data\_A2\_k\_0082, Data\_A2\_k\_0091

ModeSearch\_from\_A3\_data.m generates Data\_A3\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A3\_k\_001, Data\_A3\_k\_0019, Data\_A3\_k\_0028, Data\_A3\_k\_0037, Data\_A3\_k\_0046, Data\_A3\_k\_0055, Data\_A3\_k\_0064, Data\_A3\_k\_0073, Data\_A3\_k\_0082, Data\_A3\_k\_0091

ModeSearch\_from\_A4\_data.m generates Data\_A4\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A4\_k\_001, Data\_A4\_k\_0019, Data\_A4\_k\_0028, Data\_A4\_k\_0037, Data\_A4\_k\_0046, Data\_A4\_k\_0055, Data\_A4\_k\_0064, Data\_A4\_k\_0073, Data\_A4\_k\_0082, Data\_A4\_k\_0091

ModeSearch\_from\_A5\_data.m generates Data\_A5\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A5\_k\_001, Data\_A5\_k\_0019, Data\_A5\_k\_0028, Data\_A5\_k\_0037, Data\_A5\_k\_0046, Data\_A5\_k\_0055, Data\_A5\_k\_0064, Data\_A5\_k\_0073, Data\_A5\_k\_0082, Data\_A5\_k\_0091

ModeSearch\_from\_A6\_data.m generates Data\_A6\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A6\_k\_001, Data\_A6\_k\_0019, Data\_A6\_k\_0028, Data\_A6\_k\_0037, Data\_A6\_k\_0046, Data\_A6\_k\_0055, Data\_A6\_k\_0064, Data\_A6\_k\_0073, Data\_A6\_k\_0082, Data\_A6\_k\_0091

ModeSearch\_from\_A7\_data.m generates Data\_A7\_mode.mat

\- functions used: LargestMode\_complete\_alg

\- data files used: Data\_A7\_k\_001, Data\_A7\_k\_0019, Data\_A7\_k\_0028, Data\_A7\_k\_0037, Data\_A7\_k\_0046, Data\_A7\_k\_0055, Data\_A7\_k\_0064, Data\_A7\_k\_0073, Data\_A7\_k\_0082, Data\_A7\_k\_0091

FOLDER scripts/data\_generation/data\_3D/Symm\_inhibitory/LinearNoiseApproximation:

DataGen\_LNA3D\_symm\_inh.m generates Data\_A1\_k\_001.mat, Data\_A2\_k\_001.mat, Data\_A3\_k\_001.mat, Data\_A4\_k\_001.mat, Data\_A5\_k\_001.mat, Data\_A6\_k\_001.mat, Data\_A7\_k\_001.mat

\- functions used: automatic\_LNA

FOLDER Examples

Contains examples to use some basic functions from the ones listed above






