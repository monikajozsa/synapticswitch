using Gillespie
using Random
using LinearAlgebra, ForwardDiff, MatrixEquations, FileIO, MAT, GroupSlices, Statistics
import Random: seed!
include("Wlist_funct.jl")
const ϵ = 0.0001


function make_asymm_kmat(k1,k2,k3,k4,k5,k6, W)
    Nconn=sum(abs.(W));
    if Nconn==3
        kvec=[k1,k2,k3];
    elseif Nconn==4
        kvec=[k1,k2,k3,k4];
    elseif Nconn==5
        kvec=[k1,k2,k3,k4,k5];
    else
        kvec=[k1,k2,k3,k4,k5,k6];
    end
    k=convert(Array{Float64}, W)
    kind=abs.(W).>0;
    k[kind].=kvec;
    return k
end

function Rates_func(x,parms)
    #input
    (X1,X2,X3) = x
    (k1,k2,k3,k4,k5,k6,Ai,xbar) = parms
    W=Wlist(Ai,1);
    k=make_asymm_kmat(k1,k2,k3,k4,k5,k6, W);
    #variable allocation
    BR = Matrix(undef,3,3)
    DR = deepcopy(BR)
    # helper functions
    inhB(xinp,kinp) = kinp*xbar/(kinp+xinp/xbar);
    inhD(xinp,kinp) = kinp*xinp/(kinp+1);
    excB(xinp,kinp) = xbar*(xinp/xbar+ϵ)/(kinp+xinp/xbar);# excB(a,k) = λ*xbar*(a/xbar+ϵ)/(k+a/xbar);
    excD(xinp,kinp) = (1+ϵ)*xinp/(kinp+1);
    #excitatory and inhibitory matrices
    for (indx, el) in zip(CartesianIndices(W), W)
        if el==1
            BR[indx] = excB(x[indx[1]],k[indx[1],indx[2]])
            DR[indx] = excD(x[indx[2]],k[indx[1],indx[2]])
        elseif el==-1
            BR[indx] = inhB(x[indx[1]],k[indx[1],indx[2]])
            DR[indx] = inhD(x[indx[2]],k[indx[1],indx[2]])
        else
            BR[indx] = 0.;
            DR[indx] = 0.;
        end
    end
    #rates based on excitatory and inhibitory matrices
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

function ParamFunc(Ai,Nk,xbar)
    Hall=Array{Any}(undef,Nk);
    Wall=Array{Any}(undef,Nk);
    maxXXall=Array{Any}(undef,Nk);
    kvec=Array{Any}(undef,Nk);
    x0 = [trunc(Int,xbar),trunc(Int,xbar),trunc(Int,xbar)];
    reactions = [[1 0 0];[-1 0 0];[0 1 0];[0 -1 0];[0 0 1];[0 0 -1]];
    seed!(1234)

    Nspecies=3;
    # Nsteps=Array{Int64,1}(undef,1);
    Nsteps=100000;
    Nrealisations=100;
    X=Array{Any,3}(undef,Nspecies,Nsteps,Nrealisations);
    T=Array{Any,2}(undef,Nsteps,Nrealisations);
    #THIS IS FOR VERSION 3
    kmin=0.05;
    kmax=0.1;
    if in(Ai,[7])
        kmin=0.005;
        kmax=0.01;
    end
    #THIS WAS FOR VERSION 2
    # if in(Ai,[1 4])
    #     kmin=0.005;
    #     kmax=0.05;
    # elseif in(Ai,[2 3 5 6])
    #     kmin=0.02;
    #     kmax=0.1;
    # elseif in(Ai,[7])
    #     kmin=0.005;
    #     kmax=0.01;
    # end
    for ki=1:Nk
        k1=rand(1)[1]*(kmax-kmin)+kmin;
        k2=rand(1)[1]*(kmax-kmin)+kmin;
        k3=rand(1)[1]*(kmax-kmin)+kmin;
        k4=rand(1)[1]*(kmax-kmin)+kmin;
        k5=rand(1)[1]*(kmax-kmin)+kmin;
        k6=rand(1)[1]*(kmax-kmin)+kmin;
        kvec[ki]=[k1,k2,k3,k4,k5,k6];
        parms = [k1,k2,k3,k4,k5,k6,Ai,xbar];#THIS IS WHERE THE ARCHITECTURE Ai IS PASSED ON TO THE GILLESPIE SIMULATION
        for i=1:Nrealisations
            gillespie_result = ssa(x0,Rates_func,reactions,parms,Nsteps)
            X[:,:,i]=gillespie_result.data[1:Nsteps[1],:]'.+1;
            T[:,i]=gillespie_result.time[1:Nsteps[1]]';
        end
        Wall[ki], Hall[ki], maxXXall[ki] = sparse_distribution_avg_by_real(X,T);
        println([Ai ki])
    end
    return Wall, Hall, maxXXall, kvec
end

function main(Ai,xbarvec)
    Nk=20;
    Nxbar=size(xbarvec,2);
    Hall=Array{Any}(undef,Nk,Nxbar);
    Wall=Array{Any}(undef,Nk,Nxbar);
    maxXXall=Array{Any}(undef,Nk,Nxbar);
    kvec=Array{Any}(undef,Nk,Nxbar);
    for indxbar=trunc.(Int,LinRange(1,Nxbar,Nxbar))
        Wall[:,indxbar], Hall[:,indxbar], maxXXall[:,indxbar], kvec[:,indxbar] = ParamFunc(Ai,Nk,xbarvec[indxbar]);
        println(indxbar)
    end
return Wall, Hall, maxXXall, kvec, xbarvec
end
################ VERSION 3missing -needed due to simulation breakdown ################
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(1,[13.])
# matwrite("A1_gill_asymm_inh_k01_005_missing_13.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(2,[9. 11. 13. 15.])
# matwrite("A2_gill_asymm_inh_k01_005_missing.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(3,[9. 11. 13. 15.])
# matwrite("A3_gill_asymm_inh_k01_005_missing.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(4,[9. 11. 13. 15.])
# matwrite("A4_gill_asymm_inh_k01_005_missing.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(5,[9. 11. 13. 15.])
# matwrite("A5_gill_asymm_inh_k01_005_missing.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(6,[9. 11. 13. 15.])
# matwrite("A6_gill_asymm_inh_k01_005_missing.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(7,[3. 5. 7. 9. 11. 13. 15.])
# matwrite("A7_gill_asymm_inh_k001_0005_v2.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
# 
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(7,[11.])
# matwrite("A7_gill_asymm_inh_k001_0005_v2_xbar11.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))

################ VERSION 3 ################
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(1,[5. 7. 11.])
# matwrite("A1_gill_asymm_inh_k01_005_missing.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(2,[3. 5. 7.])
# matwrite("A2_gill_asymm_inh_k01_005.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(3,[3. 5. 7.])
# matwrite("A3_gill_asymm_inh_k01_005.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(4,[3. 5. 7.])
# matwrite("A4_gill_asymm_inh_k01_005.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(5,[3. 5. 7.])
# matwrite("A5_gill_asymm_inh_k01_005.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(6,[3. 5. 7.])
# matwrite("A6_gill_asymm_inh_k01_005.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(7,[3. 5. 7.])
# matwrite("A7_gill_asymm_inh_k01_005.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))

#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(1,[12.])
# matwrite("A1_gill_asymm_inh_12.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(2,[18.])
# matwrite("A2_gill_asymm_inh_12.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(3,[3. 9. 12. 15.])
# matwrite("A3_gill_asymm_inh.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(4,[3. 9. 15.])
# matwrite("A4_gill_asymm_inh.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(5,[3. 9. 15.])
# matwrite("A5_gill_asymm_inh.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(6,[3. 9. 15.])
# matwrite("A6_gill_asymm_inh.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))
#
# @time Wall, Hall, maxXXall, kvec, xbarvec =  main(7,[3. 9. 15.])
# matwrite("A7_gill_asymm_inh.mat", Dict("Wall" => Wall, "Hall" => Hall, "maxXXall" => maxXXall, "kvec" =>  kvec, "xbarvec" => xbarvec))

###########################################
