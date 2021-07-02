
clear all
figure
for Ai=1:7
    OpenFileName=strcat("A",num2str(Ai),"_lna_v4.mat");
    load(OpenFileName)
    [~,Nspecies,Nlambda,NW] =size(C);
    p_out=zeros(Nlambda,NW);

    for Wi=1:NW
        for lambdai=1:Nlambda
            Cov_LNA=C(:,:,lambdai,Wi);
            p_out(lambdai,Wi)=1-mvncdf([0 0 0],[1000 1000 1000],2*ones(1,Nspecies),Cov_LNA);
            if isnan(p_out(lambdai,Wi))
                p_out(lambdai,Wi)=1-mvncdf([0 0 0],[100 100 100],2*ones(1,Nspecies),Cov_LNA);
            end
        end
        disp(Wi)
    end
    SaveFileName=strcat("A",num2str(Ai),"_lna_v4_pout.mat");
    save(SaveFileName)
    subplot(1,7,Ai)
    imagesc(p_out)
end