function [inp_avgfreq_inp, inp_avgduration_ind] = Stats_inp_activation(inp_activation,N_realisations)

inp_duration_ind=zeros(N_realisations,1);
inp_freq_inp=zeros(N_realisations,1);

for i=1:N_realisations
    Data_temp=inp_activation{i};
    inp_duration_ind(i)=mean(Data_temp(:,2)-Data_temp(:,1));
    inp_freq_inp(i)=mean(diff(Data_temp(:,1)));
end

inp_avgfreq_inp=mean(inp_freq_inp);
inp_avgduration_ind=mean(inp_duration_ind);
if any(inp_avgduration_ind<0)
    disp('inp_avgduration_ind in Stats_inp_activation is negative')
end