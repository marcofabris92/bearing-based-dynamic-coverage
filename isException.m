% i,j: current edge analysed
% k: node belonging to the common neighbourhood of i,j
% eccezione: flag of exception

function eccezione = isException(i,k,j)

global G P A epsilon
eccezione = 0;
epsilon = 0.001;

% A: angle ik^j
A = computeAngle(P(i,:),P(k,:),P(j,:));

if isempty(A)
    error('Invalid input.')
end

Nk = setdiff(neighbors(G,k),[i j]);
t = 0;
while ~eccezione && t < length(Nk)
    t = t+1;
    eccezione = MZ(i,k,Nk(t),j,Nk,0,0,eccezione);
end

end