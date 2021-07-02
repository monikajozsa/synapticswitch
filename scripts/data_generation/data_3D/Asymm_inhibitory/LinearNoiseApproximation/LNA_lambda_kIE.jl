using LinearAlgebra, ForwardDiff, MatrixEquations, FileIO, MAT, GroupSlices
include("Wlist_funct.jl")
const ϵ = 0.0001;

function make_kmat(kI, kE, W)
    WE=W.>0;
    WI=W.<0;
    k=WE.*kE+WI.*kI;
    return k
end

function make_excinh(xbar, λ)
    # rate at a with parameter k and equilibrium xbar; λ is a time scale for excitatory connections
    inhB(a,k) = k*xbar/(k+a/xbar);
    inhD(a,k) = k/(k+1)*a;
    excB(a,k) = λ*xbar*(a/xbar+ϵ)/(k+a/xbar);
    excD(a,k) = λ*(1+ϵ)/(k+1)*a;

    function which_f(in)
        if in == 1
            return excB, excD
        elseif in == -1
            return inhB, inhD
        end
    end
    return which_f
end

function gillespie_rates(which_f,x,W,k)
    Nspecies=size(W)[1];
    BR = Matrix(undef,3,3) # IT DOES NOT WORK WITH zeros(Nspecies,Nspecies)
    DR = deepcopy(BR)
    rates = zeros(2*Nspecies)
    for (indx, el) in zip(CartesianIndices(W), W)
        if !(isnothing(which_f(el)))
            BR[indx] = which_f(el)[1](x[indx[1]], k[indx])
            DR[indx] = which_f(el)[2](x[indx[2]], k[indx])
        else
            BR[indx] = 0.;
            DR[indx] = 0.;
        end
    end
    rates = [BR[2,1] + BR[3,1]; DR[2,1] + DR[3,1]; BR[1,2] + BR[3,2]; DR[1,2] + DR[3,2]; BR[1,3] + BR[2,3]; DR[1,3] + DR[2,3]];
    return rates
end

function get_ABC(Nspecies,xbar,x,k,λ,W)
    r=kron(I(Nspecies),[1 -1]);
    which_f = make_excinh(xbar, λ)
    mainFunc(y) = r*gillespie_rates(which_f,y,W,k)
    rates = gillespie_rates(which_f, x, W, k)
    mainFuncJac(y) = ForwardDiff.jacobian(mainFunc, y)
    A = mainFuncJac(x)
    B=r*(r*Diagonal(rates))';
    C=MatrixEquations.lyapc(A,B)
    Csvd=svd(C);
    Csvec=Csvd.V[:,1];
    Cangle=atan(norm(cross(Csvec,ones(Nspecies))), dot(Csvec,ones(Nspecies)));
    return A, B, C, Cangle
end

function ParamFunc(Ai,Nλ)
    #NA defines which architecture we consider
    Nspecies=3; #number of species (this code is only designed for three species but can easily be extended)
    NWvec=[15,32,9,16,10,8,4]; #number of connectivities corresponding to the 7 architectures for three species
    NW=NWvec[Ai]; #number of connectivities of the chosen architecture
    A=Array{Float32,4}(undef,(Nspecies, Nspecies, Nλ, NW));
    B=Array{Float32,4}(undef,(Nspecies, Nspecies, Nλ, NW));
    C=Array{Float32,4}(undef,(Nspecies, Nspecies, Nλ, NW));
    Cangle=Array{Float32,2}(undef,(Nλ, NW));
    KEval = 0.01; #v1: KEvec = 0.01;
    KIval = 0.01; #v1: KIval = 0.01;
    if Nλ >1
        λvec=10 .^LinRange{Float64}(0,-3,Nλ); #v1: λvec=LinRange{Float64}(1,0.0001,Nλ);
    else
        λvec = [1];
    end

    xbar=2.;
    x=[xbar;xbar;xbar];

    for l=1:NW
        W=Wlist(Ai,l);
        for i=1:Nλ
            λ = λvec[i];
            k=make_kmat(KIval, KEval, W);
            A[:,:,i,l], B[:,:,i,l], C[:,:,i,l], Cangle[i,l] = get_ABC(Nspecies,xbar,x,k,λ,W)
        end
        println(l)
    end
    return A, B, C, Cangle
end

Nλ=5;
A, B, C, Cangle = ParamFunc(1,Nλ)
matwrite("A1_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
A, B, C, Cangle = ParamFunc(2,Nλ)
matwrite("A2_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
A, B, C, Cangle = ParamFunc(3,Nλ)
matwrite("A3_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
A, B, C, Cangle = ParamFunc(4,Nλ)
matwrite("A4_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
A, B, C, Cangle = ParamFunc(5,Nλ)
matwrite("A5_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
A, B, C, Cangle = ParamFunc(6,Nλ)
matwrite("A6_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
A, B, C, Cangle = ParamFunc(7,Nλ)
matwrite("A7_lna_v4.mat", Dict("A" => A, "B" => B, "C" => C, "Cangle" => Cangle))
