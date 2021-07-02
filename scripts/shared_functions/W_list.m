function W = W_list(Nspecies,nA)

%% List of possible connectivity structures for 2 or 3 species networks
%
% Inputs: Nspecies - number of different species (2 or 3)
%         nA - architecture index (see comments below)
% Output: W - connectivity matrix (2x2 or 3x3 matrix), where
%             W(i,j)=-1 means species i inhibits species j and
%             W(i,j)=1 means species i excites species j.
% 
% Note: It is assumed that every species is either excited or inhibited by 
% at least one other species. 
% In 2D case there are 3 different architectures, in 3D there are 94.


%% 2D connectivity structures (3 architectures - full connected network)
if Nspecies==2
    W2D=cell(3,1);
    W2D{1}=[0 -1;-1 0]; %fully inhibitory network
    W2D{2}=[0 1;-1 0]; %one excitatory, one inhibitory connection
    W2D{3}=[0 1;1 0]; %fully excitatory network 
    W=W2D;
end

%% 3D connectivity structures
if Nspecies==3
    if nA==1 %A1: fully connected network
        W3D=cell(15,1);
        W3D{1}=[0 -1 -1;-1 0 -1; -1 -1 0]; 
        W3D{2}=[0 1 -1;-1 0 -1; -1 -1 0]; 
        W3D{3}=[0 1 1;-1 0 -1; -1 -1 0];
        W3D{4}=[0 1 -1;1 0 -1; -1 -1 0];
        W3D{5}=[0 -1 -1;1 0 -1; 1 -1 0];
        W3D{6}=[0 -1 1;1 0 -1; -1 -1 0];
        W3D{7}=[0 1 1;1 0 -1; -1 -1 0];
        W3D{8}=[0 1 -1;1 0 -1; 1 -1 0];
        W3D{9}=[0 1 -1;-1 0 1; 1 -1 0];
        W3D{10}=[0 -1 -1;1 0 1; 1 1 0];
        W3D{11}=[0 -1 1;-1 0 1; 1 1 0];
        W3D{12}=[0 1 1;-1 0 1; -1 1 0];
        W3D{13}=[0 1 -1;-1 0 1; 1 1 0];
        W3D{14}=[0 1 1;1 0 1; 1 1 0];
        W3D{15}=[0 1 1;1 0 1; 1 -1 0];
        W=W3D;
    end

    if nA==2 %A2: one missing connection
        W3D{1}=[0 0 -1;-1 0 -1; -1 -1 0]; 
        W3D{2}=[0 0 1;-1 0 -1; -1 -1 0]; 
        W3D{3}=[0 0 -1;1 0 -1; -1 -1 0]; 
        W3D{4}=[0 0 -1;-1 0 1; -1 -1 0]; 
        W3D{5}=[0 0 -1;-1 0 -1; 1 -1 0]; 
        W3D{6}=[0 0 -1;-1 0 -1; -1 1 0];  
        W3D{7}=[0 0 1;1 0 -1; -1 -1 0]; 
        W3D{8}=[0 0 1;-1 0 1; -1 -1 0]; 
        W3D{9}=[0 0 1;-1 0 -1; 1 -1 0]; 
        W3D{10}=[0 0 1;-1 0 -1; -1 1 0];
        W3D{11}=[0 0 -1;1 0 1; -1 -1 0]; 
        W3D{12}=[0 0 -1;1 0 -1; 1 -1 0]; 
        W3D{13}=[0 0 -1;1 0 -1; -1 1 0]; 
        W3D{14}=[0 0 -1;-1 0 1; 1 -1 0]; 
        W3D{15}=[0 0 -1;-1 0 1; -1 1 0]; 
        W3D{16}=[0 0 -1;-1 0 -1; 1 1 0]; 
        W3D{17}=[0 0 1;1 0 1; -1 -1 0]; 
        W3D{18}=[0 0 1;1 0 -1; 1 -1 0]; 
        W3D{19}=[0 0 1;1 0 -1; -1 1 0]; 
        W3D{20}=[0 0 1;-1 0 1; 1 -1 0]; 
        W3D{21}=[0 0 1;-1 0 1; -1 1 0]; 
        W3D{22}=[0 0 1;-1 0 -1; 1 1 0]; 
        W3D{23}=[0 0 -1;1 0 1; 1 -1 0]; 
        W3D{24}=[0 0 -1;1 0 1; -1 1 0]; 
        W3D{25}=[0 0 -1;1 0 -1; 1 1 0]; 
        W3D{26}=[0 0 -1;-1 0 1; 1 1 0]; 
        W3D{27}=[0 0 1;1 0 1; 1 -1 0]; 
        W3D{28}=[0 0 1;1 0 1; -1 1 0]; 
        W3D{29}=[0 0 1;1 0 -1; 1 1 0]; 
        W3D{30}=[0 0 1;-1 0 1; 1 1 0]; 
        W3D{31}=[0 0 -1;1 0 1; 1 1 0]; 
        W3D{32}=[0 0 1;1 0 1; 1 1 0];
        W=W3D;
    end
    
    if nA==3 %A3: four connections, two 2-cycles
        W3D{1}=[0 0 -1;0 0 -1; -1 -1 0]; 
        W3D{2}=[0 0 1;0 0 -1; -1 -1 0]; 
        W3D{3}=[0 0 -1;0 0 -1; 1 -1 0];
        W3D{4}=[0 0 -1;0 0 -1; 1 1 0]; 
        W3D{5}=[0 0 1;0 0 1; -1 -1 0]; 
        W3D{6}=[0 0 1;0 0 -1; 1 -1 0]; 
        W3D{7}=[0 0 1;0 0 1; -1 1 0]; 
        W3D{8}=[0 0 -1;0 0 1; 1 1 0]; 
        W3D{9}=[0 0 1;0 0 1; 1 1 0]; 
        W=W3D;
    end
    
    if nA==4 %A4: four connections, 2-cycle and one feedforward and one feedback connection
        W3D{1}=[0 -1 0; -1 0 -1; -1 0 0]; 
        W3D{2}=[0 1 0; -1 0 -1; -1 0 0]; 
        W3D{3}=[0 -1 0; 1 0 -1; -1 0 0]; 
        W3D{4}=[0 -1 0; -1 0 1; -1 0 0]; 
        W3D{5}=[0 -1 0; -1 0 -1; 1 0 0]; 
        W3D{6}=[0 1 0; 1 0 -1; -1 0 0];
        W3D{7}=[0 1 0; -1 0 1; -1 0 0];
        W3D{8}=[0 1 0; -1 0 -1; 1 0 0];
        W3D{9}=[0 -1 0; 1 0 1; -1 0 0];
        W3D{10}=[0 -1 0; 1 0 -1; 1 0 0];
        W3D{11}=[0 -1 0; -1 0 1; 1 0 0];
        W3D{12}=[0 1 0; 1 0 1; -1 0 0];
        W3D{13}=[0 1 0; 1 0 -1; 1 0 0];
        W3D{14}=[0 1 0; -1 0 1; 1 0 0];
        W3D{15}=[0 -1 0; 1 0 1; 1 0 0];
        W3D{16}=[0 1 0; 1 0 1; 1 0 0];
        W=W3D;
    end

    if nA==5 %A5: four connections, 2-cycle and two feedforward connections
        W3D{1}=[0 -1 -1; -1 0 -1; 0 0 0]; 
        W3D{2}=[0 1 -1; -1 0 -1; 0 0 0]; 
        W3D{3}=[0 -1 1; -1 0 -1; 0 0 0]; 
        W3D{4}=[0 -1 1; 1 0 -1; 0 0 0]; 
        W3D{5}=[0 -1 1; -1 0 1; 0 0 0];
        W3D{6}=[0 1 -1; 1 0 -1; 0 0 0]; 
        W3D{7}=[0 -1 -1; 1 0 1; 0 0 0];
        W3D{8}=[0 1 1; 1 0 -1; 0 0 0]; 
        W3D{9}=[0 1 1; -1 0 1; 0 0 0]; 
        W3D{10}=[0 1 1; 1 0 1; 0 0 0];
        W=W3D;
    end

    if nA==6 %A6: three connections, 2-cycle and feedforward connection
        W3D{1}=[0 -1 0;-1 0 -1; 0 0 0];
        W3D{2}=[0 1 0;-1 0 -1; 0 0 0]; 
        W3D{3}=[0 -1 0;1 0 -1; 0 0 0]; 
        W3D{4}=[0 -1 0;-1 0 1; 0 0 0]; 
        W3D{5}=[0 1 0;1 0 -1; 0 0 0]; 
        W3D{6}=[0 1 0;-1 0 1; 0 0 0]; 
        W3D{7}=[0 -1 0;1 0 1; 0 0 0]; 
        W3D{8}=[0 1 0;1 0 1; 0 0 0]; 
        W=W3D;
    end

    if nA==7 %A7: three connections in a 3-cycle
        W3D{1}=[0 -1 0; 0 0 -1; -1 0 0]; 
        W3D{2}=[0 1 0; 0 0 -1; -1 0 0];
        W3D{3}=[0 1 0; 0 0 1; -1 0 0];
        W3D{4}=[0 1 0; 0 0 1; 1 0 0];
        W=W3D;
    end
end

end