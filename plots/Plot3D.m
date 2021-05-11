function [] = Plot3D(data_str,size_ind,run_ind)
[H, ~, W, ~] = LoadData(data_str,size_ind,run_ind);
cut_prctile=20;
Prop_th=0.01;
data_cut=max(max(W)*Prop_th,prctile(W,cut_prctile));
cut_ind=W>data_cut;
H=H(cut_ind,:);
W=W(cut_ind);
SizeWeight=(W.^2)./max(W.^2)*max(H(:));
scatter3(H(:,1),H(:,2),H(:,3),SizeWeight,W,'filled','o','MarkerFaceAlpha',0.2);
end