function [detected] = VBA(r_c, psiD, L1, L2, N1, N2)

M = 4;
symb = [1+1i, 1-1i, -1+1i, -1-1i]; 
Kd = 28; 
Ns = M ^ (L1+L2); 
r_c  =  r_c(1+N1-L1 : end-N2+L2);   
psiD = psiD(1+N1-L1 : end-N2+L2);   

tStart = tic; 

survivor_seq = zeros(Ns, Kd);
detected_symbol = zeros(1, length(r_c));
cost = zeros(Ns, 1); 

statelength = L1 + L2; 
statevec = zeros(1, statelength); 
%matrix with the input values
U = zeros(Ns, M);
for state = 1:Ns
    for j = 1:M
        lastsymbols = [symb(statevec + 1), symb(j)]; 
        U(state, j) = lastsymbols * flipud(psiD);
    end
    statevec(statelength) = statevec(statelength) + 1;
    i = statelength;
    while (statevec(i) >= M && i > 1)
        statevec(i) = 0;
        i = i-1;
        statevec(i) = statevec(i) + 1;
    end
end

for k = 1 : length(r_c)

    nextcost = - ones(Ns, 1);
    pred = zeros(Ns, 1);
    nextstate = 0;
    
    for state = 1 : Ns
        
        for j = 1 : M   
            nextstate = nextstate + 1;
            if nextstate > Ns, nextstate = 1; end
            u = U(state, j);
            newstate_cost = cost(state) + abs(r_c(k) - u)^2;
            if nextcost(nextstate) == -1 ...    
                    || nextcost(nextstate) > newstate_cost 
                nextcost(nextstate) = newstate_cost;
                pred(nextstate) = state;
            end
        end
    end
    
    temp = zeros(size(survivor_seq));
    for nextstate = 1:Ns
        temp(nextstate, 1:Kd) = ...
            [survivor_seq(pred(nextstate), 2:Kd), ... 
            symb(mod(nextstate-1, M)+1)];       
    end
    [~, decided_index] = min(nextcost);   
    detected_symbol(1+k) = survivor_seq(decided_index, 1); 
    survivor_seq = temp;
    
    cost = nextcost;
end

toc(tStart)

detected_symbol(length(r_c)+2 : length(r_c)+Kd) = survivor_seq(decided_index, 1:Kd-1);

detected_symbol = detected_symbol(Kd+1 : end);
detected = detected_symbol;
detected = detected(2:end); 
end