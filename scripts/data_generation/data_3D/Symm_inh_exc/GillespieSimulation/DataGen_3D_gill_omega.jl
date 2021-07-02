using Gillespie
using Random
using LinearAlgebra, ForwardDiff, MatrixEquations, FileIO, MAT, GroupSlices, Statistics
import Random: seed!
include("Wlist_funct.jl")
const ϵ = 0.0001

function Rates_func(x,parms)
    # input
    (X1,X2,X3) = x
    (k, xbar, λ, Ai, Wi) = parms
    W=Wlist(Ai,Wi)
    # variable allocation
    BR = Matrix(undef,3,3)
    DR = deepcopy(BR)
    # helper functions
    inhB(xinp) = k*xbar/(k+xinp/xbar);
    inhD(xinp) = k*xinp/(k+1);
    excB(xinp) = λ*xbar*(xinp/xbar+ϵ)/(k+xinp/xbar);# excB(a,k) = λ*xbar*(a/xbar+ϵ)/(k+a/xbar);
    excD(xinp) = λ*(1+ϵ)*xinp/(k+1);
    # excitatory and inhibitory matrices
    for (indx, el) in zip(CartesianIndices(W), W)
        if el==1
            BR[indx] = excB(x[indx[1]])
            DR[indx] = excD(x[indx[2]])
        elseif el==-1
            BR[indx] = inhB(x[indx[1]])
            DR[indx] = inhD(x[indx[2]])
        else
            BR[indx] = 0.;
            DR[indx] = 0.;
        end
    end
    # rates based on excitatory and inhibitory matrices
    [BR[2,1] + BR[3,1]; DR[2,1] + DR[3,1]; BR[1,2] + BR[3,2]; DR[1,2] + DR[3,2]; BR[1,3] + BR[2,3]; DR[1,3] + DR[2,3]]
end

function sparse_distribution_avg_by_real(X,T)

    Xsize=size(X);
    Nspecies=Xsize[1];
    Nsteps=Xsize[2];
    Ndiscarded=trunc(Int,max(100,floor(0.01*Nsteps)));
    if length(Xsize)>2
        Nrealisations=Xsize[3];
    else
        Nrealisations=1;
        # rest of the code here so it is handled separately if demensions mismatch?
    end
    timeint=diff(T,dims=1);
    WsparseAll = Array{Any,1}(undef,Nrealisations);
    Hsparse1DAll = Array{Any,1}(undef,Nrealisations);
    maxXX = reshape(maximum(X,dims=[2 3]).+1,1,Nspecies); #1x3 matrix
    Hsparse1Dold = nothing;
    Hsparse1D = nothing;
    for realInd=1:Nrealisations
        XX=X[:,Ndiscarded:(Nsteps-1),realInd]';
        WW=timeint[Ndiscarded:end,realInd];
        XX=XX.+1;
        Ndigits=trunc.(Int,ceil.(log.(10,maximum([10*ones(size(maxXX)); maxXX.+1],dims=1))));

        Npowers=reverse(cumsum(reverse(Ndigits),dims=2));
        invNpowers=[-Npowers[2:end]; 0]';
        Npowers=[Npowers[2:end]; 0]';
        XXpowers=XX.*(10 .^Npowers);
        XX1D=sum(XXpowers,dims=2);
        XX1D=trunc.(Int,XX1D);
        Hsparse1Di=unique(XX1D);
        Wsparsei=zeros(size(Hsparse1Di));
        Hsparse1DAll[realInd]=Hsparse1Di;
        IC=Array{Int32}(undef,length(XX1D),1);
        for i=1:length(Hsparse1Di)
            tempBoolean=(XX1D.==Hsparse1Di[i]);
            IC[tempBoolean].=i;
            Wsparsei[i]=sum(WW[tempBoolean[:]]);
        end
        # Wsparsei = accumarray(IC,WW);
        Wsparsei = Wsparsei./sum(Wsparsei);
        WsparseAll[realInd]=Wsparsei;
        if realInd==1
            Hsparse1D=Hsparse1Di;
        else
            Hsparse1D=union(Hsparse1Dold,Hsparse1Di);
        end
        Hsparse1Dold=Hsparse1D;
    end

    Wsparse=zeros(size(Hsparse1D));
    for realInd=1:Nrealisations
        Hsparse1Di=Hsparse1DAll[realInd];
        Wsparsei=WsparseAll[realInd];
        for Hind=1:size(Hsparse1Di)[1]
            indto=(Hsparse1D.==Hsparse1Di[Hind]);# indto=findall(in(Hsparse1Di[Hind]),Hsparse1D);#findall(x->x==Hsparse1Di[Hind], Hsparse1D);#same but seems to be slightly slower
            Wsparse[indto]=Wsparse[indto]+[Wsparsei[Hind]];
        end
    end
    Wsparse=Wsparse./sum(Wsparse);

    return Wsparse, Hsparse1D, maxXX
end

function ParamFunc(Ai,Nλ)
    NWvec=[15,32,9,16,10,8,4]; #number of connectivities corresponding to the 7 architectures for three species
    NW=NWvec[Ai];
    Hall=Array{Any}(undef,Nλ,NW);
    Wall=Array{Any}(undef,Nλ,NW);
    maxXXall=Array{Any}(undef,Nλ,NW);

    x0 = [2,2,2]
    reactions = [[1 0 0];[-1 0 0];[0 1 0];[0 -1 0];[0 0 1];[0 0 -1]]
    seed!(1234)

    Nspecies=3;
    Nsteps=Array{Int64,1}(undef,1);
    Nsteps[1]=500000;
    Nrealisations=100;
    λvec=10 .^LinRange{Float64}(0,-3,Nλ); #v1: λvec=LinRange{Float64}(1,0.0001,Nλ);
    X=Array{Any,3}(undef,Nspecies,Nsteps[1],Nrealisations);
    T=Array{Any,2}(undef,Nsteps[1],Nrealisations);
    for Wi=1:NW
        for j=1:Nλ
            parms = [0.01, 2., λvec[j], Ai, Wi]; #(k, xbar, λ, Ai, Wi)
            for i=1:Nrealisations
                gillespie_result = ssa(x0,Rates_func,reactions,parms,Nsteps[1]) #THIS FUNCTION IS CUSTOMIZED FROM ITS ORIGINAL, to reach it, pkg> add "https://github.com/monikajozsa/Gillespie.jl"
                X[:,:,i]=gillespie_result.data[1:Nsteps[1],:]'.+1;
                T[:,i]=gillespie_result.time[1:Nsteps[1]]';
            end
            Wall[j,Wi], Hall[j,Wi], maxXXall[j,Wi] = sparse_distribution_avg_by_real(X,T);
            println([Wi j])
        end
    end
    return Wall, Hall, maxXXall
end
@time Wall, Hall, maxXXall = ParamFunc(1,5)
matwrite("A1_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

@time Wall, Hall, maxXXall = ParamFunc(2,5)
matwrite("A2_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

@time Wall, Hall, maxXXall = ParamFunc(3,5)
matwrite("A3_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

@time Wall, Hall, maxXXall = ParamFunc(4,5)
matwrite("A4_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

@time Wall, Hall, maxXXall = ParamFunc(5,5)
matwrite("A5_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

@time Wall, Hall, maxXXall = ParamFunc(6,5)
matwrite("A6_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

@time Wall, Hall, maxXXall = ParamFunc(7,5)
matwrite("A7_gill_omega.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall))

########################## ADDITIONAL THINGS
# #SIMPLE EXAMPLES:  Symmetric Toggle Switch
# function F_l(x,parms)
#     (X1,X2) = x
#     (k,xbar) = parms
#     [k*xbar/(k+X1/xbar),k*X1/(k+1),k*xbar/(k+X2/xbar),k*X2/(k+1)]#[k*xbar/(k+(X1-1)/xbar),k*(X1-1)/(k+1),k*xbar/(k+(X2-1)/xbar),k*(X2-1)/(k+1)]
# end
#
# x0 = [5,5]
# nu = [[1 0];[-1 0];[0 1];[0 -1]]
# parms = [0.1, 10.];
# tf = 2000.0
# seed!(1234)
#
# gillespie_result = ssa(x0,F_l,nu,parms,tf)
#gillespie_data = ssa_data(gillespie_result)

# #3D example
# function F_l(x,parms)
#     (X1,X2,X3) = x
#     (k,xbar) = parms
#     [k*xbar/(k+X1/xbar),k*X1/(k+1),k*xbar/(k+X2/xbar),k*X2/(k+1),k*xbar/(k+X1/xbar),k*X1/(k+1)]
# end
#
# x0 = [5,5,5]
# nu = [[1 0 0];[-1 0 0];[0 1 0];[0 -1 0];[0 0 1];[0 0 -1]]
# parms = [0.1, 10.];
# tf = 2000.0
# seed!(1234)
#
# gillespie_result = ssa(x0,F_l,nu,parms,tf)

# # COMPARING THE RESULTS WITH A MATLAB SIMULATION - SEE PACKAGE_TRIAL_TEST.M
# x0 = [2,2,2]
# reactions = [[1 0 0];[-1 0 0];[0 1 0];[0 -1 0];[0 0 1];[0 0 -1]]
# parms = [0.01, 2., 1., 1, 1]; #(k, xbar, λ, Ai, Wi)
# tf = 20000.0
# seed!(1234)
#
# N_steps=100000;
# N_realisations=100;
# Mean_data=Array{Float32,2}(undef,N_realisations,3);
# Var_data=Array{Float32,2}(undef,N_realisations,3);
#
# for i=1:N_realisations
#     gillespie_result = ssa(x0,Rates_func,reactions,parms,tf)
#     Temp=gillespie_result.data.+1;
#     Tempt=gillespie_result.time;
#     Temptnorm=Tempt[1:N_steps];
#     Mean_data[i,:] = mean(Temp[1:N_steps,:].*Temptnorm,dims=1);
#     Var_data[i,:] = var(Temp[1:N_steps,:],dims=1);
# end
# println(mean(Mean_data,dims=1))
# println(mean(Var_data,dims=1))

## OUT OF USE
#
# function accumarray(subs, val, sz=(maximum(subs),))
#     A = zeros(eltype(val), sz...)
#     for i = 1:length(val)
#         A[subs[i]] += val[i]
#     end
#     return A
# end
#
# function sparse_distribution(X,T) # merged realizations; probem when dealing with long runs
#
#     Xsize=size(X);
#     Nspecies=Xsize[1];
#     Nsteps=Xsize[2];
#     Ndiscarded=1;#trunc(Int,max(1000,floor(0.01*Nsteps)));
#     if length(Xsize)>2
#         Nrealisations=Xsize[3];
#     else
#         Nrealisations=1;
#     end
#     timeint=diff(T,dims=1);
#
#     XX=reshape(X[:,Ndiscarded:(Nsteps-1),:],Nspecies,(Nsteps-Ndiscarded)*Nrealisations)';
#     WW=reshape(timeint[Ndiscarded:(Nsteps-1),:],(Nsteps-Ndiscarded)*Nrealisations,1);
#
#     nanind=isnan.(XX);
#     XXnew=reshape(XX[.!nanind],:,Nspecies);
#     WW=WW[.!nanind[:,1]];
#
#     XX=XX.+1;
#     maxXX=maximum(XX,dims=1);
#     Ndigits=trunc.(Int,ceil.(log.(10,maximum([10*ones(size(maxXX)); maxXX.+1],dims=1))));
#
#     Npowers=reverse(cumsum(reverse(Ndigits),dims=2));
#     invNpowers=[-Npowers[2:end]; 0]';
#     Npowers=[Npowers[2:end]; 0]';
#     XXpowers=XX.*(10 .^Npowers);
#     XX1D=sum(XXpowers,dims=2);
#     XX1D=trunc.(Int,XX1D);
#     Hsparse1D=unique(XX1D);
#     IC=Array{Int32}(undef,length(XX1D),1);
#     for i=1:length(Hsparse1D)
#         tempBoolean=(XX1D.==Hsparse1D[i]);
#         IC[tempBoolean].=i;
#     end
#
#     Wsparse = accumarray(IC,WW);
#     Wsparse = Wsparse./sum(Wsparse);
#
#     return Wsparse, Hsparse1D, maxXX
# end
