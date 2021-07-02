#This function substitutes W_list_v5 - it needs to be in separate file but it is for the moment
function Wlist(nA,nW)
    if nA==1 #connectivity structures of first architecture
        if nW==1
            W=[0 -1 -1;-1 0 -1; -1 -1 0];
        elseif nW==2
            W=[0 1 -1;-1 0 -1; -1 -1 0];
        elseif nW==3
            W=[0 1 1;-1 0 -1; -1 -1 0];
        elseif nW==4
            W=[0 1 -1;1 0 -1; -1 -1 0];
        elseif nW==5
            W=[0 -1 -1;1 0 -1; 1 -1 0];
        elseif nW==6
            W=[0 -1 1;1 0 -1; -1 -1 0];
        elseif nW==7
            W=[0 1 1;1 0 -1; -1 -1 0];
        elseif nW==8
            W=[0 1 -1;1 0 -1; 1 -1 0];
        elseif nW==9
            W=[0 1 -1;-1 0 1; 1 -1 0];
        elseif nW==10
            W=[0 -1 -1;1 0 1; 1 1 0];
        elseif nW==11
            W=[0 -1 1;-1 0 1; 1 1 0];
        elseif nW==12
            W=[0 1 1;-1 0 1; -1 1 0];
        elseif nW==13
            W=[0 1 -1;-1 0 1; 1 1 0];
        elseif nW==14
            W=[0 1 1;1 0 1; 1 -1 0];
        elseif nW==15
            W=[0 1 1;1 0 1; 1 1 0];
        end
    elseif nA==2 #connectivity structures of second architecture
        if nW==1
            W=[0 0 -1;-1 0 -1; -1 -1 0];
        elseif nW==2
            W=[0 0 1;-1 0 -1; -1 -1 0];
        elseif nW==3
            W=[0 0 -1;1 0 -1; -1 -1 0];
        elseif nW==4
            W=[0 0 -1;-1 0 1; -1 -1 0];
        elseif nW==5
            W=[0 0 -1;-1 0 -1; 1 -1 0];
        elseif nW==6
            W=[0 0 -1;-1 0 -1; -1 1 0];
        elseif nW==7
            W=[0 0 1;1 0 -1; -1 -1 0];
        elseif nW==8
            W=[0 0 1;-1 0 1; -1 -1 0];
        elseif nW==9
            W=[0 0 1;-1 0 -1; 1 -1 0];
        elseif nW==10
            W=[0 0 1;-1 0 -1; -1 1 0];
        elseif nW==11
            W=[0 0 -1;1 0 1; -1 -1 0];
        elseif nW==12
            W=[0 0 -1;1 0 -1; 1 -1 0];
        elseif nW==13
            W=[0 0 -1;1 0 -1; -1 1 0];
        elseif nW==14
            W=[0 0 -1;-1 0 1; 1 -1 0];
        elseif nW==15
            W=[0 0 -1;-1 0 1; -1 1 0];
        elseif nW==16
            W=[0 0 -1;-1 0 -1; 1 1 0];
        elseif nW==17
            W=[0 0 1;1 0 1; -1 -1 0];
        elseif nW==18
            W=[0 0 1;1 0 -1; 1 -1 0];
        elseif nW==19
            W=[0 0 1;1 0 -1; -1 1 0];
        elseif nW==20
            W=[0 0 1;-1 0 1; 1 -1 0];
        elseif nW==21
            W=[0 0 1;-1 0 1; -1 1 0];
        elseif nW==22
            W=[0 0 1;-1 0 -1; 1 1 0];
        elseif nW==23
            W=[0 0 -1;1 0 1; 1 -1 0];
        elseif nW==24
            W=[0 0 -1;1 0 1; -1 1 0];
        elseif nW==25
            W=[0 0 -1;1 0 -1; 1 1 0];
        elseif nW==26
            W=[0 0 -1;-1 0 1; 1 1 0];
        elseif nW==27
            W=[0 0 1;1 0 1; 1 -1 0];
        elseif nW==28
            W=[0 0 1;1 0 1; -1 1 0];
        elseif nW==29
            W=[0 0 1;1 0 -1; 1 1 0];
        elseif nW==30
            W=[0 0 1;-1 0 1; 1 1 0];
        elseif nW==31
            W=[0 0 -1;1 0 1; 1 1 0];
        elseif nW==32
            W=[0 0 1;1 0 1; 1 1 0];
        end
    elseif nA==3 #connectivity structures of third architecture (triple toggle switch)
        if nW==1
            W=[0 0 -1;0 0 -1; -1 -1 0];
        elseif nW==2
            W=[0 0 1;0 0 -1; -1 -1 0];
        elseif nW==3
            W=[0 0 -1;0 0 -1; 1 -1 0];
        elseif nW==4
            W=[0 0 -1;0 0 -1; 1 1 0];
        elseif nW==5
            W=[0 0 1;0 0 1; -1 -1 0];
        elseif nW==6
            W=[0 0 1;0 0 -1; 1 -1 0];
        elseif nW==7
            W=[0 0 1;0 0 1; -1 1 0];
        elseif nW==8
            W=[0 0 -1;0 0 1; 1 1 0];
        elseif nW==9
            W=[0 0 1;0 0 1; 1 1 0];
        end
    elseif nA==4  #connectivity structures of fourth architecture
        if nW==1
            W=[0 -1 0; -1 0 -1; -1 0 0];
        elseif nW==2
            W=[0 1 0; -1 0 -1; -1 0 0];
        elseif nW==3
            W=[0 -1 0; 1 0 -1; -1 0 0];
        elseif nW==4
            W=[0 -1 0; -1 0 1; -1 0 0];
        elseif nW==5
            W=[0 -1 0; -1 0 -1; 1 0 0];
        elseif nW==6
            W=[0 1 0; 1 0 -1; -1 0 0];
        elseif nW==7
            W=[0 1 0; -1 0 1; -1 0 0];
        elseif nW==8
            W=[0 1 0; -1 0 -1; 1 0 0];
        elseif nW==9
            W=[0 -1 0; 1 0 1; -1 0 0];
        elseif nW==10
            W=[0 -1 0; 1 0 -1; 1 0 0];
        elseif nW==11
            W=[0 -1 0; -1 0 1; 1 0 0];
        elseif nW==12
            W=[0 1 0; 1 0 1; -1 0 0];
        elseif nW==13
            W=[0 1 0; 1 0 -1; 1 0 0];
        elseif nW==14
            W=[0 1 0; -1 0 1; 1 0 0];
        elseif nW==15
            W=[0 -1 0; 1 0 1; 1 0 0];
        elseif nW==16
            W=[0 1 0; 1 0 1; 1 0 0];
        end
    elseif nA==5  #connectivity structures of fifth architecture
        if nW==1
            W=[0 -1 -1; -1 0 -1; 0 0 0];
        elseif nW==2
            W=[0 1 -1; -1 0 -1; 0 0 0];
        elseif nW==3
            W=[0 -1 1; -1 0 -1; 0 0 0];
        elseif nW==4
            W=[0 -1 1; 1 0 -1; 0 0 0];
        elseif nW==5
            W=[0 -1 1; -1 0 1; 0 0 0];
        elseif nW==6
            W=[0 1 -1; 1 0 -1; 0 0 0];
        elseif nW==7
            W=[0 -1 -1; 1 0 1; 0 0 0];
        elseif nW==8
            W=[0 1 1; 1 0 -1; 0 0 0];
        elseif nW==9
            W=[0 1 1; -1 0 1; 0 0 0];
        elseif nW==10
            W=[0 1 1; 1 0 1; 0 0 0];
        end
    elseif nA==6 #connectivity structures of sixth architecture
        if nW==1
            W=[0 -1 0;-1 0 -1; 0 0 0];
        elseif nW==2
            W=[0 1 0;-1 0 -1; 0 0 0];
        elseif nW==3
            W=[0 -1 0;1 0 -1; 0 0 0];
        elseif nW==4
            W=[0 -1 0;-1 0 1; 0 0 0];
        elseif nW==5
            W=[0 1 0;1 0 -1; 0 0 0];
        elseif nW==6
            W=[0 1 0;-1 0 1; 0 0 0];
        elseif nW==7
            W=[0 -1 0;1 0 1; 0 0 0];
        elseif nW==8
            W=[0 1 0;1 0 1; 0 0 0];
        end
    elseif nA==7 #connectivity structures of seventh architecture
        if nW==1
            W=[0 -1 0; 0 0 -1; -1 0 0];
        elseif nW==2
            W=[0 1 0; 0 0 -1; -1 0 0];
        elseif nW==3
            W=[0 1 0; 0 0 1; -1 0 0];
        elseif nW==4
            W=[0 1 0; 0 0 1; 1 0 0];
        end
    end
   try
       return W
   catch
       println("Problem with Wlist functions: parameters might not be valid")
   end
end
